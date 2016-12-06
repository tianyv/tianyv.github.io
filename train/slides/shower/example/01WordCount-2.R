Sys.setenv(SPARK_HOME="c:/spark1.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)
library(magrittr)


sc <- sparkR.init(master="local[2]",appName="WordCount")
sqlCtx <- sparkRSQL.init(sc)
localDF <- data.frame(w=c("a", "a", "a", "b", "b", "c"))
df<-createDataFrame(sqlCtx, localDF)
#print(collect(df))
wordcount<- df %>% group_by(df$w) %>% summarize(count = n(df$w)) %>% collect()

print(wordcount)