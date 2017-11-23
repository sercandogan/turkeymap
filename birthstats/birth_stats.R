# Birth Stats in Turkey Map with ggplot
# 20/10/2017

# LOAD PACKAGES --------------------------
source("map.R")

# LOAD DATA ------------------------------
birthdata <- read_csv("birthstats/clean_birth_stats.csv")

birthdata_2016 <- birthdata %>%
  filter(yil == 2016) %>%
  group_by(il) %>%
  summarise(n = sum(n))


numbers_and_cities <- data_frame(id = rownames(TUR@data),
                                il = TUR@data$NAME_1) %>% 
  left_join(birthdata_2016, by = "il")



TUR_fixed <- fortify(TUR)


final_map <- left_join(TUR_fixed, numbers_and_cities, by = "id")

ggplot(final_map) +
  geom_polygon( aes(x = long, y = lat, group = group, fill = n),
                color = "grey") +
  coord_map() +
  theme_void() + 
  labs(title = "2016 Yılındaki Doğum İstatistikleri") +
  scale_fill_distiller(name = "Doğum Sayısı",
                       palette = "Spectral", limits = c(0,100000), na.value = "red") +
  theme(plot.title = element_text(hjust = 0.5))
















