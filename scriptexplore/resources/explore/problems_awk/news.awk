# path = resources/explore/problems_awk

#echo "creating smaller 1000 line sample files f/ active, news, news.notice"
#sed '1,1000 ! d' <path>/active > <path>/active.txt
#sed '1,1000 ! d' <path>/news > <path>/news.txt
#sed '1,1000 ! d' <path>/news.notice > <path>/news.notice.txt

#echo "creating addgroup news.commands from active"
#awk -f <path>/news.awk <path>/active

{print "addgroup " $1 , $4}
