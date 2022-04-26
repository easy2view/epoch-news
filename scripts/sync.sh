#!/bin/bash
# author: gfw-breaker

cur=$(dirname $0)
echo "working directory: $cur"
cd $cur

git pull

channels="$(cat index.csv | cut -d',' -f1)"

## create dirs
for channel in $channels ; do
	mkdir -p ../pages/$channel
	mkdir -p ../indexes/$channel
done

## get pages
for channel in $channels ; do
	page="https://www.epochtimes.com/gb/${channel}.htm"
	echo $page
	python get_pages.py $channel $page
done

## generate indexes
for channel in $channels ; do
	if [ $? -eq 0 ]; then
		title=$(cat index.csv | grep "$channel," | cut -d',' -f2)
		python gene_indexes.py $channel $title
	fi
done

## set timestamp
ts=$(date "+%m%d%H%M")
for channel in $channels ; do
	readme="../indexes/$channel/README.md"
	sed -i "s/md)/md?$ts)/g" $readme	
done
sed -i "s/md?[0-9]*)/md?$ts)/g" ../README.md 

## add links
for channel in $channels ; do
	readme="../indexes/$channel/README.md"
	tmp=/tmp/$channel
	sed -n '1,5p' $readme > $tmp
	sed "s/)/?$ts)/g" vs.md >> $tmp
	sed -n '6,$p' $readme >> $tmp
	cat $tmp > $readme
done


git add ../indexes/*
git add ../pages/*

git commit -a -m "have a nice day ~"
git push


