# paper-template

学会原稿・論文を LaTeX で書くためのテンプレートです。
日本語の学会（jsarticle、jlreq）にも、IEEE などの国際会議・論文誌にも対応します。

**TeX を自分のPCにインストールする必要はありません。** 組版環境はコンテナとして配布されるので、
このテンプレートから作ったプロジェクトは、どのPCでも同じ結果でビルドできます。

- upLaTeX / LuaLaTeX / XeLaTeX / pdfLaTeX に対応（原稿ごとに自動で切り替わります）
- 保存するたびに自動で組版され、PDF が横で更新されます
- GitHub にタグを打つと、PDF が自動生成されて保管されます
- Claude Code（AI アシスタント）が最初から使えます

English version: [README.en.md](README.en.md)

---

## 1. 最初の一度だけ：PCの準備

PowerShell を開いて、4つインストールします。

```powershell
winget install --id Git.Git -e
winget install --id Docker.DockerDesktop -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id GitHub.cli -e
```

**インストール後、PCを再起動してください。** Docker Desktop が WSL2 を有効にするために必要です。

再起動したら **Docker Desktop を起動**し、左下が `Engine running`（緑）になるまで待ちます。
毎回起動するのが面倒なら、Settings → General → `Start Docker Desktop when you sign in` をオンに。

最後に VSCode を開き、拡張機能タブ（`Ctrl+Shift+X`）で **Dev Containers** を検索してインストールします。
発行元は Microsoft、ID は `ms-vscode-remote.remote-containers` です。

### 名前とメールの設定

新しい PowerShell を開いて、1回だけ。

```powershell
git config --global user.name "あなたの名前"
git config --global user.email "あなたのメール"
git config --global core.autocrlf input
git config --global init.defaultBranch main
gh auth login
```

`gh auth login` は GitHub.com → HTTPS → ブラウザ認証、の順に選べば通ります。

メールアドレスは公開リポジトリのコミットに残ります。隠したい場合は、GitHub の
Settings → Emails で `Keep my email addresses private` をオンにして、そこに表示される
`12345678+ユーザ名@users.noreply.github.com` を使ってください。

---

## 2. 新しい原稿を始める

```powershell
cd C:\research
gh repo create 論文の名前 --template norak29/paper-template --private --clone
cd 論文の名前
code .
```

ブラウザ派の人は、このリポジトリの緑の **Use this template** ボタンからでも同じことができます。

**保存場所の注意**: OneDrive の下と、日本語やスペースを含むパスは避けてください。
`C:\research\myproject` のような場所が安全です。

### コンテナで開く

VSCode が開いたら `Ctrl+Shift+P` を押し、**`Dev Containers: Reopen in Container`** と入力して実行。

初回は組版環境のダウンロードに5〜10分かかります。2回目以降は数十秒です。

左下の表示が `Dev Container: ...` に変われば成功。`main.tex` を開いて `Ctrl+Alt+B` でビルドできます。

---

## 3. 書く

### PDF を横に出す

`main.tex` を開いた状態で、エクスプローラの `out` フォルダの中の **`main.pdf` をダブルクリック**。
タブを右半分にドラッグすれば、左が原稿、右が PDF になります。

以後は **`Ctrl+S` で保存するたびに PDF が自動で更新されます。**

| 操作 | キー |
|---|---|
| ビルド | `Ctrl+Alt+B` |
| ソースの位置を PDF で探す | `Ctrl+Alt+J` |
| PDF の位置をソースで探す | PDF 上で `Ctrl+クリック` |
| 中間ファイルを掃除 | `Ctrl+Alt+C` |

エラーは **Problems パネル**（`Ctrl+Shift+M`）に行番号つきで出ます。

### 1文ごとに改行する

これだけは守ってください。

```latex
一文目をここに書く。
二文目は改行して次の行に書く。
```

段落を1行で書くと、単語1つの修正が段落全体の変更として記録され、
あとから「どこを直したか」が追えなくなります。

---

## 4. 学会のスタイルファイルを入れる

学会から配布されたファイルを **`sty/` フォルダ**に置いてください。
検索パスを通してあるので、`main.tex` から読めます。

読み込み方はファイルの種類で違います。

| 配布ファイル | 書き方 |
|---|---|
| `.sty` | `\usepackage{ファイル名}` |
| `.cls` | `\documentclass[オプション]{ファイル名}` |
| `.bst` | `\bibliographystyle{ファイル名}` |

### 文字コードに注意

このリポジトリは UTF-8 前提です。日本語の学会が配布するファイルは Shift_JIS や EUC-JP の
ことがあり、そのまま使うと文字化けしてビルドが通りません。

