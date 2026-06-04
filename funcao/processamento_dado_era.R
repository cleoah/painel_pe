process_era5_data <- function(nc_file) {
 # Carregar pacotes necessários
 require(ncdf4)
 require(sf)
 require(data.table)
 require(dplyr)
 
 # 1. Carregar shapefile de municípios de PE
 pe_munic <- st_read("dados/PE_Municipios_2024.shp", quiet = TRUE) %>% 
  st_centroid() %>%
  mutate(
   lon = st_coordinates(.)[,1],
   lat = st_coordinates(.)[,2]
  ) %>% 
  st_drop_geometry()
 
 # 2. Ler dados do NetCDF
 nc <- nc_open(nc_file)
 lon <- ncvar_get(nc, "longitude")
 lat <- ncvar_get(nc, "latitude")
 time_values <- ncvar_get(nc, "valid_time")
 t2m <- ncvar_get(nc, "t2m")  # Temperatura em Kelvin
 nc_close(nc)
 
 # 3. Converter tempo para datas
 dates <- as.Date(as.POSIXct(time_values, origin = "1970-01-01", tz = "UTC"))
 
 # 4. Criar uma grade expandida para busca
 grid_points <- expand.grid(lon = lon, lat = lat)
 
 # 5. Função para encontrar o ponto mais próximo usando distância euclidiana
 find_nearest_grid_point <- function(mun_lon, mun_lat, grid_points) {
  distances <- sqrt((grid_points$lon - mun_lon)^2 + (grid_points$lat - mun_lat)^2)
  nearest_idx <- which.min(distances)
  return(list(lon_idx = which(lon == grid_points$lon[nearest_idx]),
              lat_idx = which(lat == grid_points$lat[nearest_idx])))
 }
 
 # 6. Para cada município, encontrar o ponto mais próximo e extrair dados
 result_list <- list()
 
 for(i in 1:nrow(pe_munic)) {
  nearest <- find_nearest_grid_point(pe_munic$lon[i], pe_munic$lat[i], grid_points)
  
  # Extrair série temporal para este ponto
  temp_series <- t2m[nearest$lon_idx, nearest$lat_idx, ] - 273.15  # K to °C
  
  result_list[[i]] <- data.table(
   municipio = pe_munic$NM_MUN[i],
   cod_munici = pe_munic$cod_munici[i],
   dia = dates,
   t = round(temp_series, 1)
  )
 }
 
 # 7. Combinar todos os resultados
 final_df <- rbindlist(result_list)
 
 # 8. Sumarizar por dia e município
 ERA5_bd <- final_df %>% 
  group_by(dia, municipio) %>% 
  summarise(
   temp_max = round(max(t), 1),
   temp_min = round(min(t), 1),
   temp = (temp_max + temp_min) / 2,
   .groups = 'drop'
  )
 
 return(ERA5_bd)
}