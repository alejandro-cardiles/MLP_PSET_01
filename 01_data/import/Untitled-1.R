#==============================#
# Alejandro Cardiles 
#
#==============================#


# setup
rm(list = ls())
source("00_packages.R")

#=========================#
# Improt data
#=========================#
data = import("01_data/import/pwt110.xlsx", sheet = "Data")

data |> 
  filter(countrycode %in% c("ITA", "FRA", "GBR", "DEU")) |> 
  group_by(countrycode) |> 
  mutate(value = rgdpe / pop) |> 
  ggplot() + 
  geom_point(aes(x = year, y = value, color = countrycode))
