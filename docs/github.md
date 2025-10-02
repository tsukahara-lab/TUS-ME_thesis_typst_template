---
title: 学位論文の書き方
layout: default
nav_order: 3
---

# 学位論文の書き方

## プレビューを開く

本テンプレートを使用するには，VScode上で以下の手順で開きます

1. `main.typ`を開く
1. `Ctrl + K + V`を押す

これで，Typst previewが起動し，`main.pdf`がプレビューできます．

## pdfを出力する

### Typst Tiministを使用する場合

1. `main.typ`を開く
1. VScode上のpdfアイコンをクリックする

これで，`main.pdf`が出力されます．

### typstコマンドを使用する場合

1. ターミナルを開く
1. 以下のコマンドを実行する
    ```bash
    typst compile main.typ
    ```

これで，`main.pdf`が出力されます．
