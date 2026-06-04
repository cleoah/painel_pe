process_ehf_data <- function(temporal) {
 # Initial processing
 processed <- temporal %>%
  rename(Data = dia) %>%
  group_by(Data, municipio) %>%
  filter(year(Data) > 1980)
 
 # Function to calculate EHF metrics for a single municipio
 calculate_ehf <- function(df) {
  df %>%
   mutate(
    Year = year(Data),
    # 3-day rolling mean minus 95th percentile (1981-2010 baseline)
    ehi_sig = rollmean(temp, 3, fill = NA, align = "right", na.rm = TRUE) -
     quantile(temp[Year > 1980 & Year < 2011], 0.95, na.rm = TRUE),
    # 30-day acclimatization adjustment
    avg_last_30 = mean(tail(temp, 30), na.rm = TRUE),
    ehf_accl = rollmean(temp, 3, fill = NA, align = "right", na.rm = TRUE) - avg_last_30,
    # Calculate EHF
    ehf = ehi_sig * pmax(1, ehf_accl)
   ) %>%
   select(-avg_last_30)
 }
 
 # Process all municipios
 results <- processed %>%
  group_by(municipio) %>%
  group_modify(~ calculate_ehf(.x)) %>%
  ungroup()
 
 # Categorize EHF values
 ehf_85 <- quantile(results$ehf[results$ehf > 0], 0.85, na.rm = TRUE)
 
 results %>%
  mutate(
   ehf_cat = case_when(
    ehf < 0 ~ "Sem Excesso de Calor",
    between(ehf, 0, ehf_85) ~ "Excesso de Calor Leve",
    between(ehf, ehf_85, 3 * ehf_85) ~ "Excesso de Calor severo",
    ehf > 3 * ehf_85 ~ "Excesso de Calor extremo",
    TRUE ~ "Undefined"
   ),
   ehf_cat = factor(ehf_cat, levels = c(
    "Sem Excesso de Calor",
    "Excesso de Calor Leve",
    "Excesso de Calor severo",
    "Excesso de Calor extremo",
    "Undefined"
   ))
  ) %>%
  na.omit()
}