- 配布物に `UTF` / `SJIS` / `EUC` のフォルダが分かれている場合 → **UTF のものを使う**
- Shift_JIS のファイルしか無い場合 → コンテナ内で変換する

```bash
iconv -f CP932 -t UTF-8 配布ファイル.sty > sty/配布ファイル.sty
```

VSCode の右下に `UTF-8` と出ていれば正しく読めています。`Shift JIS` と出ていたら変換が必要です。

zip を展開するときも注意してください。図のファイル名が Shift_JIS で記録されていると、
コンテナ内で展開した時点で名前が文字化けします。Windows のエクスプローラで展開するか、
`unzip -O cp932` を使ってください。

### 組版エンジンの指定

学会によって使うエンジンが違います。`main.tex` の**1行目**に書けば切り替わります。

```latex
% !TEX engine = pdflatex
```

| 指定 | 主な用途 |
|---|---|
| `uplatex`（既定） | 従来の日本語学会テンプレート（jsarticle 系） |
| `platex` | 古い日本語テンプレート |
| `lualatex` | 最近の日本語テンプレート（jlreq + luatexja 系） |
| `pdflatex` | **英文テンプレート（IEEEtran, acmart, elsarticle など）** |
| `xelatex` | XeLaTeX 指定のテンプレート |

書かなくても、`main.tex` の冒頭から自動で判定します。`jlreq` や `luatexja` があれば LuaLaTeX、
`IEEEtran` などがあれば pdfLaTeX。ビルド時にターミナルへ `latexmkrc: engine = ...` と出るので、
判定結果を確認できます。**迷ったら明示的に書いてください。**

### 国際会議・論文誌（IEEE など）

英文テンプレートもそのまま使えます。**IEEEtran、acmart、elsarticle、revtex は組版環境に
最初から入っています。**

学会が配布する zip に `.cls` が同梱されている場合は、それを `sty/` に置いてください。
**学会が配った版が TeX Live 側より優先されます。** 指定された版で組むのが正しいので、これが狙いです。

```latex
% !TEX engine = pdflatex
\documentclass[conference]{IEEEtran}
```

IEEE の投稿システムは PDF にフォントが全部埋め込まれていることを要求しますが
（PDF eXpress のチェック）、pdfLaTeX の出力は既定で埋め込むので問題ありません。

### Word のテンプレートしか配布されていない場合

**LaTeX で再現しようとしないでください。** 書式が一致せず機械的に弾かれることがあります。
その学会は Word で書きます。

ただしリポジトリは使えます。`.docx` を git で版管理でき、タグを打てば提出版が Releases に残ります。
コンテナに `pandoc` が入っているので、次の設定を入れると **Word ファイルの中身の差分が
`git diff` で読めるようになります。**

`.gitattributes` に1行:

```
*.docx diff=word
```

コンテナで1回だけ:

```bash
git config diff.word.textconv "pandoc -t markdown --wrap=none"
```

共著者から戻ってきた版と自分の版を比べるときに効きます。

---

## 5. 保存と履歴（Git）

書いた内容を記録に残します。

1. 左の**ソース管理**（`Ctrl+Shift+G`）を開く
2. 変更したファイルの右の **`+`** を押す（記録する分を選ぶ）
3. 上の欄にメッセージを書いて **`Ctrl+Enter`**
4. **「変更の同期」**を押すと GitHub に送られる

メッセージは「第2章 定式化を追加」のように具体的に書いてください。
あとで探すときに効きます。

### コマンドでやる場合

ターミナル（`Ctrl+@`）からでも同じことができます。慣れるとこちらが速いです。

```bash
git status            # いま何が変わっているか見る
git add -A            # 全部を記録対象にする（ファイルを選ぶなら git add main.tex）
git commit -m "第2章 定式化を追加"
git push              # GitHub に送る
```

`git add` と `git commit` は手元の作業、`git push` で初めて GitHub に届きます。
コミットだけ重ねておいて、区切りがついたらまとめて push、という使い方で構いません。

変更を見たいときは次の2つ。

```bash
git diff              # まだ add していない変更
git log --oneline     # これまでのコミット一覧
```

### 過去の版に戻す

```bash
git log --oneline                        # どこまで戻るか決める
git restore --source=<ID> main.tex       # その時点の内容に戻す
```

履歴は消えません。戻したことも記録として残ります。

### 提出版を固定する

投稿した版や、先生に渡した版など、**残したい区切りにだけ**タグを打ちます。
普段の執筆ではコミットだけで十分です。

```bash
git push                              # 先に中身を送っておく
git tag -a v1.0 -m "〇〇学会 投稿版"   # タグを作る（-a は注釈つきタグ）
git push --tags                       # タグを送る
```

