# path = resources/explore/problems_sed

#echo "converting man page(s) to ascii for *.1"
#sed -f <path>/ascii.sed <path>/*.1 > <path>/*.ascii
#sed -f <path>/ascii.sed chmod.1 > <path>/chmod.ascii
#sed -f <path>/ascii.sed env.1 > <path>/env.ascii
#sed -f <path>/ascii.sed find.1 > <path>/find.ascii
#sed -f <path>/ascii.sed fold.1 > <path>/fold.ascii
#sed -f <path>/ascii.sed nice.1 > <path>/nice.ascii
#sed -f <path>/ascii.sed pr.1 > <path>/pr.ascii
#sed -f <path>/ascii.sed wc.1 > <path>/wc.ascii

s///g
s/_//g
/^[A-Z]/ s/\([A-Z]\)\1/\1/g
