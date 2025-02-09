#import "style/thesis_style.typ": *
#show: thesis_init

// 提出時にはコメントアウトすること
#set par.line(numbering: n => text(size: 8pt)[#n], numbering-scope: "page",number-clearance: 10pt)

// タイトルページ
#thesis_title(
  title: [タイトル],
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

#counter(page).update(0)
#show: thesis_signary
#include "chapter/signary.typ"

#counter(page).update(0)
#show: thesis_main

#include "chapter/introduction.typ"

#include "chapter/method.typ"

#include "chapter/result.typ"

#include "chapter/discussion.typ"

#include "chapter/conclusion.typ"

#include "chapter/acknowledgement.typ"
