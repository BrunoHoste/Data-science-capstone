suppressPackageStartupMessages({
        library(dplyr)
        library(quanteda)
        library(tokenizers)
        library(stringr)
        library(textclean)
        library(lexicon)
})

bidata <- readRDS("bidatanew.rds")
tridata  <- readRDS("tridatanew.rds")
quaddata <- readRDS("quaddatanew.rds")


predfunct <- function(input){
        input <- tolower(input)
        input <- replace_contraction(input,contraction.key = lexicon::key_contractions,
                                        ignore.case = TRUE) 
        input <- replace_internet_slang(input, slang = paste0("\\b",lexicon::hash_internet_slang[[1]], "\\b"),
                                           replacement = lexicon::hash_internet_slang[[2]], ignore.case = TRUE)
        input <- str_replace_all(input,"[^a-zA-Z\\s]", " ")
        words <- unlist(strsplit(input, " "))
        num <- length(words)
        wordC <- words[num]
        wordB <- words[num-1]
        wordA <- words[num-2]
   
        
        if (num > 2) {
             selec3 <- filter(quaddata,word1 == wordA, word2 == wordB, word3 == wordC)
             selec2 <- filter(tridata,word1 == wordB, word2 == wordC)
             selec1 <- filter (bidata, word1 == wordC) 
                result <- head(selec3$word4,1)
                if (length(result) == 0)
                        result <- head(selec2$word3,1)
                if (length(result) == 0)
                        result <- head(selec1$word2,1)
                if (length(result) == 0)
                        result <- "and"
        }
        if (num == 2) {
                selec2 <- filter(tridata,word1 == wordB, word2 == wordC)
                selec1 <- filter (bidata, word1 == wordC) 
                result <- head(selec2$word3,1)
                        if (length(result) == 0)
                        result <- head(selec1$word2,1)
                        if (length(result) == 0)
                        result <- "and"
        }
        if (num == 1){
                selec1 <- filter (bidata, word1 == wordC) 
                result <- head(selec1$word2,1)
                        if (length(result) == 0)
                        result <- "and"
        }
print(result)
        }