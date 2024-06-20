library(wordcloud2)
library(wordcloud)
library(dplyr)
library(tm)
library(showtext)

#insert your source file.
all_text <- read.delim("/Here/your/.txt")

#gsub() removes words/characters you do not want to be present in the word cloud.
cleaned_text <- gsub("b\\(words/characters you want to eliminate from the text)\\b", "", all_text)

df <- data.frame(cleaned_text)

corpus <- VCorpus(VectorSource(df))

corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)

funs <- list(stripWhitespace,
             removePunctuation,
             function(x) removeWords(x, stopwords("english")),
             content_transformer(tolower))
corpus <- tm_map(corpus, FUN = tm_reduce, tmFuns = funs)

#in n-grams(words(x), ) put the desired number of words for the n-grams.
ngram_token2 <-  function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse=" "), use.names=FALSE)
ngram_token1 <-  function(x) unlist(lapply(ngrams(words(x), 1), paste, collapse=" "), use.names=FALSE)

tdm2 <- TermDocumentMatrix(corpus, control = list(tokenize = ngram_token2))
tdm1 <- TermDocumentMatrix(corpus, control = list(ngram_token1))

#here the tokenized matrices are merged. If you created new ones, add them in c().
tdmdef <- c(tdm1, tdm2)
freq <- rowSums(as.matrix(tdmdef))

tdm_freq <- data.frame(term = names(freq), occurrences = freq)

#with filter() you can choose what words to insert in the word cloud, depending on their occurrences.
filtered_freq <- filter(tdm_freq, occurrences >= 1)

wordcloud2(data = filtered_freq, 
           size = 0.55, minSize = 8, color = "random-light", backgroundColor = "indigo",
           shuffle = FALSE, minRotation = -pi/20, maxRotation = -pi/4,
           rotateRatio = 0.8, ellipticity = , shape = 'circle', fontFamily = "Times New Roman", 
           fontWeight = "bold", widgetsize = )

wordcloud(words = filtered_freq$term, freq = filtered_freq$occurrences,
          min.freq = 3, scale = c(3, 1), random.order = TRUE,
          colors = custom_palette1, max.words = 100,
          family = "Times New Roman")