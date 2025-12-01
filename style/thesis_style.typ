
// フォント
#let mincho = ("Times New Roman", "Harano Aji Mincho")
#let gothic = ("Helvetica", "Harano Aji Gothic")
#let mathf = ("Latin Modern Math", ..mincho)
#let codef = "Noto Mono for Powerline"

// 日本語間のコード改行
#let cjkre = regex(
  "([\u3000-\u303F\u3040-\u30FF\u31F0-\u31FF\u3200-\u9FFF\uFF00-\uFFEF][　！”＃＄％＆’（）*+，−．／：；＜＝＞？＠［＼］＾＿｀｛｜｝〜、。￥・]*)[ ]+([\u3000-\u303F\u3040-\u30FF\u31F0-\u31FF\u3200-\u9FFF\uFF00-\uFFEF])[ ]*",
)


// コメント内容
#let comment-content-arr = state("comment-content-arr", ())

// 外部パッケージ
#import "@preview/equate:0.3.2": equate
#import "@preview/roremu:0.1.0": roremu
#import "@preview/physica:0.9.6": *
#import "@preview/unify:0.7.1": *

//　文献パッケージ
#import "@preview/enja-bib:0.1.0": *
#import bib-setting-jsme: *

// 初期設定
#let thesis_init(body) = {
  //言語設定
  set text(lang: "ja", cjk-latin-spacing: auto, fallback: false)

  // ページサイズ設定
  set page(
    paper: "a4",
    margin: (left: 25mm, right: 10mm, top: 33mm, bottom: 30mm),
    //numbering: "1",
    //number-align: center,
  )

  //パラグラフ設定
  set par(
    justify: true,
    first-line-indent: 1em,
    leading: 1em,
    spacing: 1em,
  )

  // テキスト設定
  set text(
    size: 12pt,
    font: mincho,
  )

  // 見出し設定
  set heading(numbering: "1.1", supplement: [第])
  show heading: (
    it => {
      set text(font: gothic, size: 1.2em)
      set par(first-line-indent: 0em)
      if it.numbering != none {
        context counter(heading).display() + [　] + it.body
      } else {
        it.body
      }
    }
  )
  show ref: it => {
    if it.element == none {
      //存在しないラベルはエラーとなる
      it
    } else if it.element.func() == heading {
      if it.supplement != auto {
        it
      } else if it.element.level == 1 {
        it
        [章]
      } else {
        it
        [節]
      }
    } else {
      if it.has("element") {
        if it.element.has("kind") {
          if it.element.kind == "sub-figure" {
            link(it.target)[
              #numbering("a", it.element.counter.at(it.target).at(0))
            ]
          } else {
            it
          }
        } else {
          it
        }
      } else {
        it
      }
    }
  }

  show link: it => {
    //set text(fill: blue)
    it
  }

  show heading.where(level: 1): (
    it => {
      set text(font: gothic, size: 1.33em)
      set par(first-line-indent: 0em)

      pagebreak()
      if it.numbering != none {
        [第] + context counter(heading).display() + [章]
        v(0.25em)
        it.body
      } else {
        it.body
        v(1em)
      }
      v(0.1em)
    }
  )

  show heading.where(level: 2): (
    it => {
      set text(font: gothic, size: 1.3em)
      set par(first-line-indent: 0em)
      v(0.5em)
      if it.numbering != none {
        context counter(heading).display() + [　] + it.body
      } else {
        it.body
      }
      v(0.5em)
    }
  )

  // 数式設定
  show math.equation: set text(font: mathf)
  show math.equation: set block(spacing: 2em)
  set math.equation(numbering: "(1)")
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }
  set math.equation(numbering: num => "(" + (str(counter(heading).get().at(0)) + "." + str(num)) + ")")
  show math.equation.where(block: true): set align(left) // set block equation align
  show math.equation.where(block: true): it => {
    // set block equation space
    grid(
      columns: (2em, auto),
      [], it,
    )
  }
  show: equate.with(breakable: true, number-mode: "line")
  show math.equation.where(block: false): it => {
    let ghost = hide(text(font: "Adobe Blank", "\u{375}")) // 欧文ゴースト
    ghost
    it
    ghost
  }

  // 図表設定
  set figure(placement: top)
  set figure.caption(separator: [　])
  show figure: set block(breakable: true)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [コード])
  show figure.caption: it => {
    // if figure caption is image ...
    set par(leading: 4.5pt, justify: true)
    set text(size: 11.4pt)
    set align(top)
    grid(
      columns: 2,
      {
        if it.kind != "sub-figure" {
          // サブ図以外の場合，図番号を更新
          counter(figure.where(kind: "sub-figure")).update(0)
        }

        if it.kind == table {
          [Table ] + context counter(figure.where(kind: table)).display() + [　]
        } else if it.kind == raw {
          [Code ] + context counter(figure.where(kind: raw)).display() + [　]
        } else if it.kind == "sub-figure" {
          it.supplement
          context numbering("(a)", counter(figure.where(kind: "sub-figure")).get().at(0))
          [　]
        } else {
          [Fig. ] + context counter(figure.where(kind: image)).display() + [　]
        }
      },
      align(left)[#it.body],
    )
  }
  set figure(numbering: num => str(counter(heading).get().at(0)) + "." + str(num))
  //表の設定
  let frame(stroke) = (x, y) => (
    left: if x > 0 { stroke } else { none },
    right: none,
    top: if y == 0 { stroke } else if y == 1 {
      /* pat-single + 5pt  */
      0pt
    } else { 0pt },
    bottom: black + 0.5pt,
  )
  set table(stroke: none)
  set table(
    stroke: frame(black + 0.5pt),
    row-gutter: (2pt, auto),
  )
  set table.hline(stroke: 0.5pt)
  set table.vline(stroke: 0.5pt)

  //コードの設定
  show raw.where(block: true): it => {
    set text(font: codef)
    set table(stroke: (x, y) => (
      //left: if x == 1 { 0.5pt } else { 0pt },
      //right: if x == 1 { 0.5pt } else { 0pt },
      top: if y == 0 and x == 1 { 0.5pt } else { 0pt },
      bottom: if x == 1 { 0.5pt } else { 0pt },
    ))
    table(
      columns: (5%, 95%),
      align: (right, left),
      ..for value in it.lines {
        (text(fill: black, str(value.number)), value)
      }
    )
  }
  show raw.where(block: false): it => {
    set text(font: codef)
    h(0.5em)
    it
    h(0.5em)
  }

  //リストの設定
  set list(indent: 2em, body-indent: 0.75em, spacing: 1em, marker: [•])
  set enum(indent: 2em, body-indent: 0.75em, spacing: 1em)

  //下線設定
  set underline(offset: 4pt)

  //文献設定
  show: bib-init

  // 日本語間のコード改行を無効化
  show cjkre: it => it.text.match(cjkre).captures.sum()

  body
}

