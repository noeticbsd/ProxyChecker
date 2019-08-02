#!/bin/bash
# ProxyCheckerCLI(SH) 2.0
# By Notic 
clear
#blacklist lookup urls
BLISTS="
    cbl.abuseat.org
    dnsbl.sorbs.net
    bl.spamcop.net
    dnsbl.dronebl.org
"
#sets raw proxy file
read -p "Enter Proxy List Name> " file

#sanatizes file
while checking= read -r line
	do
		ip=$(echo $line | awk '{print $1}')
		port=$(echo $line | awk '{print $2}')
echo $ip ":" $port >> $file.list
	done < "$file"
sed -i.list 's/ /''/g' /$PWD/$file.list
rm $file.list.list


#main code
for main in $(cut -f 1 $file.list) #$1 is used to store the proxy list file
	do
		cut -d ':' -f 1,7 $file.list >> $file.clean #remove 
		cat /$PWD/$file.list
		echo ""
		for check in $(cut -f 1 $file.clean) #
			do
				port=$(grep $check $file.list | cut -d ':' -f 2)
				reverse=$(echo $check | sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")
				for BL in ${BLISTS} ; do				  
				    LISTED="$(dig +short -t a ${reverse}.${BL})."                                      
			done
				    clear
				    printf "%-40s" " ${reverse}.${BL}."
				    echo "Host:" $check " - Port:" $port  " - Blacklist:" $LISTED
				    if [ $LISTED = "." ]; then
				    	echo ""
					cat /$PWD/$file.list
				    else
					echo ""
					sed "/$check/d" /$PWD/$file.list > /$PWD/$file.list1
					sed "/$check/d" /$PWD/$file.clean > /$PWD/$file.clean1
					cp /$PWD/$file.list1 /$PWD/$file.list
					cp /$PWD/$file.clean1 /$PWD/$file.clean
					cat /$PWD/$file.list
				    fi
				sleep 2
			done
			rm /$PWD/$file.clean /$PWD/$file.clean1 /$PWD/$file.list1	
	done

