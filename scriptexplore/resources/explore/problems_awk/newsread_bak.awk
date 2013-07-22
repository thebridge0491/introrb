# path = resources/explore/problems_awk

#echo "by system, counting articles read, groups read, 2413 articles read, "
#echo "2413.d articles read, total elapsed session time"
#awk -f <path>/newsread.awk <path>/news.notice

BEGIN {
headers["Articles"]++ ; headers["Groups"]++ ; headers["Cs2413"]++ ; \
headers["Cs2413.d"]++ ; headers["User Time"]++
for (i in headers) {
lonestar[i] = 0 ; runner[i] = 0 ; ringer[i] = 0 ; rings[i] = 0
}
print "\t\t\t  News Reader Summary\n\n\n" \
"\t\tlonestar\trunner\t\tringer\t\trings\n"
}
{ x++ }
x == 1 { timeStart = $1 " " $2 " " $3 }
$NR == $FNR { timeEnd = $1 " " $2 " " $3 }
$6 ~ /lonestar\.jpl/ {
if ($7 == "group" && $8 ~ /2413\.d/) lonestar["Cs2413.d"] += $9
else if ($7 == "group" && $8 ~ /2413/) lonestar["Cs2413"] += $9
if ($7 == "exit") lonestar["Articles"] += $9 ; lonestar["Groups"] += $11
if ($7 == "times") lonestar["User Time"] += $9
}
$6 ~ /runner\.jpl/ {
if ($7 == "group" && $8 ~ /2413\.d/) runner["Cs2413.d"] += $9
else if ($7 == "group" && $8 ~ /2413/) runner["Cs2413"] += $9
if ($7 == "exit") runner["Articles"] += $9 ; runner["Groups"] += $11
if ($7 == "times") runner["User Time"] += $9
}
$6 ~ /ringer\.cs/ {
if ($7 == "group" && $8 ~ /2413\.d/) ringer["Cs2413.d"] += $9
else if ($7 == "group" && $8 ~ /2413/) ringer["Cs2413"] += $9
if ($7 == "exit") ringer["Articles"] += $9 ; ringer["Groups"] += $11
if ($7 == "times") ringer["User Time"] += $9
}
$6 ~ /ring[0-9][0-9]\.cs/ {
if ($7 == "group" && $8 ~ /2413\.d/) rings["Cs2413.d"] += $9
else if ($7 == "group" && $8 ~ /2413/) rings["Cs2413"] += $9
if ($7 == "exit") rings["Articles"] += $9 ; rings["Groups"] += $11
if ($7 == "times") rings["User Time"] += $9
}
END {
i = "Articles" ; \
print i ":\t" lonestar[i] "\t\t" runner[i] "\t\t" ringer[i] "\t\t" rings[i]
i = "Groups" ; \
print i ":\t\t" lonestar[i] "\t\t" runner[i] "\t\t" ringer[i] "\t\t" rings[i]
i = "Cs2413" ; \
print i ":\t\t" lonestar[i] "\t\t" runner[i] "\t\t" ringer[i] "\t\t" rings[i]
i = "Cs2413.d" ; \
print i ":\t" lonestar[i] "\t\t" runner[i] "\t\t" ringer[i] "\t\t" rings[i]
i = "User Time" ; \
print i ":\t" lonestar[i] "\t\t" runner[i] "\t\t" ringer[i] "\t\t" rings[i]
print "\nStart Time = " timeStart "\t\t End Time = " timeEnd
}
