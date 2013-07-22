# path = resources/explore/problems_awk

#echo "counting articles by accepted, canceled, rejected"
#awk -f <path>/newsfeed.awk <path>/new

BEGIN {
print "\t\t      Incoming News Feed Summary\n\n\n" \
"\t\taccepted\trejected\tcanceled"
}
{ x++ }
x == 1 { timeStart = $1 " " $2 " " $3 }
$NR == $FNR { timeEnd = $1 " " $2 " " $3 }
$5 == "swrinde" || $5 == "news.cais.net" || $5 == "?" {
ringers[$5]++ ; name = $5
if ($4 != "-") artAccept[name]++
else artAccept[name] += 0
if ($4 == "-") artReject[name]++
else artReject[name] += 0
if ($4 == "c") artCancel[name]++
else artCancel[name] += 0
}
END {
i = "swrinde" ; print i ":\t" artAccept[i] "\t\t" artReject[i] \
"\t\t" artCancel[i]
i = "news.cais.net" ; print i ":\t" artAccept[i] "\t\t" artReject[i] \
"\t\t" artCancel[i]
i = "?" ; print i ":\t\t" artAccept[i] "\t\t" artReject[i] \
"\t\t" artCancel[i]
print "\nStart Time = " timeStart "\t End Time = " timeEnd
}
