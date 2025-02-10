#import "../style/thesis_style.typ": *

= 序論

これは東京理科大学創域理工学部機械航空宇宙工学科の学位論文のテンプレートです．
序論に含まれるどこかの文字が四角い豆腐文字となっている場合は，フォントがインストールされていない可能性がありますので，学位論文を書き始める前に確認をしてください．

== タイトル

#roremu(524)
$
  integral_0^(2pi) sin x dd(x) &= [cos x ]_0^(2pi)\
  &= 0
$
#roremu(326)

#fig(
  rect(width: 9cm, height: 6cm, fill: luma(230), align(center + horizon)[#text(size: 3em, font: gothic)[Image]]),
  caption: "This is caption of sample image.",
  label: <fig1>
)

=== サブタイトル

ここには，文中の数式$sin x$を表記しています．
日 本 語 間 の 半 角 ス ペ ー ス は ， コ ン パ イ ル 時 に 自 動 的 に 除 去 さ れ ま す．

#roremu(1000)

#fig(
  table(
    columns: 2,
    [*Amount*], [*Ingredient*],
    [360g], [Baking flour],
    [250g], [Butter (room temp.)],
    [150g], [Brown sugar],
    [100g], [Cane sugar],
    [100g], [70% cocoa chocolate],
    [100g], [35-40% cocoa chocolate],
    [2], [Eggs],
    [Pinch], [Salt],
    [Drizzle], [Vanilla extract],
    table.hline(start: 0),
  ),
  caption: "This is caption of sample table.",
)
