setwd("C:/Bruno/coursera/10_Data science capstone")
library(quanteda)
library(readtext)
library(tidyr)
library(ggplot2)
library(textclean)
library(lexicon)
library(stringr)

linesTwitter <- readLines("final/en_US/en_US.twitter.txt",encoding="UTF-8",skipNul = T)
linesBlogs <- readLines("final/en_US/en_US.blogs.txt",encoding="UTF-8",skipNul = T)
linesNews <- readLines("final/en_US/en_US.news.txt", encoding="UTF-8",skipNul = T)

twitsam <- sample(linesTwitter, size = length(linesTwitter)*0.05)
blogsam <- sample(linesBlogs, size = length(linesBlogs)*0.05)
newssam <- sample(linesNews, size = length(linesNews)*0.05)
sam <- c(twitsam,blogsam,newssam)

tokensam <- tolower(sam)

tokensam <- replace_contraction(tokensam,contraction.key = lexicon::key_contractions,
                               ignore.case = TRUE) 
tokensam <- replace_internet_slang(tokensam, slang = paste0("\\b",lexicon::hash_internet_slang[[1]], "\\b"),
                                   replacement = lexicon::hash_internet_slang[[2]], ignore.case = TRUE)

tokensam <- str_replace_all(sam,"[^a-zA-Z\\s]", " ")

tokensam <- tokens(tokensam,remove_numbers = T,remove_punct = T,remove_symbols = T,remove_url = T)
tokensam <- tokens_select(tokensam, pattern = stopwords('en'), selection = 'remove')
tokensam <- tokens_select(tokensam, pattern = profanity_banned, selection = 'remove')


bigram <- dfm(tokens_ngrams(tokensam,n=2))
trigram <- dfm(tokens_ngrams(tokensam,n=3))
quadgram <- dfm(tokens_ngrams(tokensam,n=4))

bidata <- as.data.frame((topfeatures(bigram, n=100000)))
bidata$bigram <- rownames(bidata)
rownames(bidata) = NULL
bidata <- separate(bidata,2,into=c("word1","word2"),sep="_")
#bidata <- bidata[order(bidata$top), ]

tridata <- as.data.frame((topfeatures(trigram, n=100000)))
tridata$trigram <- rownames(tridata)
rownames(tridata) = NULL
tridata <- separate(tridata,2,into=c("word1","word2","word3"),sep="_")
#tridata <- tridata[order(tridata$word1), ]

quaddata <- as.data.frame((topfeatures(quadgram, n=100000)))
quaddata$quadgram <- rownames(quaddata)
rownames(quaddata) = NULL
quaddata <- separate(quaddata,2,into=c("word1","word2","word3","word4"),sep="_")
#tridata <- tridata[order(tridata$word1), ]


#saveRDS(bidata, "./app/bidata.rds")
#saveRDS(tridata, "./app/tridata.rds")
#saveRDS(quaddata,"./app/quaddata.rds")
