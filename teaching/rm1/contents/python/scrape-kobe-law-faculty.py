# -*- coding:utf-8 -*-


##############################################################
## scrape-kobe-law-faculty.py
##
## Purpose: Scrape the name, title, and sepcialty of
##          the facluty members in the Law Dep't at Kobe U.
## Output: kobe-law-faculty.csv
## Created: 2014-10-28 Yuki Yanai
## Modified: 2015-11-03 YY
##############################################################
#import urllib2
import urllib.request
import urllib.error
import csv
import re
from bs4 import BeautifulSoup as BS

## Base URL to get
path = 'http://www.law.kobe-u.ac.jp/{}.html'

## List of pages to visit
##  専任教員 (tenured or tenure-track), 特命教員 (non tenure-track, fixed-term)
pages = [
    'staff-name',         ## part of the URL for tenure-track
    'stafftokunin-name',  ## part of the URL for non tenure
    ]

## List of status
status = ['tenure', 'fixed-term']

## List of table widths
widths = [4, 3]

## prepare a URL opener

opener = urllib.request
opener.addheaders = [('User-agent', 'Mozila/5.0')]

## prepare csv opener
filename = 'kobe-law-faculty.csv'
writecsv = csv.writer(open(filename, 'w'))
## variables to save
writecsv.writerow([
    'status',
    'name',
    'title',
    'specialty'
    ])


## regular expression to srip HTML tags
p = re.compile(r'<.*?>')


## set counter
counter = 0
for page in pages:       ## loop for pages to visit
    try:
        ## put the page source into the soup
        soup = BS(opener.urlopen(path.format(page)), "html.parser")

        ## find elements in <td> tags
        res = soup.findAll("td")

        ## delete the first and second items in the list
        res = res[2:]

        ## status
        stat = status[counter]

        ## the number of members = length of the list divided by table width
        ## the width is 4 for tenured-tack faculties and 3 for fixed-term ones
        d = widths[counter]
        num = int(len(res) / d)

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
   
    except urllib.error.HTTPError as instance:
        if instance.code == 404:
            ## if page not found
            print("Page Not Found: " + path.format(page))
        else:
            ## if access denied: 403
            print("Access Denied: " + path.format(page))

    counter += 1

## Show the message when scraping finishes
print("Mission completed!")
