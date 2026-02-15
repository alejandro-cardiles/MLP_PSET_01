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
  filter(year>1960) |> 
  mutate(prod_hour = rgdpo/(emp*avh)) |> 
  select(year, country, prod_hour) |> 
  pivot_wider(names_from = country, values_from = prod_hour) |> 
  mutate(France = France/Italy, 
         Spain = Spain/Italy, 
         Germany = Germany/Italy) |> 
  pivot_longer(cols = c(France, Spain, Germany), 
               names_to = "country", 
               values_to = "prod_hour") |> 
  mutate(country =  case_when(country == "France" ~ "Francia",
                              country == "Spain" ~ "España",
                              country == "Germany" ~ "Alemania")) |>
  ggplot(aes(x = year, y = prod_hour, color = country)) +
  geom_line(linewidth = 1.2) + 
  geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(breaks = seq(1950, 2025, by = 10)) +
  labs(
    title = "",
    x = "Año",
    y = "Prudctividad con respecto a Italia\n(Italia = 100%)",
    caption = 
"**Notas:** Productividad laboral medida como PIB real en ppp (US$ 2021) por hora trabajada.<br>
**Fuente:** Penn World Table 11.0.",
    color = "") +
  theme_bw(base_size = 15) +
  theme(legend.position = "bottom",
        plot.caption.position = "plot",
        plot.caption = element_markdown(hjust = 0)) +
  scale_color_manual(values=c("#0072B2", "#E69F00", "#009E73"))
plot
#================================#
# 03 export
#================================#
ggsave(plot = plot, filename = "03_descriptive/output/02_productividad_entorno_italia.png", width = 267, height = 199, units  = "mm")
