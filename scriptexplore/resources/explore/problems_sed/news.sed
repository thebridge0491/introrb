# path = resources/explore/problems_sed

#echo "creating addgroup news.commands from active"
#sed -f <path>/news.sed <path>/active > <path>/news.commands

s/[ ][0-9]*[ ][0-9]*[ ]/ /
s/^./addgroup &/
