#!/bin/sh
#blacklist lookup urls
BLISTS="
    cbl.abuseat.org
    bl.spamcop.net
    dnsbl.dronebl.org
"

echo "Enter list"
read file
while IFS= read -r line
	do
		ip=$(echo $line | awk '{print $4}')
		port=$(echo $line | awk '{print $5}')
		reverse=$(echo $ip | sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")
				for BL in ${BLISTS} ; do
				    #print the UTC date (without linefeed)
				    #printf $(env TZ=UTC date "+%Y-%m-%d_%H:%M:%S_%Z")
				    # show the reversed IP and append the name of the blacklist
				    #printf "%-40s" " ${reverse}.${BL}."
				    # use dig to lookup the name in the blacklist
				    #echo "$(dig +short -t a ${reverse}.${BL}. |  tr '\n' ' ')"
				    LISTED="$(dig +short -t a ${reverse}.${BL})."
				    echo "Host:" $ip "   Port:" $port "    Blacklist:" $LISTED
				done
		echo " "
		sleep 1
	done < "$file"