#let thesis_signary(body) = {
  counter(page).update(0)

  set page(
    header: context [
      //ヘッダーの設定
      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #let pages-with-first-level-heading-numbering = all-headings-before.at(-1, default: none)
      #if pages-with-first-level-heading-numbering != none {
        pages-with-first-level-heading-numbering = pages-with-first-level-heading-numbering.numbering
      }

      #if not has-first-level-heading-on-current-page and all-headings-before.at(-1, default: none) != none {
        h(1fr)
        text(font: mincho, weight: "regular")[#numbering("i", counter(page).get().at(0))]
        v(-0.5em)
      }
    ],
    footer: context [
      //フッターの設定
      #set align(center)

      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #if has-first-level-heading-on-current-page {
        text(font: mincho, weight: "regular")[— i —]
      }
    ],
    numbering: "i",
  )

  body
}

#let thesis_main(body) = {
  counter(page).update(0)

  // ヘッダー設定
  set page(
    header: context [
      //ヘッダーの設定
      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #let pages-with-first-level-heading-numbering = all-headings-before.at(-1, default: none)
      #if pages-with-first-level-heading-numbering != none {
        pages-with-first-level-heading-numbering = pages-with-first-level-heading-numbering.numbering
      }

      #if not has-first-level-heading-on-current-page and all-headings-before.at(-1, default: none) != none {
        let body = all-headings-before.at(-1).body
        set text(font: gothic, weight: "bold")
        if pages-with-first-level-heading-numbering != none {
          [第] + [#counter(heading).get().at(0)] + [章　]
        }
        body + h(1fr)
        text(font: mincho, weight: "regular")[#counter(page).get().at(0)]
        v(-0.5em)
        line(length: 90%)
      }
    ],
    footer: context [
      //フッターの設定
      #set align(center)

      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #if has-first-level-heading-on-current-page {
        text(font: mincho, weight: "regular")[— #counter(page).get().at(0) —]
      }
    ],
    numbering: "1",
  )

  body
}

