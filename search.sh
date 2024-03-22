#!/bin/bash
set -e

while true; do
	find genshin_character/ -maxdepth 2 -type f| while read -r file; do
	steghide extract -sf "$file" -p "" -xf temp.txt 2>&1 
	hex=$(sed 's/[^[:xdigit:]]//g' temp.txt )
	decrypted_txt=$(echo "$hex" | xxd -r -p)
	#decrypted_txt=$(echo $hex | xxd -r)
	echo "$hex"
	echo "$decrypted_txt"
	if [[ $decrypted_txt = *'https'* ]]; then
		wget "$decrypted_txt"
		echo "[$(date "+%d/%m/%y %H:%M:%S")] [FOUND] [$file]" >> image.log
		exit 0
	else
		echo "[$(date "+%d/%m/%y %H:%M:%S")] [NOT FOUND] [$file]" >> image.log
		rm temp.txt
	fi
	done

	sleep 1
done
