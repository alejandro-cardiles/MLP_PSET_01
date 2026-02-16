rm(list = ls())
source("00_packages.R")

#================================#
# 01 import data
#================================#
nuts = get_eurostat_geospatial(nuts_level = 2, year = 2021) |> 
       clean_names() |> 
       filter(substr(id, 1, 2) %in% c("FR", "DE", "ES", "IT"))

gpd = get_eurostat(id = "nama_10r_2gdp", time_format = "num") |> 
      clean_names() |> 
      filter(geo %in% nuts$id)

emp = get_eurostat(id = "lfst_r_lfe2emp", time_format = "num")  |> 
      clean_names() |> 
      filter(geo %in% nuts$id)

per = get_eurostat("demo_r_d2jan", time_format="num") |> 
      clean_names() |> 
      filter(geo %in% nuts$id)


hours = get_eurostat("nama_10r_2emhrw", time_format = "num") |> 
        clean_names() |> 
      filter(geo %in% nuts$id)

inv = get_eurostat("nama_10r_2gfcf", time_format="num") |>  
      clean_names() |> 
      filter(geo %in% nuts$id)

deflactor = get_eurostat(id = "nama_10_gdp", time_format = "num") |> 
       filter(substr(geo, 1, 2) %in% c("FR", "DE", "ES", "IT"))
            

#================================#
# 02 export data
#================================#
export(nuts, "01_data/output/02_nuts.rds")
export(gpd, "01_data/output/02_gpd.rds")
export(emp, "01_data/output/02_personas_empleadas.rds")
export(hours, "01_data/output/02_hours.rds")
export(per, "01_data/output/02_personas.rds")
export(inv, "01_data/output/02_capital.rds")
export(deflactor, "01_data/output/02_deflactor.rds")
