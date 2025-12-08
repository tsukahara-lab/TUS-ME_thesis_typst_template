---
title: fig
layout: default
parent: 図の挿入
nav_order: 1
---

# fig

図や表を，学位論文の適切な位置へ配置します．
ただし，図や表の組み合わせが最適とならない場合がありますので，その場合はfigure環境を利用してください．

**例**

```
#fig(
    image("../figure/image.svg"),
    caption: [sample of image.],
    label: <sample>,
)
```

|:-|
| ![](../images/figure-fig1-1.png) |

**引数**

> ---
>
> **body** > [<span class="label label-green">content</span>](https://typst.app/docs/reference/foundations/content/)
>
> image関数など，図を入れます．
>
> ---
>
> **caption** > [<span class="label label-red">none</span>](https://typst.app/docs/reference/foundations/none/) > [<span class="label label-green">content</span>](https://typst.app/docs/reference/foundations/content/)
>
> キャプションを書きます．デフォルトでは何も描画しませんが，学位論文では必ず書いてください．
> また，キャプションの文言は図が何を表しているのかを英語で書いてください．
> キャプションは文のため，最後は必ずピリオドで終わります．
>
> デフォルト： `none`
>
> ---
>
> **placement** > [<span class="label label-purple">auto</span>](https://typst.app/docs/reference/foundations/auto/) > [<span class="label label-blue">alignment</span>](https://typst.app/docs/reference/layout/alignment/)
>
> 図の配置を決定します．
> デフォルトでは，図を学位論文中の最適な位置へ配置します．
> 学位論文の章はじまりのページは`bottom`に配置し，それ以外では`top`に配置します．
> 図が大きい場合は単独ページ`page`となります．
>
> 使用できるalignmentは，`auto`，`top`，`bottom`，`page`のみです．
>
> デフォルト：`auto`
>
> ---
>
> **label** > [<span class="label label-red">none</span>](https://typst.app/docs/reference/foundations/none/) > [<span class="label label-yellow">label</span>](https://typst.app/docs/reference/foundations/label/)
>
> ラベルを書きます．これによって，参照が可能となります．
> 学位論文では，必ず文章中で参照をしてください．
> 参照をしていない図が見つかった場合は，学位論文のトップに警告文が出ます．
>
> デフォルト： `none`
>
> ---
