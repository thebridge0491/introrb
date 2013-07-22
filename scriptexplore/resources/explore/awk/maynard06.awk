# path = resources/explore/awk

#echo "problem 06: list, by users, # of sessions, total connect time, "
#echo "total input and output bandwidth usage in packets"
#awk -f <path>/maynard06.awk <path>/data06

/User-Name/ {
     user = $3
}

/Acct-Status-Type = Stop/ {
     sessions[user]++
}

/Acct-Session-Time/ {
     connect[user] += $3
}

/Acct-Input-Packets/ {
     inpack[user] += $3
}

/Acct-Output-Packets/ {
     outpack[user] += $3
}

/Framed-Address/ {
     user = ""
}

END{
     for ( usr in sessions ) {
        print "User:\t\t\t" usr
        print "Number of Sessions:\t" sessions[usr]
        print "Total Connect Time:\t" connect[usr]
        print "Input Bandwidth Usage:\t" inpack[usr]
        print "Output Bandwidth Usage:\t" outpack[usr]
        print
     }
}

