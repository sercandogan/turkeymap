library(tidyverse)
library(sp)
library(RColorBrewer)

# Map of Turkey with ggplot
TUR <- readRDS("TUR_adm1.rds")




# Updating cities' names Turkish Characters to English Characters
tr_to_en <- function(datafile){
  turkish_letters <- c("Ç","Ş","Ğ","İ","Ü","Ö","ç","ş","ğ","ı","ü","ö")
  english_letters <- c("C","S","G","I","U","O","c","s","g","i","u","o")
  datafile <- mgsub(turkish_letters,english_letters,datafile)
  return(datafile)
}
  


# Multiple gsub function

mgsub <- function(pattern, replacement, x, ...) {
  n = length(pattern)
  if (n != length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result = x
  for (i in 1:n) {
    result <- gsub(pattern[i],replacement[i],result)
  }
  return(result)
}

TUR@data$NAME_1 <- tr_to_en(TUR@data$NAME_1)
TUR@data$NAME_1 <- gsub("K. Maras", "Kahramanmaras",TUR@data$NAME_1)
TUR@data$NAME_1 <- gsub("Kinkkale","Kirikkale",TUR@data$NAME_1)
TUR@data$NAME_1 <- gsub("Zinguldak", "Zonguldak", TUR@data$NAME_1)
TUR@data$NAME_1 <- gsub("Afyon","Afyonkarahisar", TUR@data$NAME_1)




