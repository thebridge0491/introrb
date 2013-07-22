# path = resources/explore/awk

#echo "problem 03: compute total # of user minutes represented by events"
#awk -f <path>/maynard03.awk <path>/data03

/Acct-Session-Time/{
    time += $3;
}
END{ print "Total User Session Time =",time }
