#############################################################################################
############################### Web Crawling and HTML Parsing ###############################
#############################################################################################

library(RCurl)
library(XML)
library(stringr)
library(bitops)


v_to_str=function(v){
  return(paste(v,collapse=", "))
}

crawl_data=function(syear,eyear){
  
  data=data.frame(title=c(1,2),authors=c(1,2),affs=c(1,2),c_authors=c(1,2),c_author_emails=c(1,2),pub_date=c(1,2),abstract=c(1,2),keywords=c(1,2),text=c(1,2))

  for ( year in syear:eyear)  {

    vol=toString(year+1)
    vol=gsub('20','',vol)
    index_url=paste("http://genomebiology.biomedcentral.com/articles?tab=keyword&searchType=journalSearch&sort=PubDate&volume=",vol,sep = "")
    
    html <- getURL(index_url, followlocation=TRUE,.encoding = "UTF-8")
    #Parse HTML
    doc = htmlParse(html, asText=TRUE)

    #Calculate no. of pages containing all the journals published in the year specified. 
    sp_pages = xpathSApply(doc, "//span[@class='Control_name']", xmlValue)
    sp_pages = unlist(sp_pages,recursive=TRUE)
    pages = strsplit(sp_pages," ")
    pages = strtoi(pages[[1]][4])
    

    if(pages==0){
      #Throw error if no journals found.
      prompt("NO Article Found!!!")
     }
    else{

      for(page in 1:pages){
        
          index_url=paste("http://genomebiology.biomedcentral.com/articles?query=&volume=",vol,"&searchType=&tab=keyword&page=",toString(page),sep="")

          html <- getURL(index_url, .encoding = "UTF-8")
          doc = htmlParse(html, asText=TRUE)

          paper_urls=xpathSApply(doc, "//*[@class='fulltexttitle']", xmlGetAttr,'href')

          for (i in paper_urls){
            
            paper_url=paste("http://genomebiology.biomedcentral.com",i)
            paper_url=gsub(' ','',paper_url)

            html <- getURL(paper_url,.encoding = "UTF-8")
            doc = htmlParse(html, asText=TRUE)
            
            #extracting needed information from the parsed HTML code.
            
            title=xpathSApply(doc,"//*[@class='ArticleTitle']",xmlValue)

            authors=xpathSApply(doc,"//*[@class='AuthorName']",xmlValue)
            authors=v_to_str(authors)

            affs=xpathSApply(doc,"//*[@class='Affiliation']/*[@class='AffiliationText']",xmlValue)
            affs = v_to_str(affs)
            
            c_authors=xpathSApply(doc,"//*[@class='EmailAuthor']/../*[@class='AuthorName']",xmlValue)
            c_authors=v_to_str(c_authors)

            c_author_emails=xpathSApply(doc,"//*[@class='EmailAuthor']",xmlGetAttr,'href')
            c_author_emails=v_to_str(c_author_emails)
            c_author_emails=gsub('mailto:\\s*', '', c_author_emails)

            pub_date=xpathSApply(doc,"//*[@class='History HistoryOnlineDate']",xmlValue)

            pub_date = gsub('Published:\\s*', '', pub_date)

            keywords=xpathSApply(doc,"//*[@class='Keyword']",xmlValue)
            keywords=v_to_str(keywords)

            abs=xpathSApply(doc,"//*[@class='AbstractSection']/*[@class='Para']",xmlValue)
            abs=v_to_str(abs)

            text=xpathSApply(doc,"//section/div/*[@class='Para']",xmlValue)
            text=v_to_str(text)


            result=c(title,authors,affs,c_authors,c_author_emails,pub_date,abs,keywords,text)
            data=rbind(data,result)
            
            remove(title,authors,affs,c_author_emails,pub_date,abs,keywords,text)
            
            }
          }
        }

      }
    return(data)
  }

start_year = readline(prompt = "Enter Start Year : ")
end_year = readline(prompt = "Enter End Year : ")

data=crawl_data(start_year,end_year)
data=data[c(-1,-2),]

#Storing the returned crawled data in RData format
save(data,file="CrawledData.RData")

#Storing the returned crawled data in csv format
write.csv(data,"CrawledData.csv",fileEncoding = "UTF-8")

#Storing the returned crawled data in text format
write.table(data,"CrawledData.txt",fileEncoding = "UTF-8",eol="\n")

