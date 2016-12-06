Sys.setenv(SPARK_HOME="c:/spark1.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))
library(SparkR)

sc <- sparkR.init(master="local[2]",appName="SparkR-DF")
sqlCtx <- sparkRSQL.init(sc)
localDF <- data.frame(name=c("John", "Smith", "Sarah"), age=c(19, 23, 18))
df <- createDataFrame(sqlCtx, localDF)

# Print its schema
printSchema(df)


# Create a DataFrame from a JSON file
path <- file.path(Sys.getenv("SPARK_HOME"), "examples/src/main/resources/people.json")
peopleDF <- read.json(sqlCtx, path)
#peopleDF <- read.df(sqlCtx, path, source = "json")
#peopleDF <- loadDF(sqlCtx, path, source = "json")
printSchema(peopleDF)

# Register this DataFrame as a table.
registerTempTable(peopleDF, "people")
teenagers <- sql(sqlCtx, "SELECT name FROM people WHERE age >= 13 AND age <= 19")
teenagersLocalDF <- collect(teenagers)
print(teenagersLocalDF)

# Stop the SparkContext now
sparkR.stop()
