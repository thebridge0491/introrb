# path = resources/explore/problems_awk

#echo "by system, counting articles read, groups read, 2413 articles read, "
#echo "2413.d articles read, total elapsed session time"
#awk -f <path>/newsread.awk <path>/news.notice

BEGIN {
s1 = "rings" ; s2 = "ringer" ; s3 = "runner" ; s4 = "lonestar"
headers[s1]++ ; headers[s2]++ ; headers[s3]++ ; headers[s4]++
for (i in headers) {
art[i] = 0 ; grp[i] = 0 ; m2413[i] = 0 ; d2413[i] = 0 ; uTime[i] = 0
}
print "\t\t\t  News Reader Summary\n\n\n" \
"\t\tlonestar\trunner\t\tringer\t\trings\n"
}
{ x++ }
x == 1 { timeStart = $1 " " $2 " " $3 }
$NR == $FNR { timeEnd = $1 " " $2 " " $3 }
$6 ~ /ring..\.cs/ || $6 ~ /runner\.jpl/ || $6 ~ /lonestar\.jpl/ {
if ($6 ~ /ring[0-9][0-9]\.cs/) choice = s1
if ($6 ~ /ringer\.cs/) choice = s2
if ($6 ~ /runner\.jpl/) choice = s3
if ($6 ~ /lonestar\.jpl/) choice = s4
if ($7 == "group" && $8 ~ /2413\.d/) d2413[choice] += $9
else if ($7 == "group" && $8 ~ /2413/) m2413[choice] += $9
if ($7 == "exit") { art[choice] += $9 ; grp[choice] += $11 }
if ($7 == "times") uTime[choice] += $13
}
END {
print "Articles:\t" art[s4] "\t\t" art[s3] "\t\t" art[s2] "\t\t" art[s1]
print "Groups:\t\t" grp[s4] "\t\t" grp[s3] "\t\t" grp[s2] "\t\t" grp[s1]
print "Cs2413:\t\t" m2413[s4] "\t\t" m2413[s3] "\t\t" m2413[s2] "\t\t" \
m2413[s1]
print "Cs2413.d:\t" d2413[s4] "\t\t" d2413[s3] "\t\t" d2413[s2] "\t\t" \
d2413[s1]
print "User Time:\t" uTime[s4] "\t\t" uTime[s3] "\t\t" uTime[s2] "\t\t" \
uTime[s1]
print "\nStart Time = " timeStart "\t\t End Time = " timeEnd
}
