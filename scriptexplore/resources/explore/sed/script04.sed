# path = resources/explore/sed

#echo "problem 04: change FS type on lines containing c1t1 from ufs to ext2"
#echo "and change c1t1 to c1t2"
#sed -f <path>/maynard04.sed <path>/data04

/c1t1/ s/ufs/ext2/g
s/c1t1/c1t2/g
