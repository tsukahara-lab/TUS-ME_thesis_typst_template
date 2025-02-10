
// フォント
#let mincho = ("Times New Roman", "Harano Aji Mincho")
#let gothic = ("Helvetica", "Harano Aji Gothic")
#let mathf = ("Latin Modern Math")

// 日本語間のコード改行
#let cjkre = regex("[ ]*([\p{Han}\p{Hiragana}\p{Katakana}]+(?:,[ ]*[\p{Han}\p{Hiragana}\p{Katakana}]+)*)[ ]*")

// 外部パッケージ
#import "@preview/equate:0.2.1": equate
#import "@preview/roremu:0.1.0": roremu
#import "@preview/physica:0.9.4": *
#import "@preview/unify:0.7.0": *

// 初期設定
#let thesis_init(body) = {

  //言語設定
  set text(lang: "ja", cjk-latin-spacing: auto, fallback: false)

  // ページサイズ設定
  set page(
    paper:"a4",
    margin: (left: 25mm, right: 10mm, top: 33mm, bottom: 30mm),
    //numbering: "1",
    //number-align: center,
  )

  //パラグラフ設定
  set par(
    justify: true,
    first-line-indent: 1em,
    leading: 1em,
  )

  // テキスト設定
  set text(
    size: 12pt,
    font: mincho
  )

  // 見出し設定
  set heading(numbering: "1.1")
  show heading: (it => {
    set text(font: gothic, size: 1.2em)
    set par(first-line-indent: 0em)
    if it.numbering != none{
      context counter(heading).display() + [　] +it.body
    }
    else{
      it.body
    }
  })

  show heading.where(level: 1): (it => {
    set text(font: gothic, size: 1.33em)
    set par(first-line-indent: 0em)

    pagebreak()
    if it.numbering != none{
      [第] + context counter(heading).display() + [章]
      v(0.25em)
      it.body
    }
    else{
      it.body
      v(1em)
    }
    v(0.1em)
  })

  show heading.where(level: 2): (it => {
    set text(font: gothic, size: 1.3em)
    set par(first-line-indent: 0em)
    v(0.5em)
    if it.numbering != none{
      context counter(heading).display() + [　] +it.body
    }
    else{
      it.body
    }
    v(0.5em)
  })

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
  set math.equation(numbering: num =>
    "(" + (str(counter(heading).get().at(0)) + "." + str(num)) + ")"
  )
  show math.equation.where(block: true): set align(left)// set block equation align
  show math.equation.where(block: true): it => {// set block equation space
    grid(
      columns: (2em, auto),
      [],it
    )
  }
  show: equate.with(breakable: true, number-mode: "line")
  show math.equation.where(block: false): it => {
    let ghost = text(font: "Adobe Blank", "\u{375}") // 欧文ゴースト
    ghost; it; ghost
  }

  // 図表設定
  set figure(placement: top)
  set figure.caption(separator: [　])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: it => {// if figure caption is image ...
    set par(leading: 4.5pt, justify: true)
    grid(
      columns: 2,
      {
        if it.kind == table{
          [Table ] + context counter(figure.where(kind: table)).display() + [　]
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
    left: if x > 0 { stroke } else { 0pt },
    right: none,
    top: if y == 0 { stroke } else if y == 1 { stroke } else{ 0pt },
    bottom: stroke,
  )
  set table(
    stroke: frame(black),
  )

  // 日本語間のコード改行を無効化
  show cjkre: it => it.text.match(cjkre).captures.at(0)

  body
}

#let thesis_signary(body) = {

  counter(page).update(0)

  set page(
    header: context [//ヘッダーの設定
      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #let pages-with-first-level-heading-numbering = all-headings-before.at(-1, default: none)
      #if pages-with-first-level-heading-numbering != none{
        pages-with-first-level-heading-numbering = pages-with-first-level-heading-numbering.numbering
      }

      #if not has-first-level-heading-on-current-page and all-headings-before.at(-1, default: none) != none {
        h(1fr)
        text(font: mincho, weight: "regular")[#numbering("i",counter(page).get().at(0))]
        v(-0.5em)
      }
    ],
    footer: context [//フッターの設定
      #set align(center)

      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #if has-first-level-heading-on-current-page{
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
    header: context [//ヘッダーの設定
      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #let pages-with-first-level-heading-numbering = all-headings-before.at(-1, default: none)
      #if pages-with-first-level-heading-numbering != none{
        pages-with-first-level-heading-numbering = pages-with-first-level-heading-numbering.numbering
      }

      #if not has-first-level-heading-on-current-page and all-headings-before.at(-1, default: none) != none {
        let body = all-headings-before.at(-1).body
        set text(font: gothic, weight: "bold")
        if pages-with-first-level-heading-numbering != none{
          [第] + [#counter(heading).get().at(0)] + [章　]
        }
        body + h(1fr)
        text(font: mincho, weight: "regular")[#counter(page).get().at(0)]
        v(-0.5em)
        line(length: 90%)
      }
    ],
    footer: context [//フッターの設定
      #set align(center)

      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #if has-first-level-heading-on-current-page{
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
  show heading: (it => {
    set text(font: gothic, size: 1.2em)
    set par(first-line-indent: 0em)

    it.body
  })

  show heading.where(level: 1): set heading(outlined: true)
  show heading.where(level: 1): (it => {
    set text(font: gothic, size: 1.33em)
    set par(first-line-indent: 0em)

    pagebreak()
    if it.numbering != none{
      [付録] + context counter(heading).display()
      v(0.25em)
      it.body
    }
    else{
      it.body
      v(1em)
    }
    v(0.1em)
  })

  set page(
    header: context [//ヘッダーの設定
      #let first-heading-selector = heading.where(level: 1)

      #let pages-with-first-level-heading = query(first-heading-selector).map(it => it.location().page())
      #let has-first-level-heading-on-current-page = here().page() in pages-with-first-level-heading

      #let all-headings-before = query(first-heading-selector.before(here()))

      #let pages-with-first-level-heading-numbering = all-headings-before.at(-1, default: none)
      #if pages-with-first-level-heading-numbering != none{
        pages-with-first-level-heading-numbering = pages-with-first-level-heading-numbering.numbering
      }

      #if not has-first-level-heading-on-current-page and all-headings-before.at(-1, default: none) != none {
        let body = all-headings-before.at(-1).body
        set text(font: gothic, weight: "bold")
        if pages-with-first-level-heading-numbering != none{
          [付録] + [#numbering("A", counter(heading).get().at(0))] + [　]
        }
        body + h(1fr)
        text(font: mincho, weight: "regular")[#counter(page).get().at(0)]
        v(-0.5em)
        line(length: 90%)
      }
    ]
  )

  set math.equation(numbering: num =>
    "(" + (str(numbering("A", counter(heading).get().at(0))) + "." + str(num)) + ")"
  )

  set figure(placement: top)

  body
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                          COVER PAGE
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let number-to-zenkaku(num, nonumber: false) = {
  let zenkaku = ("０", "１", "２", "３", "４", "５", "６", "７", "８", "９")
  let hankaku = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  let result = ""
  for c in str(num){
    if not zenkaku.contains(c){
      if hankaku.contains(c){
        result += zenkaku.at(int(c))
      }
      else if nonumber{
        result += "＊"
      }
    }
    else{
      result += c
    }

  }
  result
}

#let zenkaku-to-number(num) = {
  let zenkaku = ("０", "１", "２", "３", "４", "５", "６", "７", "８", "９")
  let hankaku = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

  let result = ""
  for c in str(num){
    if not hankaku.contains(c){
      for index in range(10){
        if zenkaku.at(index) == c{
          result += hankaku.at(index)
          break
        }
      }
    }
    else{
      result += c
    }

  }
  int(result)
}

#let linebreak_num(num) = {
  for index in range(num + 1){
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
    ( student-id: "75*****",
      name: "機械　工作"
    ),
  ),
) = {
  set page(
    margin: (left: 25mm, right: 10mm, top: 25mm, bottom: 15mm),
  )
  set align(center)
  v(12em)
  number-to-zenkaku(year) + [年度]
  if master{
    [修士論文]
  }
  else{
    [卒業論文]
  }
  v(2.5em)
  text(size: 18pt)[#title]
  v(13em)
  let up_year = str(zenkaku-to-number(year) + 1)
  number-to-zenkaku(up_year) + [年] + number-to-zenkaku(month) + [月]
  v(2.5em)
  if institution != none{
    institution
  }
  else{
    if master{
      [東京理科大学大学院創域理工学研究科機械航空宇宙工学専攻]
    }
    else{
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
      for value in authors{
        number-to-zenkaku(value.student-id, nonumber: true) + h(2em) + value.name + linebreak()
      }
    }
  )
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        OUTLINE FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let outline-page = {

  show outline.entry: it => {
    let title = it.body.children
    title.at(0)
    context{
        let req_h = 150pt - here().position().x
        if req_h < (2em).to-absolute(){
          req_h = 2em
        }
        h(req_h)
    }
    link(it.element.location(),it.element.body)
    h(1em)
    it.fill
    it.page
  }

  show outline.entry.where(level: 1): it => {

    let title = ()
    if it.body.has("children"){
      title = it.body.children
    }
    else{
      title = (it.body, )
    }

    if it.element.numbering != none{

      if it.element.numbering == "A"{
        [付録] + title.at(0)
      }
      else{
        [第] + title.at(0) + [章]
      }
      context{
        let req_h = 150pt - here().position().x
        if req_h < (2em).to-absolute(){
          req_h = 2em
        }
        h(req_h)
      }

      link(it.element.location(),it.element.body)
    }
    else{
      link(it.element.location(),title.at(0))
    }
    h(1em)
    it.fill
    it.page
  }

  outline(
    indent: 1em,
    fill: box(width: 1fr, repeat(h(2pt) + sym.dot.c + h(2pt))) + h(8pt),
  )
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        LOCAL FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let signary-list(title: [], body) = {
  set par(first-line-indent: 0em)
  title
  table(
    columns: (10em, auto),
    stroke: none,
    ..body
  )
}

#let fig(..arg, label: none, placement: auto) = {

  if placement == auto{

    context {

      let heading-page =  query(heading.where(level: 1)).map(it => it.location().page())
      let here-page = here().page()
      let heading-here = here-page in heading-page

      let fig-size = measure(figure(..arg)).height
      let interval-size = 297mm - 63mm - fig-size - here().position().y

      text(font: "Adobe Blank")[#hide([A])]

      if heading-here {//章の先頭ページのとき

        if fig-size > (297mm - 63mm) / 2{//図がページの半分以上のとき，単一ページとする
          page[
            #set align(center + horizon)
            #figure(
              ..arg,
              placement: none
            )#label
          ]
        }
        else{
          if interval-size > 0mm {//図を下に配置できるとき，下に配置
            [
              #figure(
                ..arg,
                placement: bottom
              )#label
            ]
          }
          else{//図を下に配置できないとき，次ページの上に配置
            pagebreak()
            [
              #figure(
                ..arg,
                placement: top
              )#label
            ]
          }
        }
      }
      else{//章の途中ページのとき

        if fig-size > (297mm - 63mm) / 2{//図がページの半分以上のとき，単一ページとする
          page[
            #set align(center + horizon)
            #figure(
              ..arg,
              placement: none
            )
          ]
        }
        else{//図がページの半分以下のとき，上に配置
          [
              #figure(
                ..arg,
                placement: top
              )#label
            ]
        }

      }

    }
  }
  else{
    if placement == top{
      [
        #figure(
          ..arg,
          placement: top
        )#label
      ]
    }
    else if placement == bottom{
      [
        #figure(
          ..arg,
          placement: bottom
        )#label
      ]
    }
    else{
      page[
        #set align(center + horizon)
        #figure(
          ..arg,
          placement: none
        )
      ]
    }
  }

}
