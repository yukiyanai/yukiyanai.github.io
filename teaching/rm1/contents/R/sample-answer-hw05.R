## sample-answer-hw05.R
##
## Purpose: Scraping excercise for RMPS I
## Output file: hw05-Yanai.csv
## 2015-11-11 Yuki Yanai

## imoprt some packs
library("plyr")
library("readr")
library("XML")
library("stringr")

## base url
base <- "http://www2.kobe-u.ac.jp/~yyanai/classes/rm1/contents/hw03/"

## get all hyperlinks
links <- getHTMLLinks(base)

## extract the hyperlinks with the string "student-"
students <- links[str_detect(links, "student-")]

## define the scraping function
scrape_answers <- function(path, base = NULL) {
    ## Function to scrape students' answers to hw03
    ## Arg: path = path from base URL to the page
    ##      base = base URL, leave it NULL if path is absolute 
    ## Return: df = data frame containing
    ##             (1) student's name
    ##             (2) date the file was created
    ##             (3) n. of "factorial" excet in the function name
    ##             (4) n. of "#" in the page
    
    df <- data.frame(name = NA, date = NA, factorials = NA, pound = NA)
    
    url <- str_c(base, path)  ## make the absoluthe path to the page
    ans_source <- readLines(url, encoding = "UTF-8")  ## open and read the page
    ans_parsed <- tryCatch(htmlParse(ans_source),
                           error = function(c) "error")

    if (class(ans_parsed)[1] == "character") {
        df$name <- str_sub(path, end = -6)
        return(df)
    } else {
        ## student's name
        name <- ans_parsed["//h4[@class='author']"]
        name <- ifelse(length(name) > 0, name[[1]] %>% xmlValue(),
                       str_sub(path, end = -6))
        
        ## date
        date <- ans_parsed["//h4[@class='date']"]
        date <- ifelse(length(date) > 0, date[[1]] %>% xmlValue(), NA)
        
        ## extract the div tags
        divs <- ans_parsed["//div"]
        ## the first "div", which is the outer "div", has all the content
        content <- divs[[1]] %>% xmlValue()
        
        ## the number of "factorial"s
        facts <- unlist(str_extract_all(content, "[\\s#][Ff]actorials?[\\.\\?\\s]"))
        n_facts <- length(facts)
        
        ## the number of "#"s
        pound <- unlist(str_extract_all(content, "#"))
        n_pound <- length(pound)
        
        df[1, ] <- c(name, date, n_facts, n_pound)
    }
    Sys.sleep(1)
    return(df)
}

## make a list of the relative paths to the students' pages
student_list <- as.list(students)

## apply the function to the list
myd <- ldply(student_list, .fun = scrape_answers, base = base)

## save the result in a CSV file
write_csv(myd, path = "data/hw05-Yanai.csv")
