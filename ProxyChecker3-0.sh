#!/bin/sh
#blacklist lookup urls
BLISTS="
    cbl.abuseat.org
#    bl.spamcop.net
#    dnsbl.dronebl.org
"

#proxy file clean up
echo "Enter list"
read file
while IFS= read -r line
	do
		ip=$(echo $line | awk '{print $4}')
		port=$(echo $line | awk '{print $5}')
		echo $ip ":" $port >> master.list
	done < "$file"
sed -i.list 's/ /''/g' /$PWD/master.list
rm master.list.list
#end clean up

#main code
for main in $(cut -f 1 master.list) #$1 is used to store the proxy list file
	do
		cut -d ':' -f 1,7 master.list >> master.list-clean #remove 
		for check in $(cut -f 1 master.list-clean) #
			do
				port=$(grep $check master.list | cut -d ':' -f 2)
				reverse=$(echo $check | sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")
				for BL in ${BLISTS} ; do
				    # print the UTC date (without linefeed)
				    printf $(env TZ=UTC date "+%Y-%m-%d_%H:%M:%S_%Z")
				    # show the reversed IP and append the name of the blacklist
				    printf "%-40s" " ${reverse}.${BL}."
				    # use dig to lookup the name in the blacklist
				    #echo "$(dig +short -t a ${reverse}.${BL}. |  tr '\n' ' ')"
				    LISTED="$(dig +short -t a ${reverse}.${BL})."
				    echo "Host:" $check "   Port:" $port "    Blacklist:" $LISTED
				done
				echo " "
			done
	done
#end main code
#issues: Endless loop

