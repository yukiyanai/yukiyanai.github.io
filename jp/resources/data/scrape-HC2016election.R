## scrape-HC2016election.R
##############################################################
## Collect the results of prefecutre districts
## in the 2016 HC Election in Japan held on July 10, 2016
##
## 2016-07-11 Yuki Yanai (yanai@lion.kobe-u.ac.jp)
##############################################################
library("plyr")
library("readr")
library("XML")
library("stringr")


##################################################################################
### Prefecture Districts ###

## Function to scrape cadidates' info for a prefecture
scrape_pref <- function(url) {
    ## Argument: url = URL of the target page
    ## Return: res = data frame containing 8 variables
    
    pref_source <- readLines(url, encoding = 'UTF-8')  # read the page
    pref_parsed <- htmlParse(pref_source, encoding = 'UTF-8') # parse the HTML
    
    # Prefecture
    pref_name <- pref_parsed['//title']
    pref_name <- xmlValue(pref_name[[1]])
    cutoff <- regexpr(' -', pref_name)
    pref_name <- substr(pref_name, 1, cutoff[[1]] - 1)
    
    # District magnitude
    magnitude <- pref_parsed["//span[@class='Kaisen']"]
    magnitude <- xmlValue(magnitude[[1]])
    start <- regexpr('数', magnitude)
    end <- str_length(magnitude) - 1
    magnitude <- substr(magnitude, start[[1]] + 1, end)
        
    # Candidates' names
    cand_name <- pref_parsed["//td[@class='Name']"]
    cand_name <- lapply(cand_name, xmlValue)
    cand_name <- unlist(cand_name)
    N <- length(cand_name)

    # Candidates' parties
    cand_party <- pref_parsed["//td[@class='Party']"]
    cand_party <- lapply(cand_party, xmlValue)
    cand_party <- unlist(cand_party)
    
    # the number of votes and vote share (%)
    n_votes <- pref_parsed["//td[@class='Num']"]
    votes <- rep(NA, N)
    voteshare <- rep(NA, N)
    for (i in 1:N) {
        n_vote <- as(n_votes[[i]], 'character')
        n_vote <- str_split(n_vote, '<span>')
        # the number of votes
        num <- n_vote[[1]][1]
        start <- regexpr('>', num)
        votes[i] <- substr(num, start[[1]] + 1, str_length(num)) 
        # vote share
        share <- n_vote[[1]][2]
        end <- regexpr('％', share)
        voteshare[i] <- substr(share, 1, end[[1]] - 1)
    }
    
    # status (incumbent, ex-member, or new challenger)
    cand_status <- pref_parsed["//td[@class='Status']"]
    cand_status <- lapply(cand_status, xmlValue)
    cand_status <- unlist(cand_status)
    
    # result (win or lose)
    rose <- pref_parsed["//td[@class='Rose']"]
    result <- rep(NA, N)
    for (i in 1:N) {
        wl <- as(rose[[i]], 'character')
        wl <- str_detect(wl, 'rose_r.gif')
        result[i] <- ifelse(wl, 1, 0)
    }
 
    # save in the data frame
    res <- data.frame(prefecture = rep(pref_name, N),
                      magnitude = rep(magnitude, N),
                      candidate = cand_name,
                      party = cand_party,
                      votes = votes,
                      voteshare = voteshare,
                      status = cand_status,
                      win = result)

    Sys.sleep(3)   # pause three seconds 
    return(res)
}

## Scrape data from Asahi Shimbun's website
## 31 is Tottori and Shimane: 32 doesn't exist
## 36 is Tokushima and Kochi: 39 doesn't exist
nums <- c(1:31, 33:38, 40:47)
num2d <- formatC(nums, width = 2, flag = '0')
url_pref <- str_c('http://www.asahi.com/senkyo/senkyo2016/kaihyo/B', num2d, '.html')

## Apply the function to each prefecture
url_pref <- as.list(url_pref)
pref_results <- ldply(url_pref, .fun = scrape_pref)

## Save the result to CSV
write_csv(pref_results, path = 'hc2106-prefectures.csv')
##################################################################################

##################################################################################
### PR ###
url_pr <- 'http://www.asahi.com/senkyo/senkyo2016/kaihyo/C01.html'
pr_source <- readLines(url_pr, encoding = 'UTF-8')  # read the page
pr_parsed <- htmlParse(pr_source, encoding = 'UTF-8') # parse the HTML

n <- 12  ## number of parties in PR listed on Asahi's website

## Parties in PR
parties <- pr_parsed["//ul[@class='snkSubnavi HireiNavi']"]
parties <- xmlValue(parties[[1]])
parties <- str_split(parties, '\n')[[1]]
parties <- parties[1:n]


### PR by Party ###
## Num of PR seats
seats <- pr_parsed["//tr[@class='New']"]
seats <- xmlValue(seats[[1]])
seats <- str_split(seats, '\n')[[1]]
seats <- seats[1:n]
        
## Party Votes
votes <- pr_parsed["//ul[@class='SubVotes']"]
n_votes <- rep(NA, n)
voteshare <- rep(NA, n)
for (i in 1:n) {
    tmp <- votes[[i]]
    tmp <- xmlValue(tmp)
    tmp <- str_split(tmp, '：')[[1]][2]
    tmp <- str_split(tmp, '（')[[1]]
    n_votes[i] <- tmp[1]
    voteshare[i] <- str_split(tmp[2], '%')[[1]][1]
}

## Votes by Party Name
p_vote <- pr_parsed["//ul[@class='OptItm']"]
votes_partyname <- rep(NA, n)
for (i in 1:n) {
    tmp <- p_vote[[i]]
    tmp <- xmlValue(tmp)
    tmp <- str_split(tmp, '：')[[1]][2]
    votes_partyname[i] <- gsub('\n', '', tmp)
}

## Create a data frame
pr_party <- data.frame(party = parties,
                       seats = seats,
                       votes = n_votes,
                       partyname_votes = votes_partyname,
                       voteshare = voteshare)

## Save the data
write_csv(pr_party, path = 'hr2016-pr-parties.csv')


### PR by Candidate ###
pr_by_cand <- list()
tbls <- pr_parsed["//tbody"]
for (p in 2:(n+1)) {
    p_tbl <- htmlParse(as(tbls[[p]], 'character'), encoding = 'UTF-8')
    
    # Name
    names <- p_tbl["//td[@class='Name']"]
    names <- unlist(lapply(names, xmlValue))
    
    n_cand <- length(names)
    
    # Status
    status <- p_tbl["//td[@class='Status']"]
    status <- unlist(lapply(status, xmlValue))
    
    # Number of votes
    votes <- p_tbl["//td[@class='Num']"]
    votes <- unlist(lapply(votes, xmlValue))
    
    # result (win or lose)
    rose <- p_tbl["//td[@class='Rose']"]
    result <- rep(NA, n_cand)
    for (i in 1:n_cand) {
        wl <- as(rose[[i]], 'character')
        wl <- str_detect(wl, 'rose_r.gif')
        result[i] <- ifelse(wl, 1, 0)
    }
    
    # data frame for a party
    df <- data.frame(party = rep(parties[(p-1)], n_cand),
                     candidate = names,
                     status = status,
                     votes = votes,
                     win = result)
    
    # add df to the list
    pr_by_cand[[(p-1)]] <- df
}

## Maek a data frame
pr_candidate <- ldply(pr_by_cand, data.frame)

## Save the data
write_csv(pr_candidate, path = 'hc2016-pr-candidate.csv')
