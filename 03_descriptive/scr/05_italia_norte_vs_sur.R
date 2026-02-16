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
          investment = sum(capital, na.rm = TRUE) / sum(total_emp, na.rm = TRUE),
          mean_hours_worked = sum(total_hours_worked, na.rm = TRUE) / sum(total_emp, na.rm = TRUE),
          tech = gdp_hour/((mean_hours_worked)^0.35), 
          .groups = "drop"
          ) |>
          pivot_longer(cols = c(gdp_hour, investment, mean_hours_worked, tech),
                         names_to = "type",
                         values_to = "value") |>
          pivot_wider(names_from = country, values_from = value) |>
          mutate(ratio = `Italia Sur` / `Italia Norte`, 
                 type = case_when(type == "gdp_hour" ~ "Producción por hora",
                                  type == "investment" ~ "Inversion", 
                                  type == "mean_hours_worked" ~ "Horas promedio trabajadas", 
                                  type == "tech" ~ "Tecnologia"))


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
    caption = "**Notas:** El gráfico muestra el cociente Italia Sur / Italia Norte. <br>
             La productividad laboral se mide como PIB en PPS (EU27_2020) dividido por horas trabajadas. <br>
             La inversión corresponde a formación bruta de capital fijo por trabajador. <br>
             Las horas promedio trabajadas se calculan como horas totales sobre empleo total.<br>
             La tecnología se define como A = (PIB por hora) / (horas promedio trabajadas^{alpha}) <br>
             **Fuente:** Eurostat (Cuentas Regionales, NUTS2).",
    color = ""
  ) +
  theme_bw(base_size = 15) +
  theme(legend.position = "bottom",
        plot.caption.position = "plot",
        plot.caption = element_markdown(hjust = 0)) +
  scale_color_manual(values=c("#9e9e9e",  
                              "#0958acff", 
                              "#f28e2b",
                              "#2ca02c" 
                              ))

plot
#================================#
# 03 plot
#================================#
ggsave(plot = plot, "03_descriptive/output/05_italia_norte_vs_sur.png", width = 267, height = 199, units  = "mm")