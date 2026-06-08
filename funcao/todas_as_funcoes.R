# ============================================================
# SCRIPT DE ATUALIZAÇÃO - VERSÃO SIMPLIFICADA E CORRIGIDA
# ============================================================

library(ecmwfr)
library(data.table)

# CONFIGURAÇÃO (SUBSTITUA SEU USER)
MEU_USER <- ""
pe_area <- c(-3, -44, -12, -30)

# ============================================================
# FUNÇÃO PRINCIPAL (TUDO EM UMA)
# ============================================================
atualizar_dados <- function(arquivo_base = "dados/brpedf.rda") {
 
 message("\n🚀 ATUALIZANDO BASE\n")
 
 # Carregar base existente
 if (!file.exists(arquivo_base)) {
  stop("Arquivo não encontrado!")
 }
 
 load(arquivo_base)
 if (!exists("x")) stop("Objeto 'x' não encontrado!")
 
 ultima_data <- max(x$dia, na.rm = TRUE)
 municipios <- unique(x$municipio)
 ultima_data_era5 <- Sys.Date() - 5  # Data máxima disponível
 
 message(paste("📅 Última data na base:", ultima_data))
 message(paste("📡 Última data disponível:", ultima_data_era5))
 
 if (ultima_data >= ultima_data_era5) {
  message("✅ Base já está atualizada!")
  return(x)
 }
 
 start_date <- ultima_data + 1
 end_date <- ultima_data_era5
 message(paste("📊 Baixando de", start_date, "até", end_date, 
               "-", as.numeric(end_date - start_date) + 1, "dias\n"))
 
 # Loop pelos meses
 current_date <- start_date
 
 while (current_date <= end_date) {
  
  ano <- as.numeric(format(current_date, "%Y"))
  mes <- as.numeric(format(current_date, "%m"))
  
  # Dias do mês
  primeiro_dia <- ifelse(current_date == start_date, 
                         as.numeric(format(start_date, "%d")), 1)
  
  ultimo_dia_mes <- as.numeric(format(
   as.Date(paste(ano, mes, "01", sep = "-")) + 32 - 
    as.numeric(format(as.Date(paste(ano, mes, "01", sep = "-")) + 32, "%d")), "%d"))
  
  ultimo_dia <- ifelse(
   as.Date(paste(ano, mes, ultimo_dia_mes, sep = "-")) <= end_date,
   ultimo_dia_mes,
   as.numeric(format(end_date, "%d"))
  )
  
  dias <- primeiro_dia:ultimo_dia
  
  message(paste("\n📥", ano, "-", sprintf("%02d", mes), 
                "- dias", primeiro_dia, "a", ultimo_dia))
  
  # Request ERA5
  request <- list(
   dataset_short_name = "reanalysis-era5-land",
   product_type = "reanalysis",
   variable = "2m_temperature",
   year = as.character(ano),
   month = sprintf("%02d", mes),
   day = as.character(dias),
   time = c("07:00", "08:00", "09:00", "17:00", "18:00"),
   area = pe_area,
   data_format = "netcdf",
   download_format = "unarchived"
  )
  
  # Download
  nc_file <- tryCatch({
   wf_request(request, user = MEU_USER, path = "dados_temp", time_out = 3600)
  }, error = function(e) {
   message(paste("❌", e$message))
   return(NULL)
  })
  
  if (!is.null(nc_file) && file.exists(nc_file)) {
   # Processar dados
   novos_dados <- process_era5_data(nc_file)
   
   # Garantir coluna 'dia'
   if (!"dia" %in% colnames(novos_dados)) {
    datas <- seq(as.Date(paste(ano, mes, min(dias), sep = "-")),
                 as.Date(paste(ano, mes, max(dias), sep = "-")), by = "day")
    novos_dados$dia <- rep(datas, each = length(municipios))
   }
   
   # Combinar e limpar duplicatas
   x <- rbind(x, novos_dados)
   x <- x[!duplicated(x[, c("dia", "municipio")]), ]
   x <- x[order(x$dia), ]
   
   # Salvar progresso
   save(x, file = arquivo_base)
   message(paste("💾 Salvo - Total:", nrow(x), "registros"))
   
   # Limpar
   file.remove(nc_file)
  }
  
  # CORREÇÃO: Avançar para próximo mês
  if (mes == 12) {
   current_date <- as.Date(paste(ano + 1, "01", "01", sep = "-"))
  } else {
   current_date <- as.Date(paste(ano, mes + 1, "01", sep = "-"))
  }
 }
 
 # Backup final
 backup_name <- paste0("dados/brpedf_backup_", format(Sys.Date(), "%Y%m%d"), ".rda")
 save(x, file = backup_name)
 
 message("\n✅ CONCLUÍDO!")
 message(paste("📅 Período:", min(x$dia), "a", max(x$dia)))
 message(paste("📊 Registros:", nrow(x)))
 
 return(x)
}



