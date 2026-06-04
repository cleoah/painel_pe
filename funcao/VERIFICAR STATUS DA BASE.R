verificar_status <- function(arquivo_base = "dados/brpedf.rda") {
 if (file.exists(arquivo_base)) {
  # Carregar temporariamente
  temp_env <- new.env()
  load(arquivo_base, envir = temp_env)
  
  if (exists("x", envir = temp_env)) {
   base <- get("x", envir = temp_env)
   
   if (is.data.frame(base) && "dia" %in% colnames(base)) {
    if (!inherits(base$dia, "Date")) {
     base$dia <- as.Date(base$dia)
    }
    
    message("\n📊 STATUS DA BASE:")
    message(paste("   Arquivo:", arquivo_base))
    message(paste("   Nome do objeto: x"))
    message(paste("   Período:", min(base$dia, na.rm = TRUE), "a", max(base$dia, na.rm = TRUE)))
    message(paste("   Total de registros:", nrow(base)))
    message(paste("   Última data:", max(base$dia, na.rm = TRUE)))
    message(paste("   Tamanho do arquivo:", round(file.size(arquivo_base) / 1024 / 1024, 2), "MB"))
    message(paste("   Colunas:", paste(colnames(base), collapse = ", ")))
   } else {
    message("Base carregada mas coluna 'dia' não encontrada")
    if (is.data.frame(base)) {
     message(paste("Colunas disponíveis:", paste(colnames(base), collapse = ", ")))
    }
   }
  } else {
   message("Objeto 'x' não encontrado no arquivo")
  }
 } else {
  message("Base não encontrada em:", arquivo_base)
 }
}