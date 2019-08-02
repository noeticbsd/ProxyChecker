#!/bin/bash
echo "Enter list"
read file
while IFS= read -r line
	do
		ip=$(echo $line | awk '{print $1}')
		port=$(echo $line | awk '{print $2}')
echo $ip ":" $port >> $file.list
	done < "$file"
sed -i.list 's/ /''/g' /$PWD/$file.list
rm $file.list.list
