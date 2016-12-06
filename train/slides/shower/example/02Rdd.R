Sys.setenv(SPARK_HOME="c:/spark1.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)
library(magrittr)

say <- function(x){ 
  y<-unlist(collect(x))
  print(y)
}

sc <- sparkR.init(master="local[2]",appName="SparkR-RDD")

#RDD
rdd <- SparkR:::parallelize(sc, c(1:3,3))
count(rdd)
length(rdd)
rddr0 <- SparkR:::reduce(rdd, "+") %>% print()


rddr1 <- rdd %>% SparkR:::map(function(x) { x<-as.numeric(x)
                                    x+1 })
say(rddr1)

rddr2 <- rdd %>% SparkR:::filterRDD(function (x) { x != 1 })
say(rddr2)

rddr3 <- rdd %>% distinct()
say(rddr3)

rdd1 <- SparkR:::parallelize(sc, 1:3)
rdd2 <- SparkR:::parallelize(sc, 3:5)
rddr4 <- SparkR:::unionRDD(rdd1, rdd2)
say(rddr4)

rddr5 <- SparkR:::intersection(rdd1, rdd2)
say(rddr5)

rddr6 <- SparkR:::subtract(rdd1, rdd2)
say(rddr6)

rddr7 <- SparkR:::cartesian(rdd1, rdd2)
say(rddr7)

#pairRDD
prdd <- SparkR:::parallelize(sc, list(c("a", 1), c("b", 2), c("a", 3)))
prddr0 <- SparkR:::lookup(prdd,"a") %>% unlist() %>% print()
prddr1 <- SparkR:::countByKey(prdd) %>% print()

prdd1 <- SparkR:::parallelize(sc, list(list(1, 2), list(3, 4)))
say(prdd1)
SparkR:::keys(rdd) %>% collect %>% print()
SparkR:::values(rdd) %>% collect %>% print()

sparkR.stop()