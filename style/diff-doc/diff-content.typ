#import "diff-function.typ": diff-string
#import "@preview/touying:0.6.1": utils

// Compare Typst's content tree instead of reducing it to plain text.

#let is-content(it) = type(it) == content
#let is-text(it) = is-content(it) and it.func() == text

// Equate encodes `#<label>` inside math as raw Typst-code content and later
// consumes it in a show rule. Wrapping this marker in styled text prevents the
// package from registering the equation label.
#let is-equate-label-marker(it) = {
  if not is-content(it) or it.func() != raw { return false }
  let fields = it.fields()
  (
    fields.at("block", default: true) == false
    and fields.at("lang", default: "") == "typc"
    and fields.at("text", default: "").match(regex("^<[^<>]+>$")) != none
  )
}

#let join-content(items) = {
  if items.len() == 0 { return [] }
  items.sum()
}

#let default-structure-plus(body) = [
  #underline(stroke: 1.25pt + blue, evade: false, body)
]

#let default-structure-minus(body) = [
  #underline(stroke: 1.25pt + red, evade: false, body)
]

#let compatible(a, b) = {
  if a == b { return true }
  if type(a) == array and type(b) == array and a.len() == b.len() {
    return a.zip(b).all(pair => compatible(pair.first(), pair.last()))
  }
  is-content(a) and is-content(b) and a.func() == b.func()
}

#let substitution-cost(a, b) = {
  if a == b { return 0 }
  if type(a) == array and type(b) == array {
    return if a.zip(b).any(pair => pair.first() == pair.last()) { 1 } else { 2 }
  }
  if compatible(a, b) { 1 } else { 2 }
}

// Wagner-Fischer alignment. It avoids a small structural edit turning all
// following siblings into a remove/add cascade.
#let align(old, new) = {
  let rows = (range(new.len() + 1),)

  for i in range(1, old.len() + 1) {
    let row = (i,)
    for j in range(1, new.len() + 1) {
      row.push(calc.min(
        rows.at(i - 1).at(j) + 1,
        row.at(j - 1) + 1,
        rows.at(i - 1).at(j - 1)
          + substitution-cost(old.at(i - 1), new.at(j - 1)),
      ))
    }
    rows.push(row)
  }

  let result = ()
  let i = old.len()
  let j = new.len()

  while i > 0 or j > 0 {
    if (
      i > 0 and j > 0 and compatible(old.at(i - 1), new.at(j - 1))
      and substitution-cost(old.at(i - 1), new.at(j - 1)) < 2
    ) {
      let cost = substitution-cost(old.at(i - 1), new.at(j - 1))
      if rows.at(i).at(j) == rows.at(i - 1).at(j - 1) + cost {
        result.push((
          kind: if cost == 0 { "equal" } else { "replace" },
          old: old.at(i - 1),
          new: new.at(j - 1),
        ))
        i -= 1
        j -= 1
        continue
      }
    }

    // In a tie, insertion is visited first. Reversing below then displays an
    // old removal before its new insertion.
    if j > 0 and (i == 0 or rows.at(i).at(j) == rows.at(i).at(j - 1) + 1) {
      result.push((kind: "insert", old: none, new: new.at(j - 1)))
      j -= 1
    } else {
      result.push((kind: "remove", old: old.at(i - 1), new: none))
      i -= 1
    }
  }

  result.rev()
}

#let same-nonchild-fields(a, b, child-name) = {
  let af = a.fields()
  let bf = b.fields()
  let _ = af.remove(child-name, default: none)
  let _ = bf.remove(child-name, default: none)
  // Labels identify content but do not change its visual structure. The
  // reconstructed result always adopts the label from the new node.
  let _ = af.remove("label", default: none)
  let _ = bf.remove("label", default: none)
  af == bf
}

// Introspected content fields cannot always be passed back to the element
// function. Recurse only through constructors whose calling convention is
// known; opaque template internals are safely kept from the new document.
#let can-rebuild-body(it) = {
  repr(it.func()) in (
    "align", "place",
    "block", "box", "caption", "cell", "circle", "columns", "ellipse",
    "emph", "equation", "figure", "heading", "hide", "highlight",
    "item", "footnote", "link", "lr", "op", "pad", "quote", "rect", "strong",
    "strike", "sub", "super", "underline", "overline",
  )
}

#let can-rebuild-children(it) = {
  repr(it.func()) in ("table", "grid", "header", "footer")
}

