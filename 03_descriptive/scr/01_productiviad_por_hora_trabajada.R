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
data = import("01_data/output/01_pwt.rds", sheet = 3)

#================================#
# 02 plots
#================================#
plot = data |>
  mutate(prod_hour = rgdpo/(emp*avh), 
         country =  case_when(country == "France" ~ "Francia",
                              country == "Spain" ~ "España",
                              country == "Germany" ~ "Alemania", 
                              country == "Italy" ~ "Italia")) |>
  ggplot(aes(x = year, y = prod_hour, color = country)) +
  geom_line(linewidth = 1.2) +
  scale_y_continuous(labels = label_number(accuracy = 0.1)) +
  scale_x_continuous(breaks = seq(1950, 2025, by = 10)) +
  labs(
    title = "",
    x = "Año",
    y = "PIB por hora trabajada",
    caption = "**Notas:** Productividad laboral medida como PIB real en ppp (US$ 2021) por hora trabajada.<br> 
               **Fuente:** Penn World Table 11.0.",
    color = ""
  ) +
  theme_bw(base_size = 15) +
  theme(legend.position = "bottom",
        plot.caption.position = "plot",
        plot.caption = element_markdown(hjust = 0)) +
  scale_color_manual(values=c("Alemania" = alpha("#9e9e9e",0.5),  # Germany (neutral gray)
                              "España" = alpha("#0958acff",0.5),  # Spain (blue) 
                              "Francia" = alpha("#f28e2b",0.5),  # France (orange)
                              "Italia" = "#2ca02c"  # Italy 
                              ))
plot
#================================#
# 03 export
#================================#
ggsave(plot = plot, filename = "03_descriptive/output/01_productividad_por_trabajador.png", width = 267, height = 199, units  = "mm")

