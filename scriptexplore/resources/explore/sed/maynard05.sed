# path = resources/explore/sed

#echo "problem 05: print out list of disk partitions (only dev/dsk) followed"
#echo "by FS type with a single tab between columns"
#sed -f <path>/maynard05.sed <path>/data05

/^$/d
/^[^/]/d
/^\/p/d
s/	[^	][^	]*	[^	][^	]*	[^	][^	]*[	]*$//
s/	[^	][^	]*	[^	][^	]*//
