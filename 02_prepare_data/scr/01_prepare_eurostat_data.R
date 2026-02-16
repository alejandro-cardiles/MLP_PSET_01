rm(list = ls())
source("00_packages.R")

#================================#
# 01 import data
#================================#
nuts = import("01_data/output/02_nuts.rds")
gpd = import("01_data/output/02_gpd.rds")
hours = import("01_data/output/02_hours.rds")
pee_working = import("01_data/output/02_personas_empleadas.rds")
pee = import("01_data/output/02_personas.rds")
inv = import("01_data/output/02_capital.rds")
deflactor = import("01_data/output/02_deflactor.rds")

#================================#
# 02 prepare data
#================================#

# prepare data
nuts = nuts |> 
       select(nuts_id, cntr_code, nuts_name, levl_code, geometry)

## select values in pps and eur
gpd = gpd |> 
     filter(unit %in% c("MIO_PPS_EU27_2020")) |>
     mutate(values = values*1e6) |> 
     pivot_wider(names_from = unit, values_from = values) |> 
     select(nuts_id = geo, year = time_period, gpd_pps_2020_values = MIO_PPS_EU27_2020) |> 
     right_join(x = nuts |> select(nuts_id, cntr_code))

## select total hours worked
hours = hours |> 
      mutate(values = values*1000) |> 
      filter(wstatus == "EMP" & nace_r2 == "TOTAL") |> 
     select(nuts_id = geo, year = time_period, total_hours_worked = values) |> 
     right_join(x = nuts |> select(nuts_id, cntr_code))

## select employes
pee_working = pee_working |> 
         filter(age == "Y15-74") |> 
         select(nuts_id = geo, year = time_period, sex, values) |>
         pivot_wider(values_from = values, names_from = sex) |> 
         rename(female_emp = F, male_emp = M, total_emp = T)|> 
         right_join(x = nuts |> select(nuts_id, cntr_code))

## select total amopunt of people
pee = pee |> 
      filter(age == "TOTAL")|> 
      select(nuts_id = geo, year = time_period, sex, values) |>
      pivot_wider(values_from = values, names_from = sex) |> 
      rename(female = F, male= M, total = T)|> 
      right_join(x = nuts |> select(nuts_id, cntr_code))
 
## select capital and convert to constant by deflactor
inv = inv |>       
      filter(sector == "S1", currency == "MIO_EUR", nace_r2 == "TOTAL") |> 
      select(nuts_id = geo, year = time_period, capital_eur = values) |>
      mutate(capital_eur = capital_eur*1e6) |> 
      mutate(cntr_code = str_extract(string = nuts_id, "[:alpha:]{2}")) 

deflactor = deflactor |> 
            clean_names() |> 
            filter(unit == "PD20_EUR" &  na_item == "P51G") |> 
            select(cntr_code = geo, year = time_period, deflactor = values) 

inv = left_join(inv, deflactor, by = c("cntr_code","year")) 

inv = inv |> 
      mutate(capital = capital_eur/deflactor) |> 
      select(nuts_id, year, capital)

# join
data = full_join(gpd, hours) |> 
       full_join(pee_working) |> 
       full_join(pee) |> 
       full_join(inv) |> 
       mutate(country =  case_when(str_detect(nuts_id, "IT") ~ "Italia",
                                   str_detect(nuts_id, "DE") ~ "Alemania",
                                   str_detect(nuts_id, "FR") ~ "Francia",
                                   str_detect(nuts_id, "ES") ~ "España"))

data = data |> 
       relocate(country, .after = cntr_code)

data = data |> 
       filter(year>=2000)
#================================#
# export
#================================#
export(data, "02_prepare_data/output/01_eurostat_data.rds")
export(nuts, "02_prepare_data/output/01_nuts_sf.rds")