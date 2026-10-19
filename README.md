# TUS-ME_thesis_typst_template

東京理科大学創域理工学部機械航空宇宙工学科および大学院創域理工学研究科機械航空宇宙工学専攻の【非公式】の学位論文テンプレートのTypst版です.
塚原研究室は熱流体系の研究室ですが，同学科・同専攻であれば所属研究室によらずこのテンプレートを使用可能です．
パブリックリポジトリなので他研究室所属の方もご自身のPCに入れることができます．
使用する際に塚原研究室の許可を取る必要はありませんが，このテンプレートを使用したことで生じた問題に関して大学・学科・塚原研究室および研究室に所属する個人は一切の責任を負いませんのでご了承ください．

## 使い方

詳細な使い方は，[テンプレートのドキュメント](https://tsukahara-lab.github.io/TUS-ME_thesis_template_manual/)を参照してください．
以下では，このテンプレートを使用するための基本的な手順を説明します．
`typst`コマンドのインストールやTypstの基本的な使い方については，Typstの[公式ドキュメント](https://typst.app/docs)を参照してください．

### 初期設定

1. このリポジトリをクローンする
   ```bash
   git clone https://github.com/tsukahara-lab/TUS-ME_thesis_typst_template.git
   ```

2. 自分のGitHubアカウントに新しいリポジトリを作成する

3. リモートURLを自分のものに変更する（`<your-github-username>`と`<your-repository-name>`は自分のGitHubアカウント名と作成したリポジトリ名に置き換えてください）
   ```bash
   git remote set-url origin https://github.com/<your-github-username>/<your-repository-name>.git
   git remote add upstream https://github.com/tsukahara-lab/TUS-ME_thesis_typst_template.git
   ```

4. URLの変更が反映されているか確認する
    ```bash
    git remote -v
    ```
    このとき，`origin`が自分のリポジトリ，`upstream`がこのテンプレートのリポジトリになっていればOKです．

5. 自分のリポジトリにpushする
   ```bash
   git push origin HEAD
   ```

### 更新の反映

1. テンプレートの最新状態を取得する
    ```bash
    git fetch upstream
    ```

2. 自分が`main`ブランチにいることを確認し，テンプレートの最新状態をマージする
    ```bash
    git switch main
    git merge upstream/main
    ```

3. 自身のリポジトリにpushする
    ```bash
    git push origin HEAD
    ```

### 添削時

添削時は，通常の`main.pdf`だけでなく，その差分も提出すると便利です．

1. 差分をとるcommitハッシュを取得する
   ```bash
   git log --oneline
   ```

2. 差分をとる（`<commit-hash>`は取得したcommitハッシュに置き換えてください）
   ```bash
   bash diff.sh main.typ <commit-hash>
   ```
