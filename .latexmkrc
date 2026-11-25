# 日本語原稿用 latexmk 設定（エンジン切り替え対応）
#
# エンジンは main.tex の先頭に書いたマジックコメントで決まる:
#
#   % !TEX engine = lualatex
#
# 使える値: uplatex（既定）, platex, lualatex, xelatex, pdflatex
# 書かない場合は main.tex の中身から自動判定し、それも駄目なら uplatex。
#
#   uplatex / platex ... dvi 経由で dvipdfmx（従来の日本語 LaTeX）
#   lualatex ........... jlreq + luatexja 系のテンプレート
#   xelatex ............ XeLaTeX 指定のテンプレート
#   pdflatex ........... 英文のみのテンプレート（IEEEtran など）

# sty/ に置いた学会スタイルを探せるようにする
$ENV{'TEXINPUTS'} = './sty//:' . ($ENV{'TEXINPUTS'} || '');
$ENV{'BIBINPUTS'} = './sty//:' . ($ENV{'BIBINPUTS'} || '');

# --- エンジンの判定 -------------------------------------------------
my $engine = '';
if (open(my $fh, '<', 'main.tex')) {
    my $head = '';
    my $n = 0;
    while (my $line = <$fh>) {
        $head .= $line;
        last if ++$n > 60;
    }
    close($fh);

    if ($head =~ /^\s*%\s*!\s*TEX\s+engine\s*=\s*(\w+)/mi) {
        $engine = lc($1);
    } elsif ($head =~ /lualatex|luatexja|jlreq/i) {
        $engine = 'lualatex';
    } elsif ($head =~ /xelatex|zxjatype/i) {
        $engine = 'xelatex';
    } elsif ($head =~ /IEEEtran|IEEEconf|acmart|elsarticle|revtex/i) {
        $engine = 'pdflatex';
    }
}
$engine = 'uplatex' unless $engine;

# --- 共通 -----------------------------------------------------------
my $opts = '-synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error';
$max_repeat = 5;
$clean_ext  = 'synctex.gz synctex.gz(busy) run.xml bbl bcf dvi fls fdb_latexmk nav snm';

# --- エンジンごとの設定 ---------------------------------------------
if ($engine eq 'lualatex') {
    $lualatex  = "lualatex $opts %O %S";
    $bibtex    = 'upbibtex %O %B';
    $makeindex = 'upmendex %O -o %D %S';
    $pdf_mode  = 4;

} elsif ($engine eq 'xelatex') {
    $xelatex   = "xelatex $opts %O %S";
    $bibtex    = 'upbibtex %O %B';
    $makeindex = 'upmendex %O -o %D %S';
    $pdf_mode  = 5;

} elsif ($engine eq 'pdflatex') {
    $pdflatex  = "pdflatex $opts %O %S";
    $bibtex    = 'bibtex %O %B';
    $makeindex = 'makeindex %O -o %D %S';
    $pdf_mode  = 1;

} elsif ($engine eq 'platex') {
    $latex     = "platex $opts %O %S";
    $bibtex    = 'pbibtex %O %B';
    $makeindex = 'mendex %O -o %D %S';
    $dvipdf    = 'dvipdfmx %O -o %D %S';
    $pdf_mode  = 3;

} else {
    $latex     = "uplatex $opts %O %S";
    $bibtex    = 'upbibtex %O %B';
    $makeindex = 'upmendex %O -o %D %S';
    $dvipdf    = 'dvipdfmx %O -o %D %S';
    $pdf_mode  = 3;
}

print "latexmkrc: engine = $engine\n";
