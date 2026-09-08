
// フォント
#let mincho = ((name: "Times New Roman", covers: "latin-in-cjk"), "Harano Aji Mincho")
#let gothic = ((name: "Helvetica", covers: "latin-in-cjk"), "Harano Aji Gothic")
#let english_title = ("Helvetica",)
#let mathf = ("Latin Modern Math", ..mincho)
#let codef = ("Noto Mono for Powerline", ..gothic)

#let is_check-contents = state("check-contents", false)

// 外部パッケージ
#import "@preview/equate:0.3.2": equate
#import "@preview/roremu:0.1.0": roremu
#import "@preview/physica:0.9.8": *
#import "@preview/wordometer:0.1.5": total-words, word-count
#import "@preview/cjk-spacer:0.2.1": *

#let abst_init(body) = {
  //言語設定
  set text(lang: "ja", cjk-latin-spacing: auto, fallback: false)

  //　ページサイズ設定
  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 15mm,
      left: 25mm,
      right: 10mm,
    ),
  )

  //パラグラフ設定
  set par(
    justify: true,
    first-line-indent: 1em,
    leading: 0.825em,
    spacing: 0.825em,
  )

  // テキスト設定
  set text(
    size: 12pt,
    font: mincho,
  )

  // 数式設定
  show math.equation: set text(font: mathf)

  // 図表設定
  set figure(placement: bottom)
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

    let kind-length = 0pt
    let kind-content = none

    if it.kind != "sub-figure" {
      // サブ図以外の場合，図番号を更新
      counter(figure.where(kind: "sub-figure")).update(0)
    }
    // kind-contentの設定
    if it.kind == table {
      kind-content = [Table ] + context counter(figure.where(kind: table)).display() + [　]
    } else if it.kind == raw {
      kind-content = [Code ] + context counter(figure.where(kind: raw)).display() + [　]
    } else if it.kind == "sub-figure" {
      kind-content = (
        it.supplement + context numbering("(a)", counter(figure.where(kind: "sub-figure")).get().at(0)) + [　]
      )
    } else {
      kind-content = [Fig. ] + context counter(figure.where(kind: image)).display() + [　]
    }

    // kind-contentの長さを測定
    kind-length = measure(box(kind-content)).width
    let space-length = measure(sym.space.thin).width

    // captionの出力
    block[
      #set par(hanging-indent: kind-length - space-length)
      #set align(left)

      #box(kind-content)#sym.wj#it.body
    ]
  }
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
    table(
      columns: (5%, 95%),
      align: (right, left),
      stroke: none,
      table.hline(start: 1),
      ..for value in it.lines {
        (text(fill: black, str(value.number)), value)
      },
      table.hline(start: 1),
    )
  }
  show raw.where(block: false): it => {
    set text(font: codef)
    it
  }

  // 日本語間のコード改行を無効化
  show: cjk-spacer

  body
}

#let abst_title(
  title: [],
  laboratory: [],
  authors: (
    (student-id: "75*****", name: "機械　工作"),
    (student-id: "75*****", name: "野田　理科"),
  ),
) = {
  // タイトル
  align(center)[
    #text(
      font: gothic,
      size: 16pt,
      weight: "bold",
      title,
    )
  ]
  v(1em)

  // 研究室名
  set align(left)
  h(-1em)
  [［] + laboratory + [研究室］]
  h(1fr)

  // 氏名
  let author_arr = authors.map(a => a.student-id + [ ] + a.name)
  if author_arr.len() >= 3 {
    let linebreak_count = int(calc.round(author_arr.len() / 2))
    for value in range(linebreak_count - 1) {
      author_arr.at(2 * value) + [　　] + author_arr.at(2 * value + 1)
      linebreak()
      h(1fr)
    }
    [#author_arr.slice(2 * (linebreak_count - 1), author_arr.len()).join([　　])]
  } else {
    [#author_arr.join([　　])]
  }
  v(1em)
}

#let abst_en_init(body) = {
  set par(first-line-indent: 0pt)
  show: word-count
  body
}

#let abst_title_en(
  title: [],
  laboratory: [],
  authors: (
    (student-id: "75*****", name: "Kouji KIKAI"),
    (student-id: "75*****", name: "Rika NODA"),
  ),
) = {
  pagebreak()
  set par(first-line-indent: 0pt)

  // タイトル
  align(center)[
    #text(
      size: 12pt,
      font: english_title,
      weight: "bold",
      title,
    )
  ]
  v(1em)

  // 研究室名
  set align(left)
  [\[] + laboratory + [ Group\]]
  h(1fr)

  // 氏名
  let num = 1
  let author_arr = authors.map(a => a.student-id + [~] + a.name)
  [#author_arr.join([, ], last: [ and ])]
  v(1em)
}

#let check-contents(body) = {
  // 行番号の設定
  set par.line(numbering: n => text(size: 8pt, font: codef)[#n], numbering-scope: "page", number-clearance: 10pt)

  is_check-contents.update(true)

  body

  [#h(1fr) (#total-words words)]
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        LOCAL FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#import "local_function.typ": *

#let abst_en_translate(body) = {
  let title-color = luma(75)
  let body-color = luma(230)
  set align(left)

  context {
    if is_check-contents.final() {
      block(
        stack(
          block(
            width: 100%,
            fill: title-color,
            inset: (x: 1em, y: 0.6em),
            radius: (top: 0.5em),
            stroke: title-color + 1.5pt,
            text(fill: white, font: gothic, weight: "bold", [英文概要の日本語訳]),
          ),
          block(
            width: 100%,
            inset: 1em,
            fill: body-color,
            radius: (bottom: 0.5em),
            stroke: title-color + 1.5pt,
            body,
          ),
        ),
        breakable: false,
      )
      v(1em)
    }
  }
}
