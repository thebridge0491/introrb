# path = resources/explore/awk

#echo "problem 05: give the total input and output bandwidth usage in packets"
#awk -f <path>/maynard05.awk <path>/data05

#BEGIN {inPkts = 0 ; outPkts = 0}
/[ \t]*Acct-Input-Packets/ {inPkts += $3} # {print ; inPkts += $3}
/[ \t]*Acct-Output-Packets/ {outPkts += $3}
END {print "Total Input Bandwidth Usage  = " inPkts " packets\n" \
"Total Output Bandwidth Usage = " outPkts " packets"}
