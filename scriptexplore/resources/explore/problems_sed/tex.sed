# path = resources/explore/problems_sed

#echo "converting ascii to latex for <path>/*.ascii"
#sed -f <path>/tex.sed <path>/*.ascii > <path>/*.tex
#sed -f <path>/tex.sed <path>/chmod.ascii > <path>/chmod.tex
#sed -f <path>/tex.sed <path>/env.ascii > <path>/env.tex
#sed -f <path>/tex.sed <path>/find.ascii > <path>/find.tex
#sed -f <path>/tex.sed <path>/fold.ascii > <path>/fold.tex
#sed -f <path>/tex.sed <path>/nice.ascii > <path>/nice.tex
#sed -f <path>/tex.sed <path>/pr.ascii > <path>/pr.tex
#sed -f <path>/tex.sed <path>/wc.ascii > <path>/wc.tex

s/\\/\\verb+\\+/g
s/%/\\%/g
s/\^/\\\^/g
s/--/-\\hspace{.01cm}-/g
1 i\
\\documentstyle\[11pt\]\{article\}\
\\begin\{document\}
1 i\
\\begin\{center\} \{\\bf
2 i\
\} \\end\{center\}
2 i\
\\begin\{description\}
$ a\
\\end\{description\}
2,$ s/^[A-Z]\{1,40\}/\\item\[&\] \\hfill \\\\/
$ a\
\\end\{document\}
/^[ \t]*[-+]/ s/.$/& \\\\/


#echo "creating tex file data/*.dvi"
#echo "latex -output-directory=<path> <path>/*.tex"
