# 日本語・英文原稿用 latexmk 設定（エンジン自動切り替え）
#
# ■ エンジンの決まり方（上から順に）
#   1. メインファイル（または \input 先）に書いたマジックコメント
#        % !TEX engine = lualatex
#      （TeXShop / TeXworks 形式の % !TEX program = ... も読む）
#   2. 中身からの推測
#        jlreq / luatexja / lualatex   → lualatex
#        xelatex / zxjatype            → xelatex
#        IEEEtran / acmart / elsarticle / revtex → pdflatex
#   3. どれにも当たらなければ uplatex
#
#   使える値: uplatex（既定）, platex, lualatex, xelatex, pdflatex
#
# ■ メインファイルの決まり方
#   直下の .tex のうち \documentclass か \begin{document} を含むもの。
#   main.tex があればそれを優先。% !TEX root = ... と書かれたファイル（章など）は除外。
#   引数なしで latexmk を実行したときも、このファイルが組まれる。

# sty/ に置いた学会スタイルを探せるようにする
$ENV{'TEXINPUTS'} = './sty//:' . ($ENV{'TEXINPUTS'} || '');
$ENV{'BIBINPUTS'} = './sty//:' . ($ENV{'BIBINPUTS'} || '');

sub _head {
    my ($path, $max) = @_;
    open(my $fh, '<', $path) or return '';
    my ($txt, $n) = ('', 0);
    while (my $l = <$fh>) { $txt .= $l; last if ++$n >= $max; }
    close($fh);
    return $txt;
}

# --- メインファイルを探す -------------------------------------------
my @mains;
for my $f (sort glob('*.tex')) {
    my $body = _head($f, 5000);
    next if $body =~ /^\s*%\s*!\s*TEX\s+root\s*=/mi;
    push @mains, $f if $body =~ /\\documentclass|\\begin\{document\}/;
}
my $main = (grep { $_ eq 'main.tex' } @mains) ? 'main.tex' : $mains[0];
@default_files = ($main) if $main;

# --- 判定に使う文字列（メイン冒頭 + \input 先の冒頭） ---------------
my $scan = $main ? _head($main, 120) : '';
my @inc;
while ($scan =~ /^[^%\n]*\\(?:input|include)\{([^}]+)\}/mg) { push @inc, $1; }
for my $p (@inc) {
    my $f = ($p =~ /\.tex$/) ? $p : "$p.tex";
    $scan .= "\n" . _head($f, 120) if -e $f;
}

# --- エンジンの判定 -------------------------------------------------
my $engine = '';
if ($scan =~ /^\s*%\s*!\s*TEX\s+(?:engine|program|TS-program)\s*=\s*(\w+)/mi) {
    $engine = lc($1);
} elsif ($scan =~ /^[^%\n]*(?:lualatex|luatexja|jlreq)/mi) {
    $engine = 'lualatex';
} elsif ($scan =~ /^[^%\n]*(?:xelatex|zxjatype)/mi) {
    $engine = 'xelatex';
} elsif ($scan =~ /^[^%\n]*(?:IEEEtran|IEEEconf|acmart|elsarticle|revtex)/mi) {
    $engine = 'pdflatex';
}
unless ($engine =~ /^(uplatex|platex|lualatex|xelatex|pdflatex)$/) {
    print "latexmkrc: engine '$engine' は不明なので uplatex を使います\n" if $engine;
    $engine = 'uplatex';
}

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

print "latexmkrc: main = " . ($main || '(未検出)') . ", engine = $engine\n";