#let thesis-appendix(body) = {
  //番号をリセット
  counter(heading).update(0)

  set heading(numbering: "A", outlined: false)
  show heading: (
    it => {
      set text(font: gothic, size: 1.2em)
      set par(first-line-indent: 0em)

      it.body
    }
  )

  show heading.where(level: 1): set heading(outlined: true)
  show heading.where(level: 1): (
    it => {
      set text(font: gothic, size: 1.33em)
      set par(first-line-indent: 0em)

      pagebreak()
      if it.numbering != none {
        [付録] + context counter(heading).display()
        v(0.25em)
        it.body
      } else {
        it.body
        v(1em)
      }
      v(0.1em)
    }
  )

  set page(
    header: context [
      //ヘッダーの設定
      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #let pages-with-first-level-heading-numbering = all-headings-before.at(-1, default: none)
      #if pages-with-first-level-heading-numbering != none {
        pages-with-first-level-heading-numbering = pages-with-first-level-heading-numbering.numbering
      }

      #if not has-first-level-heading-on-current-page and all-headings-before.at(-1, default: none) != none {
        let body = all-headings-before.at(-1).body
        set text(font: gothic, weight: "bold")
        if pages-with-first-level-heading-numbering != none {
          [付録] + [#numbering("A", counter(heading).get().at(0))] + [　]
        }
        body + h(1fr)
        text(font: mincho, weight: "regular")[#counter(page).get().at(0)]
        v(-0.5em)
        line(length: 90%)
      }
    ],
  )

  set math.equation(numbering: num => "(" + (str(numbering("A", counter(heading).get().at(0))) + "." + str(num)) + ")")
  set figure(numbering: num => str(numbering("A", counter(heading).get().at(0))) + "." + str(num))

  set figure(placement: top)

  body
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                          COVER PAGE
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let number-to-zenkaku(num, nonum: false) = {
  let zenkaku = ("０", "１", "２", "３", "４", "５", "６", "７", "８", "９")
  let hankaku = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  let result = ""
  for c in str(num) {
    if not zenkaku.contains(c) {
      if hankaku.contains(c) {
        result += zenkaku.at(int(c))
      } else if nonum {
        result += "＊"
      }
    } else {
      result += c
    }
  }
  result
}

#let zenkaku-to-number(num) = {
  let zenkaku = ("０", "１", "２", "３", "４", "５", "６", "７", "８", "９")
  let hankaku = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

  let result = ""
  for c in str(num) {
    if not hankaku.contains(c) {
      for index in range(10) {
        if zenkaku.at(index) == c {
          result += hankaku.at(index)
          break
        }
      }
    } else {
      result += c
    }
  }
  int(result)
}

#let linebreak_num(num) = {
  for index in range(num + 1) {
    linebreak()
  }
}

