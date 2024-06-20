# Combined n-gram word cloud
This R code, wrote with great pain and laughter in one night, allows the user to plot word clouds from any text file.
In particular, you can create combined word clouds, meaning that it's possible to display various combinations of n-grams in the same graph.

## How to add and merge n-grams in the same word cloud:
N-grams are created with the function:

"ngram_token <-  function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse=" "), use.names=FALSE)"

you can specify the number of words per token changing the value in:

"ngrams(words(x), 'n of words you want')"

A new matrix must then be created with:

"tdm2 <- TermDocumentMatrix(corpus, control = list(tokenize = 'name of the ngram_token function you created'))"

You can create a tokenizer function and the corresponding matrix per n-gram you want to display.

Finally, the matrices have to be merged to be a source of data for the word cloud:

"tdmdef <- c(tdm1, tdm2, 'any new matrix you created')"

## R Packages needed
wordcloud2, wordcloud, dplyr, tm, showtext.
