
// フォント
#let mincho = ("Times New Roman", "Harano Aji Mincho")
#let gothic = ("Helvetica", "Harano Aji Gothic")
#let english_title = ("Arial", "CMU Sans Serif")
#let mathf = ("Latin Modern Math", ..mincho)
#let codef = ("Noto Mono for Powerline")

// 日本語間のコード改行
#let cjkre = regex("([\u3000-\u303F\u3040-\u30FF\u31F0-\u31FF\u3200-\u9FFF\uFF00-\uFFEF][　！”＃＄％＆’（）*+，−．／：；＜＝＞？＠［＼］＾＿｀｛｜｝〜、。￥・]*)[ ]+([\u3000-\u303F\u3040-\u30FF\u31F0-\u31FF\u3200-\u9FFF\uFF00-\uFFEF])[ ]*")


// 外部パッケージ
#import "@preview/equate:0.2.1": equate
#import "@preview/roremu:0.1.0": roremu
#import "@preview/physica:0.9.4": *

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
      right: 10mm
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
    font: mincho
  )

  // 数式設定
  show math.equation: set text(font: mathf)
  show math.equation.where(block: false): it => {
    let ghost = hide(text(font: "Adobe Blank", "\u{375}")) // 欧文ゴースト
    ghost; it; ghost
  }

  // 図表設定
  set figure(placement: bottom)
  set figure.caption(separator: [　])
  show figure: set block(breakable: true)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [コード])
  show figure.caption: it => {// if figure caption is image ...
    set par(leading: 4.5pt, justify: true)
    set text(size: 11.4pt)
    set align(top)
    grid(
      columns: 2,
      {
        if it.kind != "sub-figure"{// サブ図以外の場合，図番号を更新
          counter(figure.where(kind: "sub-figure")).update(0)
        }

        if it.kind == table{
          [Table ] + context counter(figure.where(kind: table)).display() + [　]
        }
        else if it.kind == raw{
          [Code ] + context counter(figure.where(kind: raw)).display() + [　]
        }
        else if it.kind == "sub-figure"{
          it.supplement
          context numbering("(a)", counter(figure.where(kind: "sub-figure")).get().at(0))
          [　]
        }
        else{
          [Fig. ] + context counter(figure.where(kind: image)).display() + [　]
        }
      },
      align(left)[#it.body]
    )
  }
  //表の設定
  let frame(stroke) = (x, y) => (
    left: if x > 0 { stroke } else { none },
    right: none,
    top: if y == 0 { stroke } else if y == 1 { /* pat-single + 5pt  */ 0pt} else{ 0pt },
    bottom: black + 0.5pt,
  )
  set table(stroke: none)
  set table(
    stroke: frame(black + 0.5pt),
    row-gutter: (2pt, auto)
  )
  set table.hline(stroke: 0.5pt)
  set table.vline(stroke: 0.5pt)

  //コードの設定
  show raw.where(block: true): it => {
    set text(font: codef)
      set table(stroke: (x, y) => (
        //left: if x == 1 { 0.5pt } else { 0pt },
        //right: if x == 1 { 0.5pt } else { 0pt },
        top: if y == 0 and x == 1{ 0.5pt } else { 0pt },
        bottom: if x == 1 { 0.5pt } else { 0pt },
      ))
      table(
        columns: (5%, 95%),
        align: (right, left),
        ..for value in it.lines {
          (text(fill: black,str(value.number)), value)
        }
      )
  }
  show raw.where(block: false): it =>{
    set text(font: codef)
    h(0.5em)
    it
    h(0.5em)
  }

  // 日本語間のコード改行を無効化
  show cjkre: it => it.text.match(cjkre).captures.sum()

  body

}

#let abst_title(
  title: [],
  laboratory: [],
  authors: (
    ( student-id: "75*****",
      name: "機械　工作"
    ),
    ( student-id: "75*****",
      name: "野田　理科"
    ),
  )
) = {

  // タイトル
  align(center)[
    #text(
      font: gothic,
      size: 16pt,
      weight: "bold",
      title
    )
  ]
  v(1em)

  // 研究室名
  set align(left)
  [\[] + laboratory + [研究室\]]
  h(1fr)

  // 氏名
  let author_arr = authors.map(a => a.student-id + [ ] + a.name)
  if author_arr.len() >= 3{
    let linebreak_count = int(calc.round(author_arr.len() / 2))
    for value in range(linebreak_count - 1){
      author_arr.at(2 * value) + [　　] + author_arr.at(2 * value + 1)
      linebreak()
      h(1fr)
    }
    [#author_arr.slice(2 * (linebreak_count - 1), author_arr.len()).join([　　])]
  }
  else{
    [#author_arr.join([　　])]
  }
  v(1em)

}


#let abst_title_en(
  title: [],
  laboratory: [],
  authors: (
    ( student-id: "75*****",
      name: "Kouji KIKAI"
    ),
    ( student-id: "75*****",
      name: "Rika NODA"
    ),
  )
) = {

  pagebreak()

  // タイトル
  align(center)[
    #text(
      size: 12pt,
      font: english_title,
      weight: "bold",
      title
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
  set par.line(numbering: n => text(size: 8pt, font: codef)[#n], numbering-scope: "page",number-clearance: 10pt)

  body
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        LOCAL FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#import "local_function.typ": *