#let thesis_title(
  title: [タイトル],
  year: "2025",
  master: false,
  month: "2",
  institution: none,
  laboratory: [〇〇],
  authors: (
    (student-id: "75*****", name: "機械　工作"),
  ),
) = {
  set page(
    margin: (left: 25mm, right: 10mm, top: 25mm, bottom: 15mm),
  )
  set par(spacing: 1.2em)
  set align(center)
  v(12em)
  number-to-zenkaku(year) + [年度]
  if master {
    [修士論文]
  } else {
    [卒業論文]
  }
  v(2.5em)
  text(size: 18pt)[#title]
  v(13em)
  let up_year = str(zenkaku-to-number(year) + 1)
  number-to-zenkaku(up_year) + [年] + number-to-zenkaku(month) + [月]
  v(2.5em)
  if institution != none {
    institution
  } else {
    if master {
      [東京理科大学大学院創域理工学研究科機械航空宇宙工学専攻]
    } else {
      [東京理科大学創域理工学部機械航空宇宙工学科]
    }
  }
  v(1em)
  laboratory + [研究室]
  v(4em)
  set align(left)
  grid(
    columns: (17em, auto),
    [],
    {
      for value in authors {
        number-to-zenkaku(value.student-id, nonum: true) + h(2em) + value.name + linebreak()
      }
    },
  )
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        OUTLINE FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let outline-page = {
  show outline.entry: it => {
    set par(first-line-indent: 0em)

    let indent-size = 1em * (it.level - 1)
    h(indent-size)

    link(it.element.location(), it.prefix())

    context {
      let req_h = 150pt - here().position().x
      if req_h < 2em.to-absolute() {
        req_h = 2em
      }
      h(req_h)
    }
    link(it.element.location(), it.element.body)
    h(1em)
    it.fill
    link(it.element.location(), it.page())
    linebreak()
  }

  show outline.entry.where(level: 1): it => {
    set par(first-line-indent: 0em, spacing: 1.2em)

    if it.element.numbering != none {
      if it.element.numbering == "A" {
        [付録] + link(it.element.location(), it.prefix())
      } else {
        [第] + link(it.element.location(), it.prefix()) + [章]
      }

      context {
        let req_h = 150pt - here().position().x
        if req_h < 2em.to-absolute() {
          req_h = 2em
        }
        h(req_h)
      }

      link(it.element.location(), it.element.body)
    } else {
      link(it.element.location(), it.body())
    }
    h(1em)
    it.fill
    link(it.element.location(), it.page())
    linebreak()
  }

  set outline.entry(fill: box(width: 1fr, repeat(h(2pt) + sym.dot.c + h(2pt))) + h(8pt))
  outline()
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        CHECK FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let check-contents(body) = {
  // 行番号の設定
  set par.line(numbering: n => text(size: 8pt, font: codef)[#n], numbering-scope: "page", number-clearance: 10pt)

  body

  // チェックページの有効化
  let check-page = true
  if check-page {
    context {
      let comment-contents = query(figure.where(kind: "comment"))
      let comment-arr = comment-content-arr.final()

      if comment-contents != () {
        // コメントがある場合
        text(size: 1.2em, font: gothic, weight: "bold")[コメント]

        let comment-table = ()
        let num = 0
        for value in comment-contents {
          comment-table.push(link(value.location(), str(counter(page).at(value.location()).at(0))))
          comment-table.push(link(value.location(), comment-arr.at(num)))
          num += 1
        }

        table(
          columns: (auto, 1fr),
          align: (center, left),
          table.header[ページ番号][タイトル],
          table.hline(),
          ..comment-table,
        )
      }

      let alert-contents = ()
      let fig-contents = query(figure.where(kind: image))
      let fig-reference = query(ref)

      for value in fig-contents {
        let lab = value.has("label")

        if not lab {
          //ラベルがない場合
          alert-contents.push((value.location(), [図のラベルがありません]))
        } else {
          //ラベルがある場合
          let exist-ref = false
          for index in fig-reference {
            if index.target == value.label {
              exist-ref = true
              break
            }
          }

          if not exist-ref {
            alert-contents.push((value.location(), [図が文中で言及されていません]))
          }
        }
      }

      if alert-contents != () {
        //アラートがある場合
        text(size: 1.2em, font: gothic, weight: "bold")[警告]

        let tmp = query(heading.where(numbering: "A"))
        let appendix-first-page = locate(here()).page() + 1000

        if tmp.len() != 0 {
          //付録がある場合
          tmp = tmp.at(0)
          appendix-first-page = counter(page).at(tmp.location()).at(0)
        }

        let alert-table = ()
        let num = 0
        for value in alert-contents {
          let set-fig-num = (
            str(counter(heading).at(value.at(0)).at(0)) + "." + str(counter(figure.where(kind: image)).at(value.at(0)).at(0))
          )

          if appendix-first-page <= counter(page).at(value.at(0)).at(0) {
            set-fig-num = (
              str(numbering("A", counter(heading).at(value.at(0)).at(0)))
                + "."
                + str(counter(figure.where(kind: image)).at(value.at(0)).at(0))
            )
          }

          alert-table.push(link(value.at(0), str(counter(page).at(value.at(0)).at(0))))
          alert-table.push(link(value.at(0), set-fig-num))
          alert-table.push(link(value.at(0), value.at(1)))
          num += 1
        }

        table(
          columns: (auto, auto, 1fr),
          align: (center, center, left),
          table.header[ページ番号][図番号][内容],
          table.hline(),
          ..alert-table,
        )
      }
    }
  }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        LOCAL FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#import "local_function.typ": *

#let comment(title: none, body) = {
  let title-color = luma(75)
  let body-color = luma(230)

  if title != none {
    figure(
      [
        #set align(left)
        #block(
          stack(
            block(
              width: 100%,
              fill: title-color,
              inset: (x: 1em, y: 0.6em),
              radius: (top: 0.5em),
              stroke: title-color + 1.5pt,
              text(fill: white, font: gothic, weight: "bold", title),
            ),
            block(width: 100%, inset: 1em, fill: body-color, radius: (bottom: 0.5em), stroke: title-color + 1.5pt, body),
          ),
          breakable: false,
        )
      ],
      placement: none,
      kind: "comment",
      supplement: [コメント],
    )
  } else {
    figure(
      [
        #set align(left)
        #block(width: 100%, inset: 1em, fill: body-color, radius: 0.5em, stroke: title-color + 1.5pt, body, breakable: false)
      ],
      placement: none,
      kind: "comment",
      supplement: [コメント],
    )
  }

  comment-content-arr.update(it => {
    let output-arr = it
    if title != none {
      output-arr.push(title)
    } else {
      output-arr.push([無題])
    }
    output-arr
  })
}
