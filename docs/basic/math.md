---
title: 数式
layout: default
parent: 文章の書き方
nav_order: 3
---

# 数式
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 数式の書き方

### 単独の数式

```
$ sin x $
```

|:-|
| ![](../images/basic-math-fig1.png) |

- `$ `と` $`で囲うことで，ディスプレイ形式の数式が書けます．
- `$`の前後に**半角スペースが必要**です．

### 文中の数式

```
これは，文の中の数式$sin x$です．
```

|:-|
| ![](../images/basic-math-fig2.png) |

- `$`で囲うことで，文中の数式が書けます．
- `$`の前後に半角スペースは入りません．前後両者ともにスペースを設けると，ディスプレイ形式の数式となります．

---

## 複数行の数式

```
$
    integral_0^(2pi) sin x &= [- cos x]_0^(2pi)#nonumber\
    &= 0
$
```

|:-|
| ![](../images/basic-math-fig4.png) |

- 強制改行`\`を使うことで，複数行の数式が書けます．
- 強制改行の前に，`#nonumber`を書くことで，その行に式番号がつかなくなります．途中式の場合は，極力式番号を出力せず，`#nonumber`を使うようにしてください．
- イコール等で行を揃えるには，揃える位置に`&`を書きます．

---

## physicaパッケージの利用

LaTeXでは，数式を簡単に書くためのphysics2パッケージが存在しますが，Typstではphysicaパッケージがあります．
以下はphysicaパッケージを利用して，偏微分を`pdv`コマンドで書いている例です．

```
$
    pdv(u_i, t) + u_j pdv(u_i, x_j) = - 1/rho pdv(p, x_i) + nu pdv(u_i, x_j, x_j) + f_i
$
```

|:-|
| ![](../images/basic-math-fig3.png) |

{: .note }
physicaパッケージには，様々な便利関数が含まれます．詳しくは，[physicaパッケージマニュアル](https://github.com/Leedehai/typst-physics/blob/v0.9.4/physica-manual.pdf)を参照してください．

以下は，physicaパッケージで微分を書く例です．

| コード | レンダリング |
|:-:|:-:|
| `dv(y, x)` | <img src="../images/basic-math-ex1.png" width="50"> |
| `dv(y, x, 2)` | <img src="../images/basic-math-ex2.png" width="50"> |
| `pdv(y, x)` | <img src="../images/basic-math-ex3.png" width="50"> |
| `pdv(y, x, 2)` | <img src="../images/basic-math-ex4.png" width="50"> |
| `pdv(y, x, z)` | <img src="../images/basic-math-ex5.png" width="60"> |
| `pdv(y, x, z, [2, 1])` | <img src="../images/basic-math-ex6.png" width="70"> |

この他にも，physicaパッケージには微分に留まらない多くの関数が存在します．
本テンプレートではデフォルトでこのパッケージを読み込むよう設定しているので，積極的に使用しましょう．
