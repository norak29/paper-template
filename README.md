# paper-template

日本語の学会原稿・論文用テンプレート。upLaTeX + dvipdfmx、Dev Container、CI での PDF 生成つき。

TeX 環境は別リポジトリ [texlive-ja](https://github.com/norak29/texlive-ja) のイメージを
**固定タグ**で参照する。環境を更新しても原稿には触れない。

---

## 新しい資料を始める

```powershell
gh repo create <プロジェクト名> --template norak29/paper-template --private --clone
cd <プロジェクト名>
code .
```

ブラウザなら、このリポジトリの緑の **Use this template** ボタン。

VSCode が開いたら `Ctrl+Shift+P` → **`Dev Containers: Reopen in Container`**。
`main.tex` を開いて `Ctrl+Alt+B`、PDF は `out/main.pdf`。

## 始めたら最初にやる4つ

1. **イメージのタグが古くないか確認する**
   [最新タグ](https://github.com/norak29/texlive-ja/pkgs/container/texlive-ja) を見て、古ければ
   `.devcontainer/Dockerfile` と `.github/workflows/release.yml` の**両方**を書き換える。
   2か所は必ず同じ文字列にすること。ずれると CI だけ落ちる。
2. **学会スタイルを `sty/` に置く**
   `.latexmkrc` で `TEXINPUTS` を通してあるので、`\usepackage{ファイル名}` で読める。
3. **`main.tex` の `\documentclass` と冒頭を学会指定に合わせる**
4. **`.devcontainer/devcontainer.json` の `"name"` をプロジェクト名に変える**

## 構成

| ファイル | 役割 |
|---|---|
| `.latexmkrc` | **組版エンジンの指定**（uplatex → upbibtex → dvipdfmx）と `sty/` の検索パス |
| `.devcontainer/Dockerfile` | 使う TeX イメージのタグ。緊急のパッケージ追加枠 |
| `.devcontainer/devcontainer.json` | 拡張機能と LaTeX Workshop の設定 |
| `.github/workflows/release.yml` | `v` で始まるタグを push すると PDF を Release に添付 |
| `sty/` | 学会スタイル（.sty, .cls, .bst） |
| `fig/` | 図 |
| `cite.bib` | 参考文献 |

中間ファイルは `out/` に出る。`.gitignore` で除外済み。

## 日々の使い方

| 操作 | 方法 |
|---|---|
| ビルド | `Ctrl+Alt+B`（保存時にも自動） |
| PDF プレビュー | `Ctrl+Alt+V`、またはエディタ右上の虫眼鏡 |
| ソース → PDF | `Ctrl+Alt+J` |
| PDF → ソース | PDF 上で `Ctrl+クリック` |
| 中間ファイル掃除 | `Ctrl+Alt+C` |
| コミット | `Ctrl+Shift+G` → ステージ → メッセージ → `Ctrl+Enter` |

**1文ごとに改行する。** Git は行単位で差分を取るので、段落を1行で書くと
単語1つの修正が段落全体の変更として記録される。

## 提出版を凍結する

```bash
git tag -a v1.0 -m "〇〇学会 投稿版"
git push --tags
```

CI が走り、Releases に PDF が添付される。
「この PDF のソースはどれか」が永久に対応付く。

## パッケージが足りないとき

**急ぎ**（数十秒）: `.devcontainer/Dockerfile` に足して Rebuild Container

```dockerfile
RUN tlmgr install <パッケージ名>
```

**恒久**: [texlive-ja](https://github.com/norak29/texlive-ja) の `texlive.profile` を編集して push。
新しい日付タグができたら、このリポジトリの2か所を書き換える。

どの collection に入っているかは、コンテナ内で `tlmgr info <パッケージ名>`。

## 詰まったら

| 症状 | 対処 |
|---|---|
| 保存時に `EACCES` / 「ファイルが新しい」 | `Ctrl+Shift+P` → `Developer: Reload Window` |
| コンテナは開くのにファイルが見えない | `devcontainer.json` に `workspaceFolder` を書いていないか確認 |
| `.devcontainer` が見つからないと言われる | 親フォルダではなく、このプロジェクトのフォルダを開く |
| 参考文献が `[?]` | `cite.bib` が空。埋めてから `Ctrl+Alt+C` → 再ビルド |
| CI だけ落ちる | `release.yml` のタグが `.devcontainer/Dockerfile` とずれている |
