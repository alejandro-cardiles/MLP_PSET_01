#=================================#
# Alejandro Cardiles
# 2026-02-12
#=================================#

# setup
rm(list = ls())
source("00_packages.R")

#=================================#
# mover archivo 
#=================================#
files = list.files("03_descriptive/output/", full.names = T, recursive = T)
for(i in files){
  print(i)
  file.copy(from = i, to = str_replace(i, pattern = "03_descriptive/output/", "99_document/figures/"), overwrite = T)
}
