# path = resources/explore/awk

#echo "problem 06: list, by users, # of sessions, total connect time, "
#echo "total input and output bandwidth usage in packets"
#awk -f <path>/maynard06.awk <path>/data06

/^[a-zA-Z]+/ {
name = ""
}
/User-Name/ {
name = $3
}
/^[ \t]+NAS-Identifier/ , /^$/ {
if ($3 ~ /Stop/) numSession[name]++
if ($1 ~ /Acct-Session-Time/) connectTime[name] += $3
if ($1 ~ /Acct-Input-Packets/) inPkts[name] += $3
if ($1 ~ /Acct-Output-Packets/) outPkts[name] += $3
}
END {for (user in numSession) if (1 <= numSession[user]) 
{print "User:\t\t\t" user "\nNumber of Sessions:\t" \
numSession[user] "\nTotal Connect Time:\t" connectTime[user] \
"\nInput Bandwidth Usage:\t" inPkts[user] "\nOutput Bandwidth Usage:\t" \
outPkts[user] "\n"}}
