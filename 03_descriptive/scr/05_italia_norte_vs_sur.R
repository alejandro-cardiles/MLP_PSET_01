rm(list = ls())
source("00_packages.R")

#================================#
# 01 import data
#================================#
data = import("02_prepare_data/output/01_eurostat_data.rds")

#================================#
# 02 prepare data
#================================#

# calculando los ratios de gdp por hpra trabajada, investment, horas trabajadas 
levels = data |> 
          mutate(country = case_when(str_detect(nuts_id, "ITC|ITH") ~ "Italia Norte",
                                   str_detect(nuts_id, "IT") ~ "Italia Sur")) |>
          filter(!is.na(country)) |> 
          group_by(country, year) |> 
          summarise(
          gdp_hour = sum(gpd_pps_2020_values, na.rm = TRUE) / sum(total_hours_worked, na.rm = TRUE),
          investment = sum(capital_eur, na.rm = TRUE) / sum(gpd_eur, na.rm = TRUE),
          working_population = sum(total_emp, na.rm = TRUE) /sum(total, na.rm = TRUE),
          mean_hours_worked = sum(total_hours_worked, na.rm = TRUE) / sum(total_emp, na.rm = TRUE),
          .groups = "drop"
          ) |>
          pivot_longer(cols = c(gdp_hour, investment, working_population, mean_hours_worked),
                         names_to = "type",
                         values_to = "value") |>
          pivot_wider(names_from = country, values_from = value) |>
          mutate(ratio = `Italia Sur` / `Italia Norte`, 
                 type = case_when(type == "gdp_hour" ~ "Producción por hora",
                                  type == "investment" ~ "Inversion", 
                                  type == "mean_hours_worked" ~ "Horas promedio trabajadas",
                                  type == "working_population" ~ "Tasa de Ocupación"))


#================================#
# 03 plot
#================================#

plot = levels |> 
  ggplot(aes(x = year, y = ratio, color = type)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 1, linetype = "dashed") + 
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), breaks = seq(0.75, 1.05, by = 0.05)) +
  scale_x_continuous(breaks = seq(2000, 2025, by = 5)) +
  labs(
    title = "",
    x = "Año",
    y = "Brechas entre el Sur y el Norte",
    caption = "**Notas:** Productividad laboral medida como PIB real en ppp (US$ 2021) por hora trabajada.<br> 
               **Fuente:** Penn World Table 11.0.",
    color = ""
  ) +
  theme_bw(base_size = 15) +
  theme(legend.position = "bottom",
        plot.caption.position = "plot",
        plot.caption = element_markdown(hjust = 0)) +
  scale_color_manual(values=c("#9e9e9e",  # Germany (neutral gray)
                              "#0958acff",  # Spain (blue) 
                              "#f28e2b",  # France (orange)
                              "#2ca02c"  # Italy 
                              ))

#================================#
# 03 plot
#================================#
ggsave(plot = plot, "03_descriptive/output/05_italia_norte_vs_sur.png", width = 267, height = 199, units  = "mm")