# WebCrawl

Web Crawling and HTML Parsing - Team 5
——————————————————————————————————————

Description

———————————
Our project focuses on crawling , parsing and extracting important information from http://genomebiology.biomedcentral.com/  website using R.

The goal is to extract journals only between the mentioned start and end year automatically from the website using R and HTML parsing. 

Extracts Title, Authors, Author Affiliations, Correspondence Author, Correspondence Author's Email, Publish Date, Abstract, Keywords, Full Paper details from the papers between start year and end year.

File
————
crawl.R

Input
—————
Start year and End year of journals to be extracted from the website.

Output
——————
Stores the extracted data in one column for one field format and stores it in “data” local data frame in code ,”CrawledData.txt” in plain text format, “CrawledData.csv” in csv format and “CrawledData.RData” in R Data format.


Instructions to check the output
————————————————————————————————
- After execution , type data. 
- Check CrawledData.txt to view plain text results.
- Manually load CrawledData.RData or double click on the icon to auto load it in R IDE and type data.
- Manually load CrawledData.csv into R and print it.
- Open CrawledData.csv in MS Excel 

Required packages
—————————————————
- RCurl
- XML
- stringr 
- bitops

Authors and Contributions
—————————————————————————
- Yang Liu , Wrote the function to crawl and parse HTML code , crawled title, authors,publication date, keywords, text and stored the result.

- Tanmay More , Identified corresponding authors and their email id. Cleaned downloaded data.

- Sundari Selvarajan , Extended the crawl function with start year and end year. Added calculation of no. of pages for each year from the parsed HTML code. Crawled author affiliations and added to the result. Wrote the ReadMe file.


Team Information
________________

Team No. : 5
Members : 
- Yang Liu , yl558 
- Tanmay More , tmm37
- Sundari Selvarajan , ss2738
