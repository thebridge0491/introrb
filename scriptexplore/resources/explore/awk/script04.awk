# path = resources/explore/awk

#echo "problem 04: print out # of connections with connect rates in ranges:"
#echo "0-14400, 14401-19200, 19201-28800, 28801-33600, above 33600"
#awk -f <path>/maynard04.awk <path>/data04

BEGIN {rateA = 0 ; rateB = 0 ; rateC = 0 ; rateD = 0 ; rateE = 0}
/[ \t]*Ascend-Data-Rate/ && 0 <= $3 && $3 <= 14400 {rateA++}#{print ; rateA++}
/[ \t]*Ascend-Data-Rate/ && 14400 < $3 && $3 <= 19200 {rateB++}
/[ \t]*Ascend-Data-Rate/ && 19200 < $3 && $3 <= 28800 {rateC++}
/[ \t]*Ascend-Data-Rate/ && 28800 < $3 && $3 <= 33600 {rateD++}
/[ \t]*Ascend-Data-Rate/ && 33600 < $3{rateE++}
END {print "0-14400\t\t" rateA "\n" "14401-19200\t" rateB "\n" \
"19201-28800\t" rateC "\n" "28801-33600\t" rateD "\n" "above 33600\t" \
rateE}
