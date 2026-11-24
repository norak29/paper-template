# このリポジトリについて

日本語の学会原稿。upLaTeX + dvipdfmx でビルドする。

## ビルド
- `latexmk -outdir=out main.tex`。設定は `.latexmkrc`
- pdflatex や lualatex は使わない。jsarticle + dvipdfmx 前提
- `out/` は中間ファイル。git 管理外

## 執筆の作法
- **1文ごとに改行する。** 段落を1行で書かない（git の差分が読めなくなる）
- 図は `fig/`、学会スタイルは `sty/`、文献は `cite.bib`
- 全角英数は使わない。数式中の記号は必ず数式モードに入れる

## やらないでほしいこと
- 本文の主張や数値を勝手に書き換えない。提案は差分で示す
- `.devcontainer/` と `.github/workflows/` のイメージタグを勝手に上げない
  （2か所が同じでないと CI が落ちる）
- `out/` の中身をコミットしない