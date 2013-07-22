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
END {
{print "User:\t\t\t" "" "\nNumber of Sessions:\t" \
numSession[""] "\nTotal Connect Time:\t" connectTime[""] \
"\nInput Bandwidth Usage:\t" inPkts[""] "\nOutput Bandwidth Usage:\t" \
outPkts[""] "\n"}
{print "User:\t\t\t" "\"daven917\"" "\nNumber of Sessions:\t" \
numSession["\"daven917\""] "\nTotal Connect Time:\t" connectTime["\"daven917\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"daven917\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"daven917\""] "\n"}
{print "User:\t\t\t" "\"chris\"" "\nNumber of Sessions:\t" \
numSession["\"chris\""] "\nTotal Connect Time:\t" connectTime["\"chris\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"chris\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"chris\""] "\n"}
{print "User:\t\t\t" "\"rmckeel\"" "\nNumber of Sessions:\t" \
numSession["\"rmckeel\""] "\nTotal Connect Time:\t" connectTime["\"rmckeel\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"rmckeel\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"rmckeel\""] "\n"}
{print "User:\t\t\t" "\"cunder\"" "\nNumber of Sessions:\t" \
numSession["\"cunder\""] "\nTotal Connect Time:\t" connectTime["\"cunder\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"cunder\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"cunder\""] "\n"}
{print "User:\t\t\t" "\"rebates\"" "\nNumber of Sessions:\t" \
numSession["\"rebates\""] "\nTotal Connect Time:\t" connectTime["\"rebates\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"rebates\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"rebates\""] "\n"}
{print "User:\t\t\t" "\"edvargas\"" "\nNumber of Sessions:\t" \
numSession["\"edvargas\""] "\nTotal Connect Time:\t" connectTime["\"edvargas\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"edvargas\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"edvargas\""] "\n"}
{print "User:\t\t\t" "\"shadow\"" "\nNumber of Sessions:\t" \
numSession["\"shadow\""] "\nTotal Connect Time:\t" connectTime["\"shadow\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"shadow\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"shadow\""] "\n"}
{print "User:\t\t\t" "\"dvorak\"" "\nNumber of Sessions:\t" \
numSession["\"dvorak\""] "\nTotal Connect Time:\t" connectTime["\"dvorak\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"dvorak\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"dvorak\""] "\n"}
{print "User:\t\t\t" "\"wkuechle\"" "\nNumber of Sessions:\t" \
numSession["\"wkuechle\""] "\nTotal Connect Time:\t" connectTime["\"wkuechle\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"wkuechle\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"wkuechle\""] "\n"}
{print "User:\t\t\t" "\"wynng\"" "\nNumber of Sessions:\t" \
numSession["\"wynng\""] "\nTotal Connect Time:\t" connectTime["\"wynng\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"wynng\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"wynng\""] "\n"}
{print "User:\t\t\t" "\"cstaples\"" "\nNumber of Sessions:\t" \
numSession["\"cstaples\""] "\nTotal Connect Time:\t" connectTime["\"cstaples\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"cstaples\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"cstaples\""] "\n"}
{print "User:\t\t\t" "\"pansut0\"" "\nNumber of Sessions:\t" \
numSession["\"pansut0\""] "\nTotal Connect Time:\t" connectTime["\"pansut0\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"pansut0\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"pansut0\""] "\n"}
{print "User:\t\t\t" "\"mustang\"" "\nNumber of Sessions:\t" \
numSession["\"mustang\""] "\nTotal Connect Time:\t" connectTime["\"mustang\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"mustang\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"mustang\""] "\n"}
{print "User:\t\t\t" "\"alcestys\"" "\nNumber of Sessions:\t" \
numSession["\"alcestys\""] "\nTotal Connect Time:\t" connectTime["\"alcestys\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"alcestys\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"alcestys\""] "\n"}
{print "User:\t\t\t" "\"tweety\"" "\nNumber of Sessions:\t" \
numSession["\"tweety\""] "\nTotal Connect Time:\t" connectTime["\"tweety\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"tweety\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"tweety\""] "\n"}
{print "User:\t\t\t" "\"kiri\"" "\nNumber of Sessions:\t" \
numSession["\"kiri\""] "\nTotal Connect Time:\t" connectTime["\"kiri\""] \
"\nInput Bandwidth Usage:\t" inPkts["\"kiri\""] "\nOutput Bandwidth Usage:\t" \
outPkts["\"kiri\""] "\n"}
}
