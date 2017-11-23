library(tidyverse)

# LOAD DATA ---------------------------------------------------------
mig <- read_csv("migration/migration.csv")

# CLEAN DATA ---------------------------------------------------------
mig$aldigi_sehir <- gsub("(-+.+)","",mig$aldigi_sehir)
mig$sehir <- gsub("Göç Alan:","",mig$sehir)

mig <- mig %>%
  fill(yil) %>%
  fill(aldigi_sehir)

mig <- mig %>%
  filter(sehir != aldigi_sehir)

write_csv(mig,"migration/clean_migration.csv")


