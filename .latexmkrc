# upLaTeX + dvipdfmx（jsarticle / 日本語）
# 組版エンジンの指定は原稿リポジトリ側に置く。
# イメージを入れ替えても組版結果が変わらないようにするため。

# sty/ に置いた学会スタイルファイルを探せるようにする
$ENV{'TEXINPUTS'} = './sty//:' . ($ENV{'TEXINPUTS'} || '');
$ENV{'BIBINPUTS'} = './sty//:' . ($ENV{'BIBINPUTS'} || '');

$latex     = 'uplatex -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %O %S';
$bibtex    = 'upbibtex %O %B';
$makeindex = 'upmendex %O -o %D %S';
$dvipdf    = 'dvipdfmx %O -o %D %S';

$pdf_mode   = 3;   # dvi -> pdf (dvipdfmx)
$max_repeat = 5;

$clean_ext = 'synctex.gz synctex.gz(busy) run.xml bbl bcf dvi fls fdb_latexmk';
