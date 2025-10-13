---
title: 参考文献
layout: default
parent: 文章の書き方
nav_order: 4
---

# 参考文献
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 参考文献の書き方

参考文献は，`refs.bib`ファイル内にBibTeX形式で記述します．
本テンプレートでは，`enja-bib`パッケージを使用して，英語文献と日本語文献の両方に対応しています．
テンプレートのスタイルは日本機械学会のフォーマットに準拠しています．
本スタイルは[LaTeXのbst](https://github.com/Yuki-MATSUKAWA/JSME-bst)を参考に作成されており，具体的なエントリの書き方もほとんど同様です．
上記のリポジトリのマニュアルを参考にしてエントリを作成してください．
以下では，簡単な例を示します．

### 英語文献の場合

以下は，英語文献における参考文献の例です．

```
@article{Reynolds:PhilTransRoySoc1883,
    author  = {Reynolds, Osborne},
    title   = {An experimental investigation of the circumstances which determine whether the motion of water shall be direct or sinuous, and of the law of resistance in parallel channels},
    journal = {Philosophical Transactions of the Royal Society of London},
    volume  = {174},
    number  = {},
    pages   = {935--982},
    year    = {1883},
    doi     = {10.1098/rstl.1883.0029},
    url     = {https://royalsocietypublishing.org/doi/abs/10.1098/rstl.1883.0029}
}
```

### 日本語文献の場合

日本語文献における参考文献の例は以下の通りです．

```
@article{塚原:ながれ2023,
    author  = {塚原, 隆裕},
    yomi    = {Tsukahara, Takahiro},
    title   = {私の「ながれを学ぶ」使命感},
    journal = {ながれ：日本流体力学会誌},
    volume  = {42},
    number  = {3},
    pages   = {222},
    year    = {2023},
    url     = {https://www.nagare.or.jp/publication/nagare/archive/2023/3.html}
}
```

日本語の場合，`yomi`フィールドを追加する必要があります．
これは，日本語文献を英語文献と同様にアルファベット順でソートするために必要です．
`yomi`フィールドには，上記の例のように著者名のローマ字表記を記述します．

## 参考文献の引用

文書で参考文献を引用するには，`@Reynolds:PhilTransRoySoc1883`のように`@`に続けてBibTeXエントリのキーを記述します．
これは最も簡易的な方法であり，以下のような書き方をするとより厳格な設定が可能です．

### 文中での引用

文の途中で引用する場合は，以下のようにします．

```
#citet(<Reynolds:PhilTransRoySoc1883>)
```

これにより，`Reynolds (1883)`のように表示されます．
複数の文献を引用する場合は，以下のようにカンマで区切って記述します．

```
#citet(<Reynolds:PhilTransRoySoc1883>, <塚原:ながれ2023>)
```

### 文末での引用

文末で引用する場合は，以下のようにします．

```
#citep(<Reynolds:PhilTransRoySoc1883>)
```

これにより，`(Reynolds, 1883)`のように表示されます．
複数の文献を引用する場合は，以下のようにカンマで区切って記述します．

```
#citep(<Reynolds:PhilTransRoySoc1883>, <塚原:ながれ2023>)
```
