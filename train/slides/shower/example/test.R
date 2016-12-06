library(dplyr)
words<-c('a','a','a','b','b','c')

ws<-lapply(words, function(word) { list(word, 1) })

df<-as.data.frame(ws)
print(df)
#wd<-ws %>% groupBy
