# -*- coding:utf-8 -*-


##############################################################
## scrape-kobe-law-faculty.py
##
## Purpose: Scrape the name, title, and sepcialty of
##          the facluty members in the Law Dep't at Kobe U.
## Output: kobe-law-faculty.csv
## Created: 10/28/2014 Yuki Yanai
## Modified: 10/31/2014 YY
##############################################################

## Base URL to get
path = 'http://www.law.kobe-u.ac.jp/{}.html'

##　List of pages to visit
##  専任教員, 特命教員
pages = [
    'staff-name',         ## 専任のアドレスの一部
    'stafftokunin-name',  ## 特命
    ]

## List of status
status = ['専任教員', '特命教員']

## List of table widths
widths = [4, 3]

## prepare a URL opener
import urllib2
opener = urllib2.build_opener()
opener.addheaders = [('User-agent', 'Mozila/5.0')]

## prepare csv opener
import csv
filename = 'kobe-law-faculty.csv'
writecsv = csv.writer(file(filename, 'w'))
## variables to save
writecsv.writerow([
    'status',
    'name',
    'title',
    'specialty'
    ])

## import re to strip HTML tags
import re
p = re.compile(r'<.*?>')

## use beautifulsoup for scraping
from bs4 import BeautifulSoup as BS

## set counter
counter = 0
for page in pages:       ## loop for pages to visit
    try:
        ## put the page source into the soup
        soup = BS(opener.open(path.format(page)))

        ## find elements in <td> tags
        res = soup.findAll('td')

        ## delete the first and second items in the list
        res = res[2:]

        ## status
        stat = status[counter]

        ## the number of members = length of the list divided by table width
        ## the width is 4 for Sennin and 3 for Tokumei
        d = widths[counter]
        num = len(res) / d

        for i in range (0, num):  ## loop for members (or rows of the table)

            ## the 1st column has names
            name = res[0+d*i]
            ## strip HTML tags
            name = p.sub('', str(name))
                        
            ## the 2nd column has titles
            title = res[1+d*i]
            ## strip HTML tags
            title = p.sub('', str(title))
            
            ## the 3rd column has specialty
            spec = res[2+d*i]
            ## strip HTML tags
            spec = p.sub('', str(spec))

            ## save the data
            writecsv.writerow([
                stat,
                name,
                title,
                spec
                ])
   
    except urllib2.HTTPError as instance:
        if instance.code == 404:
            ## if page not found
            print("Page Not Found: " + path.format(page))
        else:
            ## if access denied: 403
            print("Access Denied: " + path.format(page))

    counter += 1

## Show the message when scraping finishes
print("Mission completed!")
