#import "../style/abst_bachelor_style.typ": *

#show: abst_init

// 提出時にはコメントアウトすること
#show: check-contents

#abst_title(
  title: [ここにタイトルを挿入],
  laboratory: [塚原],
  authors: (
    (student-id: "75*****", name: "機械　工作"),
    (student-id: "75*****", name: "野田　理科"),
  ),
)

氏名の欄から1行開けて，概要文章はここから始める．



// 英文概要

#abst_title_en(
  title: [The reason to write an abstract in English],
  laboratory: [Tsukahara],
  authors: (
    (student-id: "75*****", name: "Kouji KIKAI"),
    (student-id: "75*****", name: "Rika NODA"),
  ),
)

#show: abst_en_init

#abst_en_translate[
  // 英文の日本語訳はここから始める
  機械工学科の卒業研究を修了するにあたり，2017年度から英文概要の提出が必須となった．
  近年では，より多くの人々に研究成果を伝えるために，英語で報告書を作成することが求められている．
  したがって，卒業研究の内容を英語でまとめることが求められる．
]

// 英文概要の本文はここから始める
To finish your graduation study in the department of mechanical engineering, English abstract was required from 2017. Nowadays, we need to write reports in English to attract large audience. Therefore, you are requested to write summary of your study in English .........