**`git push` と `git push --tags` は別物です。** 前者はコミット、後者はタグを送ります。
タグだけ送ってもソースが GitHub に無い、という状態にならないよう、先に `git push` してください。

タグを push すると GitHub 側でビルドが走り、数分後に **Releases** に `main.pdf` が添付されます。
一緒に、そのときのソース一式（zip / tar.gz）も自動で並びます。git を使わない共著者には
この zip を渡せます。`.gitignore` で除外したもの（`out/`、`_inbox/`）は入りません。

```bash
git tag                               # 打ったタグの一覧
```

名前を間違えたときは、手元と GitHub の両方から消します。

```bash
git tag -d v1.0                       # 手元から消す
git push origin :refs/tags/v1.0       # GitHub から消す
```

---

## 6. Claude Code

コンテナの中で `claude` と打つか、VSCode の **Claude Code** タブから使えます。

原稿作業で効く使い方:

- `cite.bib` の整形、論文情報から BibTeX を起こす
- 数値を渡して表の LaTeX を書かせる
- 推敲（「この段落、主語と述語が合っていない箇所を指摘して」）
- エラーログの解読
- 図のリネームと `\includegraphics` の一括修正

`CLAUDE.md` にこのプロジェクトの作法が書いてあり、Claude Code が自動で読みます。
投稿先などプロジェクト固有の情報は、そこに追記しておくと精度が上がります。

**Pro 以上のプランが必要です。** 使用量は Claude のチャットと共有です。

---

## 7. 作業用フォルダ

`_inbox/` は、zip やメモなど**捨てる前提のファイル**を置く場所です。
git の管理外なので、何を置いてもコミットされません。

学会から送られてきた zip をここに置いて、Claude Code に「展開して `sty/` と `fig/` に振り分けて」
と頼むのが典型的な使い方です。

---

## 8. パッケージが足りないとき

### 急ぎ（数十秒）

`.devcontainer/Dockerfile` に1行足して `Dev Containers: Rebuild Container`。

```dockerfile
RUN tlmgr install パッケージ名
```

### 恒久

[texlive-ja](https://github.com/norak29/texlive-ja) の `texlive.profile` を編集して push すると、
新しい組版環境が自動でビルドされます。そのあと、このプロジェクトの2か所を新しい日付に書き換えます。

```
.devcontainer/Dockerfile       の FROM の行
.github/workflows/release.yml  の container: の行
```

**この2か所は必ず同じ値にしてください。** ずれると、手元では組めるのに CI だけ落ちます。

---

## 9. 困ったとき

| 症状 | 対処 |
|---|---|
| `Reopen in Container` が出てこない | Dev Containers 拡張が未インストール |
| Docker のエラーで開けない | Docker Desktop が起動していない。クジラが緑か確認 |
| それでも開けない | PowerShell で `wsl --update` → PC再起動 |
| `.devcontainer` が見つからないと言われる | 親フォルダではなく、プロジェクトのフォルダを開く |
| 保存時に `EACCES` / 「ファイルが新しい」 | `Ctrl+Shift+P` → `Developer: Reload Window` |
| 参考文献が `[?]` | `cite.bib` が空。埋めてから `Ctrl+Alt+C` → 再ビルド |
| PDF が更新されない | `Ctrl+Alt+C` で掃除してから再ビルド |
| 写真の色が変 | 写真を sRGB に変換する: `convert in.jpg -colorspace sRGB -strip out.jpg` |
| CI だけ落ちる | 上記の2か所のタグがずれている |

---

## 10. 仕組み（知らなくても使えます）

リポジトリが3つ連携しています。

```
texlive-ja          TeX 環境のレシピ。年に数回しか触らない
   │ GitHub Actions が自動ビルド
   ▼
ghcr.io/norak29/texlive-ja:2026.11.24     日付タグで凍結された組版環境
   │ タグを固定して参照
   ▼
paper-template      このリポジトリ。原稿の雛形
   │ Use this template
   ▼
あなたの原稿        毎日触る
```

日付タグで固定しているので、**半年後に査読対応で開いても組版結果は変わりません。**
TeX Live は毎年更新され、同じソースでも結果が変わることがありますが、その影響を受けません。

ファイルの役割は次の通りです。

| ファイル | 役割 |
|---|---|
| `.latexmkrc` | 組版エンジンの指定。`sty/` の検索パス |
| `.devcontainer/` | 組版環境の指定と、VSCode の設定 |
| `.github/workflows/` | タグを打つと PDF を作る仕組み |
| `CLAUDE.md` | Claude Code に伝えるプロジェクトの作法 |
| `sty/` | 学会スタイル |
| `fig/` | 図 |
| `cite.bib` | 参考文献 |
| `_inbox/` | 作業用（git 管理外） |
