# path = resources/explore/sed

#echo "problem 01: delete all blank lines"
#sed -f <path>/maynard01.sed <path>/data1

/^[ \t]*$/ d
