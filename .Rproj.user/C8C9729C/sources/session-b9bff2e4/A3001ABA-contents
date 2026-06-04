#1.BIBLIOTECA####
library(dplyr)
library(data.table)
library(rio)
library(glue)
library(rlang)
library(zoo)
library(scales)
library(jsonlite)
library(ecmwfr)
library(httr)
library(ncdf4)
library(sf)
library(lubridate)
library(geobr)
library(RNetCDF)
library(purrr)
## ler as funções na pasta funcao
purrr::walk(list.files("funcao", full.names = TRUE), source)

# # 2.DADOS DE TEMPERATURA 1980-2025####
# Listar o que tem dentro do arquivo .rda


#3.DADOS ERA5-LAND####

# Executar atualização
resultado <- atualizar_dados("dados/brpedf.rda")


era5_brdwgd<-resultado %>%
dplyr::mutate(municipio=toupper(municipio)) 

rio::export(era5_combined,"dados/brpedf.rda")

#4.DADOS DE PREVISÃO####

#ONDE FAZER A API:https://open-meteo.com/en/docs/ecmwf-api

## 1. Obter a ultima data da base anterior-----------------------------------

dia<-max(era5_brdwgd$dia)

## 2. Obter coordenadas dos municípios de PE -----------------------------------
municipios_pe <- geobr::read_municipality(code_muni = "PE", year = 2020) %>%
 sf::st_centroid() %>%
 dplyr::mutate(lon = sf::st_coordinates(.)[, 1],
               lat = sf::st_coordinates(.)[, 2]) %>%
 as.data.frame() %>%
 dplyr::select(code_muni, name_muni, lon, lat)



## 4.Função principal corrigida para obter dados e Processar municípios  ----------------------------

dados_pe <- lapply(1:nrow(municipios_pe), function(i) {
 obter_dados_municipio(
  lon = municipios_pe$lon[i],
  lat = municipios_pe$lat[i],
  cod_ibge = municipios_pe$code_muni[i],
  nome_municipio = municipios_pe$name_muni[i]
 )
}) %>% dplyr::bind_rows()



dados_agregados <- dados_pe %>%
 dplyr::mutate(dia = as.Date(data_hora)) %>%
 dplyr::group_by(municipio, dia) %>%
 dplyr::summarise(
  temp_max = max(temperatura, na.rm = TRUE),
  temp_min = min(temperatura, na.rm = TRUE),
  temp = (temp_max + temp_min) / 2,
  .groups = 'drop'  # Remove o agrupamento após o summarise
 ) %>%
 dplyr::mutate(across(starts_with("temp"), ~ round(., 0))) %>%
 dplyr::mutate(municipio=toupper(municipio))

max(dados_agregados$dia)

temporal<-merge(dados_agregados,era5_brdwgd,by=c("municipio","dia","temp","temp_max","temp_min"), all = T)


# ───────────────────────────────────────────────
# 5. EHF- CALCULO ####
# ───────────────────────────────────────────────



# Process the data
final_data <- process_ehf_data(temporal)

# 5.1 resultado final dos calculos####

final<- final_data %>%
 dplyr::filter(year(Data)>=2023) %>%
 dplyr::mutate(Data = as.Date(Data))


# 1. Simplificar geometrias (reduz tamanho em 90%)
mun <- read_sf("dados/PE_Municipios_2024.shp") %>% 
sf::st_simplify(preserveTopology = TRUE, dTolerance = 0.01) %>%  
dplyr::mutate(NM_MUN = toupper(NM_MUN))

ufs <- read_sf("dados/PE_UF_2024.shp") %>% 
 sf::st_simplify(preserveTopology = TRUE, dTolerance = 0.05)

# 2. Salvar em formato otimizado
# saveRDS(mun, "App_PE/dados/mun_simplified.rds", compress = "xz")
# saveRDS(ufs, "App_PE/dados/ufs_simplified.rds", compress = "xz")


ehf<-final %>% 
 dplyr::filter(Data>=max(final$Data)-5 & Data<=max(final$Data)) %>% 
 dplyr::mutate(Data_label= format(Data, "%d/%m/%Y"),
        # Cria um fator ordenado pelas datas originais (não invertidas)
        Data_label = factor(Data_label, levels = format(sort(unique(Data)), "%d/%m/%Y"))) 

# 2. Junção ESPACIAL segura
mapa <- ehf %>%
 # Junte com os dados municipais mantendo a geometria
dplyr::left_join(mun, by = c("municipio" = "NM_MUN")) %>%
 # Converta para sf explicitamente
 sf::st_as_sf() %>%
 # Garanta o CRS correto (WGS84)
 sf::st_set_crs(4326) %>%
 # Filtre apenas linhas com geometria válida
 dplyr::filter(!st_is_empty(geometry))


file.remove(list.files("App_PE/dados", pattern = "final_.*\\.rda", full.names = TRUE))
file.remove(list.files("App_PE/dados", pattern = "mapa_.*\\.rds", full.names = TRUE))


saveRDS(mapa, paste0("App_PE/dados/mapa_", Sys.Date(), ".rds"))
save(final, file = paste0("App_PE/dados/final_", Sys.Date(), ".rda"))
 
