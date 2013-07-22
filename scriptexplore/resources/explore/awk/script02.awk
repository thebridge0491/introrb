# path = resources/explore/awk

#echo "problem 02: print out list of user names without quotes"
#awk -f <path>/maynard02.awk <path>/data02

BEGIN {FS = "\""} \
/[ \t]*User-Name[^ \t]*/{print $2}
