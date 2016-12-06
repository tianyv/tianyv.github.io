Sys.setenv(SPARK_HOME="c:/spark1.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)
library(magrittr)

say <- function(x){ print(collect(x)) }

sc <- sparkR.init(master="local",appName="SparkR-DF")
sqlCtx <- sparkRSQL.init(sc)
df1 <- createDataFrame(sqlCtx, data.frame(d1=c(1, 2, 3, 3)))
df2 <- createDataFrame(sqlCtx, data.frame(d2=c(1, 2, 3)))


#out1 <- df1 %>% SparkR:::map(function(x) { x<-as.numeric(x)
#                                         x+1 })  %>% unlist
out1 <- SparkR:::lapply(df1,function(x) { x<-as.numeric(x)
                                          x+1 }) 
say(out1)   
out2 <- filter(df1,df1$d1 !=1)
say(out2) 
out3 <- df1 %>% distinct()
say(out3)
#out4 <- sample(df1)
#say(out4)
sparkR.stop()