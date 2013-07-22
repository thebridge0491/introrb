# path = resources/explore/awk

#echo "problem 05: give the total input and output bandwidth usage in packets"
#awk -f <path>/maynard05.awk <path>/data05

BEGIN{ inpacks = 0
       outpacks = 0
}

/Acct-Input-Packets/{
     inpacks += $3
}

/Acct-Output-Packets/{
     outpacks += $3
}

END{ print "Total Input Bandwidth Usage  =", inpacks, "packets"
     print "Total Output Bandwidth Usage =", outpacks, "packets"
}
