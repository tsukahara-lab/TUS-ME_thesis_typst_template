#import "style/thesis_style.typ": *
#import "bib_style/bib_style.typ": *
#show: thesis_init
#show: bib_init

// 提出時にはコメントアウトすること
#set par.line(numbering: n => text(size: 8pt)[#n], numbering-scope: "page",number-clearance: 10pt)

// タイトルページ
#thesis_title(
  title: [ここには学位論文のタイトルを入れます．\ 一文字でも間違えたら受理されません．],
  year: 2025,
  master: false,
  laboratory: [塚原],
  authors: (
    ( student-id: "75*****",
      name: "機械　工作"
    ),
    ( student-id: "75*****",
      name: "野田　理科"
    ),
  )
)

#outline-page

//記号表
#show: thesis_signary
#include "chapter/signary.typ"

// ----- ここから本文 ----- //
#show: thesis_main

//序論
#include "chapter/introduction.typ"

//計算手法
#include "chapter/method.typ"

//結果
#include "chapter/result.typ"

//考察
#include "chapter/discussion.typ"

//結論
#include "chapter/conclusion.typ"

//謝辞
#include "chapter/acknowledgement.typ"

//参考文献
#include "bib.typ"

//付録
#show: thesis-appendix
#include "chapter/appendix.typ"
