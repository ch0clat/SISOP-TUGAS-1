\#!/bin/bash
set -e
wget 'https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip
unzip genshin.zip
unzip genshin_character.zip
cd genshin_character
ls | while read -r filename ; do
	decrypted=$(echo "$filename" | xxd -r -p)
	cd ..
	attribute=$(grep "$decrypted" list_character.csv | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
	cd genshin_character
	attribute=$(echo "$attribute" | cut -d ',' -f 2-)
	elemen_s=$(echo "$attribute" | cut -d ',' -f 2-| tr ',' '_')
	region=$(echo "$attribute" | cut -d ',' -f 1)
	decrypted=$(echo "$decrypted" | tr ' ' '-')
	new_filename="${region}_${decrypted}_${elemen_s}"
	mv "$filename" "$new_filename.jpg"
	directory="/home/ch0clat/sisoptest/genshin_character/$region/"
	mkdir -p "$region"
	mv "$new_filename.jpg" "$region/"
done

cd ..

echo "JUMLAH SETIAP JENIS SENJATA"

tail -n +2 list_character.csv | awk -F ',' '{print $4}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |  sort | uniq -c | while read -r count word; do
	echo "$word : $count"
done

rm genshin_character.zip
rm list_character.csv
rm genshin.zip
