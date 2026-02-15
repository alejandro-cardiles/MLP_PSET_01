#=================================#
# Alejandro Cardiles
# 2026-02-12
#=================================#

# setup
rm(list = ls())
source("00_packages.R")


#================================#
# 01 import data
#================================#
data = import("01_data/import/pwt110.xlsx", sheet = 3)
data = data |> 
       filter(countrycode %in% c("ITA",  "DEU", "FRA", "ESP"))

#================================#
# 02 export variables
#================================#
export(data, "01_data/output/01_pwt.rds")

