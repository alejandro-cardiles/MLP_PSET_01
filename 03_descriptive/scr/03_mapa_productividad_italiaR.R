rm(list = ls())
source("00_packages.R")

#================================#
# 01 import data
#================================#
data = import("02_prepare_data/output/01_eurostat_data.rds")
geo = import("02_prepare_data/output/01_nuts_sf.rds")

#================================#
# 02 prepare data
#================================#
plot = left_join(x = data |> filter(year == 2019),
              y = geo) |> 
     filter(cntr_code == "IT") |> 
     mutate(value = gpd_pps_2020_values/total_hours_worked, 
            group = as.factor(ntile(value, 4)))   |> 
     st_as_sf()


#================================#
# 03 plot
#================================#

tmap_mode("plot")

mapa = tm_shape(plot) +
  tm_basemap("CartoDB.Positron") +
  tm_polygons(
    col = "group",
    palette = "-RdBu",     # diverging
    alpha = 0.75,
    border.col = "grey25",
    lwd = 0.6,
    textNA = "",
    title = "Cuartiles\nde productividad\nlaboral"
  ) +
  tm_graticules(
    lines = FALSE,         # remove grid lines
    labels.size = 0.8,
    col = "grey40"
  ) +
  tm_text(
    text = "nuts_id",      # column with NUTS code
    size = 0.8,
    col = "black"
  ) +
  tm_layout(
    frame = T,
    legend.outside = TRUE,                     # KEY FIX
    legend.is.portrait = FALSE,
    legend.outside.position = "bottom",         # put outside right
    legend.bg.color = "white",
    legend.bg.alpha = 0.9,
    legend.frame = FALSE,
    legend.title.size = 1.2,
    legend.text.size = 1,
    legend.position = c("right", "center"),
    outer.margins = c(0.02, 0.15, 0.02, 0.02) 
  ) +
  tm_compass(type = "arrow", position = c("right", "top")) +
  tm_scale_bar(position = c("left", "bottom"))

#================================#
# 04 export
#================================#
tmap_save(mapa, 
          filename = "03_descriptive/output/03_mapa_productividad_italia.png",
          width = 12, 
          height = 10, 
          units = "in", 
          dpi = 300)


