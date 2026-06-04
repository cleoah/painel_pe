# # Função para fazer o download dos dados
# download_era5_data <- function(year) {
#  
#  # current_month <- format(Sys.Date(), "%m")
#  request <- list(
#   dataset_short_name = "reanalysis-era5-land",
#   product_type = "reanalysis",
#   variable = "2m_temperature",
#   year = as.character(year),
#   month = current_month,
#   day = as.character(1:31),
#   time = c("07:00","08:00","09:00","17:00", "18:00"),
#   area = pe_area,
#   data_format = "netcdf",
#   download_format = "unarchived"
#  )
#  
#  output_file <- wf_request(
#   request = request,
#   user = "91563859-801f-4a5b-982f-30fa99562d1f",
#   path = "dados",
#   time_out = 3600
#  )
#  
#  if(file.exists(output_file)) {
#   message(paste("Success: Downloaded", basename(output_file), "para", dirname(output_file)))
#   return(output_file)
#  } else {
#   warning("Download falhou - output file not found")
#   return(NULL)
#  }
# }


baixar_dados_era5 <- function(start_date, end_date, output_dir = "dados") {
 
 # Criar diretório temporário
 if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
 }
 
 downloaded_data <- list()
 current_date <- start_date
 index <- 1
 
 while (current_date <= end_date) {
  year <- format(current_date, "%Y")
  month <- format(current_date, "%m")
  
  # Determinar primeiro dia do período
  first_day <- ifelse(current_date == start_date, 
                      as.numeric(format(start_date, "%d")), 
                      1)
  
  # Último dia do mês
  last_day_of_month <- as.numeric(format(
   as.Date(paste(year, month, "01", sep = "-")) + 32 - 
    as.numeric(format(as.Date(paste(year, month, "01", sep = "-")) + 32, "%d")),
   "%d"))
  
  last_day <- ifelse(
   as.Date(paste(year, month, last_day_of_month, sep = "-")) <= end_date,
   last_day_of_month,
   as.numeric(format(end_date, "%d"))
  )
  
  days <- first_day:last_day
  
  message(paste("\n📥 Baixando:", year, "-", month, "- dias", first_day, "a", last_day))
  
  # Request corrigido (sem 'format' deprecated)
  request <- list(
   dataset_short_name = "reanalysis-era5-land",
   product_type = "reanalysis",
   variable = "2m_temperature",
   year = as.character(year),
   month = sprintf("%02d", as.numeric(month)),
   day = as.character(days),
   time = c("07:00", "08:00", "09:00", "17:00", "18:00"),
   area = pe_area,
   data_format = "netcdf",  # ← APENAS data_format
   download_format = "unarchived"
  )
  
  output_file <- tryCatch({
   wf_request(
    request = request,
    user = "91563859-801f-4a5b-982f-30fa99562d1f",  # ← SUBSTITUA PELO SEU USER
    path = output_dir,
    time_out = 3600
   )
  }, error = function(e) {
   message(paste("❌ Erro no download:", e$message))
   return(NULL)
  })
  
  if (!is.null(output_file) && file.exists(output_file)) {
   # Processar o arquivo baixado usando sua função
   dados_mes <- process_era5_data(output_file)  # Sua função existente
   
   # Garantir que a coluna de data se chama 'dia'
   if (!"dia" %in% colnames(dados_mes)) {
    # Se sua função retorna com outro nome, renomeia
    if ("date" %in% colnames(dados_mes)) {
     colnames(dados_mes)[colnames(dados_mes) == "date"] <- "dia"
    } else {
     # Criar coluna dia baseada no ano/mês/dia
     dados_mes$dia <- as.Date(paste(year, month, days[1], sep = "-"))
    }
   }
   
   # Garantir que 'dia' é do tipo Date
   dados_mes$dia <- as.Date(dados_mes$dia)
   
   downloaded_data[[paste(year, month, sep = "-")]] <- dados_mes
   message(paste("✅ Download concluído:", basename(output_file)))
   message(paste("   Registros neste lote:", nrow(dados_mes)))
   
   # Limpar arquivo NetCDF para economizar espaço
   file.remove(output_file)
   index <- index + 1
  } else {
   message(paste("⚠️  Falha no download para", year, month))
  }
  
  # Avançar para próximo mês
  if (month == "12") {
   current_date <- as.Date(paste(as.numeric(year) + 1, "01", "01", sep = "-"))
  } else {
   current_date <- as.Date(paste(year, as.numeric(month) + 1, "01", sep = "-"))
  }
 }
 
 # Combinar todos os dados baixados
 if (length(downloaded_data) > 0) {
  dados_novos <- do.call(rbind, downloaded_data)
  # Ordenar por data
  dados_novos <- dados_novos[order(dados_novos$dia), ]
  return(dados_novos)
 } else {
  return(NULL)
 }
}