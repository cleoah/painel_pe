obter_dados_municipio <- function(lon, lat, cod_ibge, nome_municipio) {
 tryCatch({
  # Parâmetros com datas dinâmicas
  params <- list(
   latitude = lat,
   longitude = lon,
   hourly = "temperature_2m",
   start_date = format(dia + 1, "%Y-%m-%d"),  # 5 dias na frente
   end_date = format(Sys.Date() + 5 , "%Y-%m-%d"), # 4 dias na frente
   timezone = "America/Sao_Paulo"
  )
  
  response <- GET("https://api.open-meteo.com/v1/forecast",
                  query = params,
                  timeout(30))
  
  if(status_code(response) == 200) {
   content <- content(response, "text")
   data <- fromJSON(content)
   
   # Converter datas - MÉTODO QUE FUNCIONA
   datas <- as.POSIXct(data$hourly$time, format = "%Y-%m-%dT%H:%M", tz = "UTC") %>%
    with_tz("America/Sao_Paulo")
   
   data.frame(
    cod_ibge = cod_ibge,
    municipio = nome_municipio,
    data_hora = datas,
    temperatura = data$hourly$temperature_2m,
    stringsAsFactors = FALSE
   )
  } else {
   message(sprintf("Erro em %s: Código %d", nome_municipio, status_code(response)))
   NULL
  }
 }, error = function(e) {
  message(sprintf("Falha em %s: %s", nome_municipio, e$message))
  NULL
 })
}
