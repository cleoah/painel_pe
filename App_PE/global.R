#1.BIBLIOTECA####
library(tidyverse)
library(bslib)
library(scales)
library(shinydashboard)
library(shiny)
library(sf)
library(geobr)
library(ggspatial)
library(rio)
library(leaflet)
library(leaflet.extras)
library(htmltools)       
library(leafem)
library(htmlwidgets)
library(plotly)

# # 2.DADOS DE TEMPERATURA 1980-2025####
# No global.R
final <- rio::import(list.files("dados", pattern = "final_.*\\.rda", full.names = TRUE)[1])

# Carregar dados do mapa
mapa <- readRDS(list.files("dados", pattern = "mapa_.*\\.rds", full.names = TRUE)[1])


custom_theme <- bs_theme(
 version = 5,
 "success" = "#22881F",    # Verde
 "warning" = "#F2BB38",    # Amarelo
 "orange" = "#EA591C",     # Laranja
 "danger" = "#B91A12",     # Vermelho
 "secondary" = "#6c757d"   # Cinza
)

