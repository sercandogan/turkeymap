# migration.R
# Migration stats in Turkey
# mapping with ggplot


# LOAD DATA -------------------------------------------------
source("map.R")
mig <- read_csv("migration/clean_migration.csv")


mig$aldigi_sehir <- tr_to_en(mig$aldigi_sehir) 
mig$sehir <- tr_to_en(mig$sehir)


summ_mig_2016 <- mig %>%
  filter(yil == 2015) %>%
  group_by(sehir) %>%
  summarise(n = sum(sayi))

# BAR PLOT -------------------------------------------

summ_mig_2016 %>%
  filter(sehir != "Istanbul") %>% 
  ggplot(aes(x = sehir, y = n)) +
  geom_bar(stat = "identity") +
  coord_flip()

# TURKEY MAP -----------------------------------------

id_and_cities <- data_frame(id = rownames(TUR@data),
                            sehir = TUR@data$NAME_1) %>% 
  left_join(summ_mig_2016, by = "sehir")


# matrix notation of SpatialPolygonsDataFrame
TUR_mat <- fortify(TUR)


final_map <- left_join(TUR_mat, id_and_cities, by = "id")

ggplot(final_map) +
  geom_polygon( aes(x = long, y = lat, group = group, fill = n),
                color = "grey") +
  coord_map() +
  theme_void() + 
  labs(title = "2015 Yılındaki Şehirlerin Aldığı Göç Sayısı",
       caption = "Kaynak: Türkiye İstatistik Kurumu") +
  scale_fill_distiller(name = "Göç Sayısı",
                       palette = "Spectral", limits = c(0,100000), na.value = "red") +
  theme(plot.title = element_text(hjust = 0.5))



# Migrations to Istanbul -------------------------------------------------

mig_ist_2016 <- mig %>%
  filter(yil == 2016, sehir == "Istanbul") %>%
  select(-c(yil,sehir))


id_and_cities_ist <- data_frame(id = rownames(TUR@data),
                            aldigi_sehir = TUR@data$NAME_1) %>% 
  left_join(mig_ist_2016, by = "aldigi_sehir")


final_ist_map <- left_join(TUR_mat, id_and_cities_ist, by = "id")

# Sum of migrations
sum(mig_ist_2016$sayi)


ggplot(final_ist_map) +
  geom_polygon( aes(x = long, y = lat, group = group, fill = sayi),
                color = "grey") +
  coord_map() +
  theme_void() + 
  labs(title = "2015 Yılındaki İstanbul'un Aldığı Göç Sayısı",
       subtitle = paste0("Toplam Sayı: ", sum(mig_ist_2016$sayi)),
       caption = "Kaynak: Türkiye İstatistik Kurumu") +
  scale_fill_distiller(name = "Göç Sayısı",
                       palette = "Spectral", limits = c(0,20000), na.value = "black") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))





