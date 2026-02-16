if(require("pacman") == F){install.packages("pacman")}
pacman::p_load(tidyverse)


f1 = list.files("01_data/scr/", full.names = T)
f2 = list.files("02_prepare_data/scr/", full.names = T)
f3 = list.files("03_descriptive/scr/", full.names = T)

f = c(f1, f2, f3)

walk(.x = f, .f = function(x){
 source(x)

})