# path = resources/explore/awk

#echo "problem 01: print out list of user names with quotes"
#awk -f <path>/maynard01.awk <path>/data01

/[ \t]*User-Name[^ \t]*/{print $3}
