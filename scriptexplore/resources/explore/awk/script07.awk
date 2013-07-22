# path = resources/explore/awk

#echo "problem 07: list, by users and session-id, time length of session, "
#echo "the time, the Framed-Address, the data rate, first destination address"
#awk -f <path>/maynard07.awk <path>/data07

BEGIN {FS = "[ \"]"}
/^[^ \t]*/ , /^[ \t]*$/ {
if ($1 ~ /User-Name/) {users[$4]++ ; name = $4}
if ($1 ~ /Acct-Session-Id/) sessionID[name] = $4
if ($1 ~ /Framed-Address/) frameAddress[name] = $3
if ($1 ~ /^[a-zA-Z]+/) discTime[name] = $4
if ($1 ~ /Acct-Session-Time/) sessionTime[name] = $3
if ($1 ~ /Ascend-First-Dest/) firstAddress[name] = $3
}
END {for (user in sessionID)
{print "User:\t\t\t" ("" == user ? "unknown" : user) "\nSession ID:\t\t" \
sessionID[user] "\nFramed Address:\t\t" frameAddress[user] \
"\nDisconnect Time:\t" discTime[user] "\nSession Time:\t\t" \
sessionTime[user] "\nFirst Address: \t\t" firstAddress[user] "\n"}}
