#let split-words(str, pattern) = {
  let separator = regex(pattern)
  let output = ()
  let current = ""

  for cluster in str.clusters() {
    current += cluster
    if separator in cluster {
      output.push(current)
      current = ""
    }
  }

  if current != "" { output.push(current) }
  output
}

// Return grouped (chunks, states), where state is -1 for removal, 0 for an
// equal chunk, and 1 for insertion. This implementation deliberately handles
// empty arrays and one-token replacements, which are common in math content.
#let diff-string-array(a, b, split-regex) = {
  let old = split-words(a, split-regex)
  let new = split-words(b, split-regex)
  let rows = (range(new.len() + 1).map(_ => 0),)

  for i in range(1, old.len() + 1) {
    let row = (0,)
    for j in range(1, new.len() + 1) {
      if old.at(i - 1) == new.at(j - 1) {
        row.push(rows.at(i - 1).at(j - 1) + 1)
      } else {
        row.push(calc.max(rows.at(i - 1).at(j), row.at(j - 1)))
      }
    }
    rows.push(row)
  }

  let operations = ()
  let i = old.len()
  let j = new.len()

  while i > 0 or j > 0 {
    if i > 0 and j > 0 and old.at(i - 1) == new.at(j - 1) {
      operations.push((old.at(i - 1), 0))
      i -= 1
      j -= 1
    } else if j > 0 and (i == 0 or rows.at(i).at(j - 1) >= rows.at(i - 1).at(j)) {
      operations.push((new.at(j - 1), 1))
      j -= 1
    } else {
      operations.push((old.at(i - 1), -1))
      i -= 1
    }
  }

  operations = operations.rev()
  if operations.len() == 0 { return ((), ()) }

  let chunks = ()
  let states = ()
  let current = operations.first().at(0)
  let state = operations.first().at(1)

  for operation in operations.slice(1) {
    if operation.at(1) == state {
      current += operation.at(0)
    } else {
      chunks.push(current)
      states.push(state)
      current = operation.at(0)
      state = operation.at(1)
    }
  }

  chunks.push(current)
  states.push(state)
  (chunks, states)
}

#let diff-string(
  a,
  b,
  format-plus: x => text(x, fill: blue, weight: "bold"),
  format-minus: x => strike(text(x, fill: red, size: 0.75em)),
  split-regex: "[^A-Za-z0-9]",
) = {
  let (chunks, states) = diff-string-array(a, b, split-regex)

  for (chunk, state) in chunks.zip(states) {
    if state == 0 {
      text(chunk)
    } else if state == 1 {
      format-plus(chunk)
    } else {
      format-minus(chunk)
    }
  }
}
