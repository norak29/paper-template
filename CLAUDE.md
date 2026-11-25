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

## 古い原稿・他人の原稿を移植するとき

1. zip は `_inbox/` に置き、`unzip -O cp932 <zip> -d _inbox/<名前>` で展開する（日本語ファイル名対策）
2. 持ち込むのはソースだけ。`.aux .log .dvi .synctex.gz .fdb_latexmk .fls .toc .out .bbl .blg` と、
   ビルド済みのメイン PDF は持ち込まない（図として使っている PDF は持ち込む）
3. `.log` の1行目でエンジンと TeX Live の年版を確認する（e-pTeX なら platex）。
   メインファイルかプリアンブルの1行目に `% !TEX engine = ...` を書く
4. 文字コードを確認する。Shift_JIS なら `iconv -f CP932 -t UTF-8` で変換する
5. `latexmk -outdir=out` で組み、最初のエラーから1つずつ直す
6. `Command \xxx already defined` は TeX Live の年版差。定義の直前に `\let\xxx\relax` を足す
7. 本文・数値・図は変えない。直すのは組むために必要な最小限だけにし、直した箇所はすべて報告する