#let rebuild-body(it, body, keep-label: true) = {
  let fields = it.fields()
  let label = fields.at("label", default: none)
  if not can-rebuild-body(it) {
    // An unsafe removed labeled node cannot be cloned without re-registering
    // its label. Omitting that old copy is safer than emitting invalid content.
    return if label == none { it } else { [] }
  }
  let _ = fields.remove("label", default: none)
  let _ = fields.remove("body", default: none)
  let positional-alignment = repr(it.func()) in ("align", "place")
  let rebuilt = if positional-alignment and "alignment" in fields {
    // `align` and `place` take alignment as their first positional argument.
    // Their introspected field cannot be passed back as a named option.
    let alignment = fields.remove("alignment")
    (it.func())(alignment, body, ..fields)
  } else if repr(it.func()) == "link" and "dest" in fields {
    // `link` takes its destination first and its visible body second. This is
    // used by templates for mailto links, URLs, and author metadata.
    let dest = fields.remove("dest")
    (it.func())(dest, body, ..fields)
  } else {
    (it.func())(body, ..fields)
  }
  if not keep-label or label == none { rebuilt } else { [#rebuilt#label] }
}

#let rebuild-children(it, children, keep-label: true) = {
  let fields = it.fields()
  let label = fields.at("label", default: none)
  if not can-rebuild-children(it) {
    return if label == none { it } else { [] }
  }
  let _ = fields.remove("label", default: none)
  let _ = fields.remove("children", default: none)
  let rebuilt = (it.func())(..children, ..fields)
  if not keep-label or label == none { rebuilt } else { [#rebuilt#label] }
}

// Removed content must not register labels: a changed labeled element is
// rendered twice (old and new), but references should resolve to the new one.
#let without-labels(it) = {
  if not is-content(it) { return it }
  if utils.is-sequence(it) {
    return join-content(it.children.map(without-labels))
  }
  if utils.is-styled(it) {
    return utils.reconstruct-styled(it, without-labels(it.child))
  }

  let fields = it.fields()
  if "body" in fields and is-content(fields.body) and can-rebuild-body(it) {
    return rebuild-body(
      it,
      without-labels(fields.body),
      keep-label: false,
    )
  }
  if (
    "children" in fields and type(fields.children) == array
    and can-rebuild-children(it)
  ) {
    return rebuild-children(
      it,
      fields.children.map(without-labels),
      keep-label: false,
    )
  }
  it
}

#let table-row-groups(children, column-count) = {
  let groups = ()
  let index = 0
  while index < children.len() {
    if children.at(index).func() == table.cell {
      let end = calc.min(index + column-count, children.len())
      groups.push(children.slice(index, end))
      index = end
    } else {
      // Headers and footers already own their cells and form a logical row.
      groups.push((children.at(index),))
      index += 1
    }
  }
  groups
}

