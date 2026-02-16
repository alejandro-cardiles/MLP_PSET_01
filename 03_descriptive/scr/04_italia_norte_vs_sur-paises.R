rm(list = ls())
source("00_packages.R")

#================================#
# 01 import data
#================================#
data = import("02_prepare_data/output/01_eurostat_data.rds")

#================================#
# 02 prepare data
#================================#
plot = data |> 
     mutate(value = gpd_pps_2020_values/total_hours_worked, 
            country =  case_when(str_detect(nuts_id, "ITC|ITH") ~ "Italia Norte",
                                 str_detect(nuts_id, "IT") ~ "Italia Sur",
                                 str_detect(nuts_id, "DE") ~ "Alemania",
                                 str_detect(nuts_id, "FR") ~ "Francia",
                                 str_detect(nuts_id, "ES") ~ "España"))  |> 
     group_by(country, year) |> 
     summarise(value = mean(value, na.rm = T))


plot = ggplot(plot, aes(year, value, color = country)) +
  geom_line(linewidth = 1.2) +
  geom_vline(xintercept = c(2008, 2020), linetype = "dashed", linewidth = 0.4) +
  labs(
    title = "",
    x = "Año",
    y = "PIB por hora trabajada",
    caption = "**Notas:** Productividad laboral medida como PIB real en ppp (US$ 2021) por hora trabajada.<br> 
               **Fuente:** Penn World Table 11.0.",
    color = ""
  )+
  scale_y_continuous(labels = label_number(accuracy = 0.1)) +
  theme_bw(base_size = 14) +
  theme(
    legend.position = "bottom",
    plot.caption.position = "plot",
    plot.caption = element_markdown(hjust = 0),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
  ) +
  scale_color_manual(values = c("Alemania" = alpha("#9e9e9e",0.5),  # Germany (neutral gray)
                                "España" = alpha("#0958acff",0.3),  # Spain (blue) 
                                "Francia" = alpha("#f28e2b",0.3),  # France (orange)
                                "Italia Norte" = "#2ca02c",  # Italy North (green)
                                "Italia Sur" = "#d62728") )
plot

# diff 2019 it norte and al: 1.079692
# diff 2019 it norte and fr: 1.017451

# diff 2019 it sur and al: 1.346964
# diff 2019 it sur and fr: 1.269316


#=================#
# Export
#=================#
ggsave(plot = plot, "03_descriptive/output/04_italia_norte_vs_sur-paises.png", width = 267, height = 199, units  = "mm")