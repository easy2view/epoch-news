#!/usr/bin/python
# coding: utf-8

import sys
import os
import shutil
import requests
from bs4 import BeautifulSoup

channel = sys.argv[1]
title = sys.argv[2]

pageSize = 30
maxPages = 1000


def get_footer(pageNum):
	plinks = ''
	end = (pageNum -8) if (pageNum-8) > 0 else 0
	start = pageNum 
	for i in range(start, end, -1):
		plinks += " [%d](./%d.md) /" % (i, i)
	md = "#### 第 [%s] 页" % plinks[0:-1]
	return md


def write_index(page, items, title, footer):
	md = "### %s\n---\n" % title
	for item in items:
		cols = item.rstrip().split(',')
		path = "../../pages/%s/%s.md" % (channel, cols[0])
		md += "#### [%s](%s) \n" % (cols[1], path)
	md += "\n---\n%s\n" % footer
	fh = open(page, 'w')
	fh.write(md)
	fh.close()
	

def get_slice(pageNum, lines):
	start = pageSize*(pageNum - 1) 
	end = pageSize*pageNum 
	if end > len(lines):
		start = len(lines) - pageSize
	return lines[start:end][::-1]
	

## main
csv = "../indexes/%s.csv" % (channel)
lines = open(csv, "r").readlines() 

for i in range(1, maxPages):
	if pageSize*(i-1) >= len(lines):
		break
	page = "../indexes/%s/%d.md" % (channel, i)
	items = get_slice(i, lines)
	footer = get_footer(i)
	write_index(page, items, title, footer)
	lastIndex = i

lastPage = "../indexes/%s/%d.md" % (channel, lastIndex) 
readmePage = "../indexes/%s/README.md" % (channel)
shutil.copyfile(lastPage, readmePage)