#let diff-content(
  a,
  b,
  format-plus: x => text(x, fill: blue, weight: "bold"),
  format-minus: x => strike(text(x, fill: red, size: 0.75em)),
  format-structure-plus: default-structure-plus,
  format-structure-minus: default-structure-minus,
  split-regex: "[^A-Za-z0-9]",
) = {
  let walk(old, new, math-mode: false) = {
    let mark-node(
      node,
      structure-formatter,
      text-formatter,
      keep-label: true,
      math-mode: false,
    ) = {
      if not keep-label { node = without-labels(node) }
      if is-equate-label-marker(node) {
        return if keep-label { node } else { [] }
      }
      if is-text(node) {
        return text-formatter(node.text)
      }
      if node.func() == ref {
        // A removed reference may target a label which exists only in the old
        // document. Render its source-like name without resolving it.
        return if keep-label {
          text-formatter(node)
        } else {
          text-formatter("@" + str(node.target))
        }
      }
      if utils.is-sequence(node) {
        if node.children.len() == 0 { return [] }
        return join-content(node.children.map(
          child => mark-node(
            child,
            structure-formatter,
            text-formatter,
            keep-label: keep-label,
            math-mode: math-mode,
          ),
        ))
      }
      let fields = node.fields()
      if node.func() == figure and "body" in fields {
        let label = fields.remove("label", default: none)
        let body = fields.remove("body")
        let caption = fields.remove("caption", default: none)
        if caption != none {
          caption = mark-node(
            caption,
            structure-formatter,
            text-formatter,
            keep-label: keep-label,
            math-mode: false,
          )
        }
        let rebuilt = (node.func())(
          structure-formatter(body),
          caption: caption,
          ..fields,
        )
        return if keep-label and label != none {
          [#rebuilt#label]
        } else {
          rebuilt
        }
      }
      if "body" in fields and is-content(fields.body) {
        if not can-rebuild-body(node) {
          return if keep-label { node } else { [] }
        }
        let child-math-mode = math-mode or node.func() == math.equation
        rebuild-body(node, mark-node(
          fields.body,
          structure-formatter,
          text-formatter,
          keep-label: keep-label,
          math-mode: child-math-mode,
        ))
      } else if "children" in fields and type(fields.children) == array {
        if not can-rebuild-children(node) {
          return if keep-label { node } else { [] }
        }
        rebuild-children(
          node,
          fields.children.map(child => mark-node(
            child,
            structure-formatter,
            text-formatter,
            keep-label: keep-label,
            math-mode: math-mode,
          )),
        )
      } else if math-mode {
        text-formatter(node)
      } else {
        structure-formatter(node)
      }
    }

    let walk-list = (old, new, math-mode: false) => {
      let output = ()
      for change in align(old, new) {
        if change.kind == "equal" {
          output.push(change.new)
        } else if change.kind == "replace" {
          output.push(walk(
            change.old,
            change.new,
            math-mode: math-mode,
          ))
        } else if change.kind == "remove" {
          output.push(mark-node(
            change.old,
            format-structure-minus,
            format-minus,
            keep-label: false,
            math-mode: math-mode,
          ))
        } else {
          output.push(mark-node(
            change.new,
            format-structure-plus,
            format-plus,
            math-mode: math-mode,
          ))
        }
      }
      output
    }

    let walk-table-children = (old, new, column-count) => {
      let old-rows = table-row-groups(old, column-count)
      let new-rows = table-row-groups(new, column-count)
      let output = ()

      for change in align(old-rows, new-rows) {
        if change.kind == "equal" {
          output += change.new
        } else if change.kind == "replace" {
          for (old-cell, new-cell) in change.old.zip(change.new) {
            output.push(walk(old-cell, new-cell))
          }
        } else if change.kind == "remove" {
          for cell in change.old {
            output.push(mark-node(
              cell,
              format-structure-minus,
              format-minus,
              keep-label: false,
            ))
          }
        } else {
          for cell in change.new {
            output.push(mark-node(
              cell,
              format-structure-plus,
              format-plus,
            ))
          }
        }
      }
      output
    }

    if old == new { return new }

    if is-text(old) and is-text(new) {
      return diff-string(
        old.text,
        new.text,
        format-plus: format-plus,
        format-minus: format-minus,
        split-regex: split-regex,
      )
    }

    if not compatible(old, new) {
      return join-content((
        mark-node(
          old,
          format-structure-minus,
          format-minus,
          keep-label: false,
          math-mode: math-mode,
        ),
        mark-node(
          new,
          format-structure-plus,
          format-plus,
          math-mode: math-mode,
        ),
      ))
    }

    if utils.is-sequence(old) and utils.is-sequence(new) {
      return join-content(walk-list(
        old.children,
        new.children,
        math-mode: math-mode,
      ))
    }

    if utils.is-styled(old) and utils.is-styled(new) {
      // Show/set rule closures from two separately included documents do not
      // compare equal even when their source is identical. Preserve the new
      // style context and compare the content below it.
      return utils.reconstruct-styled(new, walk(
        old.child,
        new.child,
        math-mode: math-mode,
      ))
    }

    let old-fields = old.fields()
    let new-fields = new.fields()

    if (
      "body" in old-fields and "body" in new-fields
      and is-content(old-fields.body) and is-content(new-fields.body)
      and same-nonchild-fields(old, new, "body")
      and can-rebuild-body(new)
    ) {
      let child-math-mode = math-mode or old.func() == math.equation
      return rebuild-body(new, walk(
        old-fields.body,
        new-fields.body,
        math-mode: child-math-mode,
      ))
    }

    if (
      "body" in old-fields and "body" in new-fields
      and not can-rebuild-body(new)
    ) {
      // Custom show rules and package templates can expose synthetic fields
      // which their constructor does not accept. Keep the valid new node.
      return new
    }

    if (
      "children" in old-fields and "children" in new-fields
      and type(old-fields.children) == array
      and type(new-fields.children) == array
      and same-nonchild-fields(old, new, "children")
      and can-rebuild-children(new)
    ) {
      if (
        old.func() == table and new.func() == table
        and "columns" in new-fields
        and type(new-fields.columns) == array
        and new-fields.columns.len() > 0
      ) {
        return rebuild-children(
          new,
          walk-table-children(
            old-fields.children,
            new-fields.children,
            new-fields.columns.len(),
          ),
        )
      }
      return rebuild-children(
        new,
        walk-list(
          old-fields.children,
          new-fields.children,
          math-mode: math-mode,
        ),
      )
    }

    if (
      "children" in old-fields and "children" in new-fields
      and not can-rebuild-children(new)
    ) {
      return new
    }

    // Scalar property changes (image path, table columns, geometry, etc.) are
    // represented as a valid old node followed by a valid new node.
    join-content((
      mark-node(
        old,
        format-structure-minus,
        format-minus,
        keep-label: false,
        math-mode: math-mode,
      ),
      mark-node(
        new,
        format-structure-plus,
        format-plus,
        math-mode: math-mode,
      ),
    ))
  }

  walk(a, b)
}
