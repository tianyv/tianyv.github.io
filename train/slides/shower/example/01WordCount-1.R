Sys.setenv(SPARK_HOME="c:/spark1.6")
#Sys.setenv(PATH = paste(Sys.getenv(c('PATH')), file.path(Sys.getenv("SPARK_HOME"),"bin"), sep=':')) 

.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)

sc <- sparkR.init(master="local[2]",appName="WordCount")

#lines <- SparkR:::textFile(sc, 'f:/README.md')
lines <- SparkR:::textFile(sc, paste(getwd(), "/README.md", sep = ""))

words <- SparkR:::flatMap(lines,
                 function(line) {
                   strsplit(line, " ")[[1]]
                 })
wordCount <- SparkR:::lapply(words, function(word) { list(word, 1L) })

counts <- SparkR:::reduceByKey(wordCount, "+", 2L)
output <- collect(counts)
for (wordcount in output) {
  cat(wordcount[[1]], ": ", wordcount[[2]], "\n")
}
sparkR.stop()