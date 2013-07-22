# path = resources/explore/sed

#echo "problem 03: print all comment lines"
#sed -f <path>/maynard03.sed <path>/data03

/^#/ ! d
