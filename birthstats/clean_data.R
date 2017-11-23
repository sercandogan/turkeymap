source("map.R")


# LOAD DATA ----------------- 
birth <- read_csv("birthstats/dogumistatistikv1.csv")

# TIDY DATA ---------------------
birth <- birth %>%
  select(-starts_with("X")) %>%
  fill(cinsiyet) %>%
  fill(yil)
  
# SUMMARISE ------------------------
birth %>%
  group_by(cinsiyet,yil) %>%
  summarise(n = sum(sayi,na.rm = T))

birth %>% head()


# CLEAN --------------------------------------------
birth$cinsiyet <- gsub("Cinsiyet:", "", birth$cinsiyet)
birth$il <- gsub("(\\(+.+)","",birth$il)


lapply(birth, function(x) sum(length(which(is.na(x)))))

birth <- filter(birth, !is.na(birth$sayi) | !is.na(birth$il))

birth <- birth %>% 
  group_by(yil,cinsiyet,il) %>%
  summarise(n = sum(sayi, na.rm = T))


# Updating cities' names 

birth$il <- mgsub(turkish_letters,english_letters,birth$il)

write_csv(birth, "birthstats//clean_birth_stats.csv")






