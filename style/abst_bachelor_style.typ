
// フォント
#let mincho = ("Times New Roman", "Harano Aji Mincho")
#let gothic = ("Helvetica", "Harano Aji Gothic")
#let mathf = ("Latin Modern Math")
#let codef = ("Noto Mono for Powerline")

// 日本語間のコード改行
#let cjkre = regex("([\u3000-\u303F\u3040-\u30FF\u31F0-\u31FF\u3200-\u9FFF\uFF00-\uFFEF][　！”＃＄％＆’（）*+，−．／：；＜＝＞？＠［＼］＾＿｀｛｜｝〜、。￥・]*)[ ]+([\u3000-\u303F\u3040-\u30FF\u31F0-\u31FF\u3200-\u9FFF\uFF00-\uFFEF])[ ]*")


// 外部パッケージ
#import "@preview/equate:0.2.1": equate
#import "@preview/roremu:0.1.0": roremu
#import "@preview/physica:0.9.4": *

#let abst_init(body) = {

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
  )

  // テキスト設定
  set text(
    size: 12pt,
    font: mincho
  )

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
      title
    )
  ]
  v(1em)

  // 研究室名
  set align(left)
  [\[] + laboratory + [研究室\]]
  h(1fr)

  // 氏名
  let num = 1
  let author_num = authors.len()
  for author in authors{
    author.student-id
    author.name

    if num != author_num {
      [　　]
    }
    num += 1
  }
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
