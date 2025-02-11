---
title: 基本の文章
parent: 文章の書き方
nav_order: 1
---

# 基本の文章
{: .no_toc }

## ファイルの配置

学位論文の本体は `main.typ` ですが，論文の中身を書くのは，`chapter`フォルダの中にある`.typ`ファイル内です．
テンプレートでは，`chapter`フォルダに以下の8つのファイルが含まれています．

```
.
├── chapter
│   ├── acknowledgement.typ
│   ├── appendix.typ
│   ├── conclusion.typ
│   ├── discussion.typ
│   ├── introduction.typ
│   ├── method.typ
│   ├── result.typ
│   └── signary.typ
└── main.typ
```

これらのファイルに制限はないため，状況によって増やしたり減らしたりすることが可能です．

### 新しくチャプターを作るとき

例えば，新たに`turbulence.typ`ファイルを作成し，「乱流について」というチャプターを作りたいときは，以下のような手順で設定します．

1. `chapter`フォルダの中に`turbulence.typ`ファイルを作る
2. `turbulence.typ`の中に次のように書く
    ```typst
    #import "../style/thesis_style.typ": *

    = 乱流について
    <chapter:乱流について>
    ```
3. `main.typ`に以下の内容を追記して，新しく作ったファイルを認識させる
    ```typst
    //乱流について
    #include "chapter/turbulence.typ"
    ```

### チャプターを削除するとき

例えば，`chapter/discussion.typ`を削除するときは，以下のようにします．

1. `main.typ`内の以下の項目を削除する
    ```typst
    //考察
    #include "chapter/discussion.typ"
    ```

このとき，`chapter`フォルダ内に残った`discussion.typ`は残しておいても削除してもかまいませんが，`main.typ`内で認識させている他のファイルは削除してはいけません．

## 文章を書く

学位論文に文章を加えるには，`chapter`フォルダの中にある`.typ`ファイル内を操作します．

```typst
こんにちは，世界．
今日はいい天気ですね．

明日は雨が降るかもしれません．
```

出力結果
![](../images/basic-sentence-fig1.png)

- `.typ`内での改行は，出力結果に影響しません．
- `.typ`内で2行改行すると，段落が切り替わります．

{: .note }
> `.typ`内では，一文ごとに改行することを強く勧めます．
> これは，git上で差分管理する上で重要なことです．
> また，段落の切り替えは上記のように2行改行で対応してください．
> 強制改行コマンド`\`や`#linebreak()`は極力使用しないでください．
