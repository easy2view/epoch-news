#!/bin/bash
# author: gfw-breaker

maxPages=20
channels="$(cat index.csv | cut -d',' -f1)"

## install runtime
yum install -y python python-pip
python -m pip install requests BeautifulSoup4

## create dirs
for channel in $channels ; do
	mkdir -p ../pages/$channel
	mkdir -p ../indexes/$channel
done
	
## get feeds files
for channel in $channels ; do
	for i in $(seq $maxPages -1 1); do
		page="https://www.epochtimes.com/gb/${channel}_${i}.htm"
		wget -q $page -O /tmp/null > /dev/null
		if [ $? -eq 0 ]; then
			echo $page
			python get_pages.py $channel $page
		fi
	done
done


