library(eurostat)
library(dplyr)

rm(list = ls())


pacman::p_load(giscoR)


# Download NUTS2 GDP
gdp_nuts2 <- get_eurostat("nama_10r_2gdp", time_format = "num") |>  clean_names()

# Keep Italy + constant prices
gdp_nuts2 <- gdp_nuts2 %>%
  filter(startsWith(geo, "IT"),
         unit %in% c("EUR_HAB_EU27_2020"))%>% 
  select(geo, time_period, values, unit)




sf = gisco_get_nuts(nuts_level = 2, country = "IT") 
