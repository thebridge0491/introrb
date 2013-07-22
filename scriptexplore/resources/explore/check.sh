#!/bin/sh

# usage: sh check.sh <instructor> <set> <prob> [show | <cmdtest> [opt1 .. N]]
# ex: sh check.sh maynard simperl 01 show
# ex: sh check.sh maynard simperl 01 [perl | python] $abspath/script.[pl | py]

if [ 4 -gt "$#" ] ; then
	echo "Not enough args:" ;
	echo "  usage: sh check.sh <instructor> <set> <prob> [show | <cmdtest> [opt1 .. N]]" ;
	exit ;
fi

diff_opts=${diff_opts:-"-Bb"}
instructor=$1 ; set=$2 ; prob=$3 ; shift ; shift ; shift ; cmdtest="$@"
scriptChk=$(readlink -f "$0") ; pathSet="$(dirname $scriptChk)/${set}"

check_sed() {
	case "${prob}" in
		"01") argsX="data01" ;;
		"02") argsX="data02" ;;
		"03") argsX="data03" ;;
		"04") argsX="data04" ;;
		"05") argsX="data05" ;;
	esac
	(cd ${pathSet} ; sed -f ${pathSet}/${instructor}${prob}.sed ${argsX} > \
		/tmp/.show${prob})
	
	if [ "show" = "${cmdtest}" ] ; then
		cat /tmp/.show${prob} ;
	else
		#cmdtest=`readlink -f ${cmdtest}` ;
		(cd ${pathSet} ; sed -f ${cmdtest} ${argsX} > /tmp/.test${prob}) ;
		res=`diff ${diff_opts} /tmp/.show${prob} /tmp/.test${prob}` ;
		
		if [ "" = "${res}" ] ; then
			echo "Correct Result - My solution follows: " ; echo "" ;
			cat ${pathSet}/${instructor}${prob}.sed ;
		else
			echo "Output differs: " ; echo "${res}" ;
		fi ;
	fi
}

check_awk() {
	case "${prob}" in
		"01") argsX="data01" ;;
		"02") argsX="data02" ;;
		"03") argsX="data03" ;;
		"04") argsX="data04" ;;
		"05") argsX="data05" ;;
		"06") argsX="data06" ;;
		"07") argsX="data07" ;;
	esac
	(cd ${pathSet} ; awk -f ${pathSet}/${instructor}${prob}.awk ${argsX} > \
		/tmp/.show${prob})
	
	if [ "show" = "${cmdtest}" ] ; then
		cat /tmp/.show${prob} ;
	else
		#cmdtest=`readlink -f ${cmdtest}` ;
		(cd ${pathSet} ; awk -f ${cmdtest} ${argsX} > /tmp/.test${prob}) ;
		res=`diff ${diff_opts} /tmp/.show${prob} /tmp/.test${prob}` ;
		
		if [ "" = "${res}" ] ; then
			echo "Correct Result - My solution follows: " ; echo "" ;
			cat ${pathSet}/${instructor}${prob}.awk ;
		else
			echo "Output differs: " ; echo "${res}" ;
		fi ;
	fi
}

check_simperl() {
	case "${prob}" in
		"01") argsX="data01/file1 data01/file2 data01/file3 data01/file4 data01/file5" ;;
		"02") argsX="data02/file1 data02/file2 data02/file3 data02/file4 data02/file5" ;;
		"03"|"04") argsX="data03/file1 data03/file2" ;;
		"05"|"06"|"07") argsX="data05" ;;
		"08") argsX="for f data08" ;;
	esac
	(cd ${pathSet} ; perl ${pathSet}/${instructor}.pl ${prob} ${argsX} > \
		/tmp/.show${prob})
	
	if [ "show" = "${cmdtest}" ] ; then
		cat /tmp/.show${prob} ;
	else
		#cmdtest=`readlink -f ${cmdtest}` ;
		(cd ${pathSet} ; ${cmdtest} ${prob} ${argsX} > /tmp/.test${prob}) ;
		res=`diff ${diff_opts} /tmp/.show${prob} /tmp/.test${prob}` ;
		
		if [ "" = "${res}" ] ; then
			echo "Correct Result - My solution follows: " ; echo "" ;
			sed -n "/sub simple${prob}/,/sub .*/p" \
				${pathSet}/${instructor}.pl ;
		else
			echo "Output differs: " ; echo "${res}" ;
		fi ;
	fi
}

check_perl() {
	case "${prob}" in
		"01") argsX="data01/filea data01/fileb" ;;
		"02") argsX="ba+d data02/filea data02/fileb data02/dir/filec" ;;
		"03") argsX="data03/files1a data03/files2a data03/files3a" ;;
		#"04") argsX="data04/{a,b,a/d}" ;;
		"04") argsX="data04/a data04/b data04/a/d" ;;
		"05") argsX="data05/dirsa" ;;
		"06") argsX="ba+d data06" ;;
		"07") argsX="solar data07/data.*" ;;
		"08") argsX="data08" ;;
		"09") argsX="data09" ;;
		"10") argsX="data10" ;;
		"11") argsX="data11" ;;
		"12") argsX="data12" ;;
		"13") argsX="data13" ;;
		"14") argsX="data14" ;;
		"15") argsX="data15" ;;
	esac
	(cd ${pathSet} ; perl ${pathSet}/${instructor}.pl ${prob} ${argsX} > \
		/tmp/.show${prob})
	
	if [ "show" = "${cmdtest}" ] ; then
		cat /tmp/.show${prob} ;
	else
		#cmdtest=`readlink -f ${cmdtest}` ;
		(cd ${pathSet} ; ${cmdtest} ${prob} ${argsX} > /tmp/.test${prob}) ;
		res=`diff ${diff_opts} /tmp/.show${prob} /tmp/.test${prob}` ;
		
		if [ "" = "${res}" ] ; then
			echo "Correct Result - My solution follows: " ; echo "" ;
			sed -n "/sub advanced${prob}/,/sub .*/p" \
				${pathSet}/${instructor}.pl ;
		else
			cat /tmp/.show${prob} | sort > /tmp/.sortshow${prob} ;
			cat /tmp/.test${prob} | sort > /tmp/.sorttest${prob} ;
			res=`diff ${diff_opts} /tmp/.sortshow${prob} /tmp/.sorttest${prob}` ;
			
			if [ "" = "${res}" ] ; then
				echo "Correct Result - My solution follows: " ; echo "" ;
				sed -n "/sub advanced${prob}/,/sub .*/p" \
					${pathSet}/${instructor}.pl ;
			else
				echo "Output differs: " ; echo "${res}" ;
			fi ;
		fi ;
	fi
}


func="check_${set}"
${func}

#-----------------------------------------------------------------------------
