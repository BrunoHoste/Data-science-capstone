
library(tm)
library(dplyr)
library(stringi)
library(stringr)
library(quanteda)
library(data.table)
library(lexicon)


linesTwitter <- readLines("final/en_US/en_US.twitter.txt",encoding="UTF-8")
linesBlogs <- readLines("final/en_US/en_US.blogs.txt",encoding="UTF-8")
linesNews <- readLines("final/en_US/en_US.news.txt", encoding="UTF-8")

twitsam <- sample(linesTwitter, size = length(linesTwitter)*0.05)
blogsam <- sample(linesBlogs, size = length(linesBlogs)*0.05)
newssam <- sample(linesNews, size = length(linesNews)*0.05)
sam <- c(twitsam,blogsam,newssam)

sam <- iconv(sam, "latin1", "ASCII", sub = "")


sam <- tolower(sam)


sam <- replace_contraction(sam,contraction.key = lexicon::key_contractions,
                             ignore.case = TRUE) 


sam <- replace_internet_slang(sam, slang = paste0("\\b",lexicon::hash_internet_slang[[1]], "\\b"),
                                replacement = lexicon::hash_internet_slang[[2]], ignore.case = TRUE)


# remove URL, email addresses, Twitter handles and hash tags
sam <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", sam, ignore.case = FALSE, perl = TRUE)
sam <- gsub("\\S+[@]\\S+", "", sam, ignore.case = FALSE, perl = TRUE)
sam <- gsub("@[^\\s]+", "", sam, ignore.case = FALSE, perl = TRUE)
sam <- gsub("#[^\\s]+", "", sam, ignore.case = FALSE, perl = TRUE)
sam <- gsub("[0-9](?:st|nd|rd|th)", "", sam, ignore.case = FALSE, perl = TRUE)
sam <- gsub("[^\\p{L}'\\s]+", "", sam, ignore.case = FALSE, perl = TRUE)
sam <- gsub("[.\\-!]", " ", sam, ignore.case = FALSE, perl = TRUE)

# trim leading and trailing whitespace
sam <- gsub("^\\s+|\\s+$", "", sam)
sam <- stripWhitespace(sam)

tokensam <- tokens(sam,remove_numbers = T,remove_punct = T,remove_symbols = T,remove_url = T)

bigram <- dfm(tokens_ngrams(tokensam,n=2))
trigram <- dfm(tokens_ngrams(tokensam,n=3))
quadgram <- dfm(tokens_ngrams(tokensam,n=4))

bidata <- as.data.frame((topfeatures(bigram, n=100000)))
bidata$bigram <- rownames(bidata)
rownames(bidata) = NULL
bidata <- separate(bidata,2,into=c("word1","word2"),sep="_")
bidata <- bidata %>% group_by(word1) %>% slice_head()


tridata <- as.data.frame((topfeatures(trigram, n=100000)))
tridata$trigram <- rownames(tridata)
rownames(tridata) = NULL
tridata <- separate(tridata,2,into=c("word1","word2","word3"),sep="_")
tridata <- tridata %>% group_by(word1, word2) %>% slice_head()

quaddata <- as.data.frame((topfeatures(quadgram, n=100000)))
quaddata$quadgram <- rownames(quaddata)
rownames(quaddata) = NULL
quaddata <- separate(quaddata,2,into=c("word1","word2","word3","word4"),sep="_")
quaddata <- quaddata %>% group_by(word1, word2, word3) %>% slice_head()

saveRDS(bidata, "./app/bidatanew.rds")
saveRDS(tridata, "./app/tridatanew.rds")
saveRDS(quaddata,"./app/quaddatanew.rds")







