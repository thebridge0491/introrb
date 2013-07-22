# path = resources/explore/awk

#echo "problem 04: print out # of connections with connect rates in ranges:"
#echo "0-14400, 14401-19200, 19201-28800, 28801-33600, above 33600"
#awk -f <path>/maynard04.awk <path>/data04

BEGIN{ num144 = 0
       num192 = 0
       num288 = 0
       num336 = 0
       numbig = 0
}

/Ascend-Data-Rate/{
   if ( $3 <= 14400 ) num144++
   else if ( $3 <= 19200 ) num192++
   else if ( $3 <= 28800 ) num288++
   else if ( $3 <= 33600 ) num336++
   else numbig++
}

END{ print "0-14400\t\t" num144
     print "14401-19200\t" num192
     print "19201-28800\t" num288
     print "28801-33600\t" num336
     print "above 33600\t" numbig
}

