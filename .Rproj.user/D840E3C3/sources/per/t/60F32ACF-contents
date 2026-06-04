server <- function(input, output, session) {
 
 # Reactive filtered data
 filtered_data <- reactive({
  req(input$date_range, input$municipio)
  
  data <- final %>%
   filter(municipio == input$municipio,
          Data >= input$date_range[1], 
          Data <= input$date_range[2])
  
  # Debug: verifique os dados filtrados
  print(paste("Dados filtrados:", nrow(data), "registros"))
  if(nrow(data) > 0) print(paste("Datas disponíveis:", paste(unique(data$Data), collapse = ", ")))
  
  data %>%
   mutate(
    ehf_cat = factor(
     ehf_cat,
     levels = c("Sem Excesso de Calor",
                "Excesso de Calor Leve",
                "Excesso de Calor severo",
                "Excesso de Calor extremo"),
     exclude = NULL
    )
   )
 })
 
 # Dados filtrados para o mapa
 # No seu server.R
 # Função de cores robusta
 determine_color_box <- function(ehf_cat) {
  if(is.null(ehf_cat) || is.na(ehf_cat)) return("secondary")
  
  case_when(
   ehf_cat == "Sem Excesso de Calor" ~ "success",
   ehf_cat == "Excesso de Calor Leve" ~ "warning",
   ehf_cat == "Excesso de Calor severo" ~ "orange",
   ehf_cat == "Excesso de Calor extremo" ~ "danger",
   TRUE ~ "secondary"
  )
 }
 # 1. Defina as cores do tema (se ainda não tiver)
 cores_theme <- list(
  success = "#22881F",    # Verde
  warning = "#F2BB38",    # Amarelo
  orange = "#EA591C",     # Laranja  
  danger = "#B91A12",     # Vermelho
  secondary = "#6c757d"   # Cinza
 )
 
 # 2. Função vectorizada
 determine_color <- function(ehf_cat) {
  case_when(
   is.na(ehf_cat) ~ cores_theme$secondary,
   ehf_cat == "Sem Excesso de Calor" ~ cores_theme$success,
   ehf_cat == "Excesso de Calor Leve" ~ cores_theme$warning,
   ehf_cat == "Excesso de Calor severo" ~ cores_theme$orange,
   ehf_cat == "Excesso de Calor extremo" ~ cores_theme$danger,
   TRUE ~ cores_theme$secondary
  )
 }
 
 # 3. Dados filtrados para o mapa
 mapa_data <- reactive({
  req(input$data_mapa)
  
  dados <- readRDS(list.files("dados", pattern = "mapa_.*\\.rds", full.names = TRUE)[1]) %>%
   filter(Data_label == input$data_mapa) %>%
   mutate(
    ehf_cat = factor(
     ehf_cat,
     levels = c("Excesso de Calor extremo", 
                "Excesso de Calor severo",
                "Excesso de Calor Leve",
                "Sem Excesso de Calor"),
     ordered = TRUE
    ),
    fill_color = determine_color(ehf_cat)  # Agora funciona com vetores
   )
  
  return(dados)
 })
 
 # Nova função para pegar os últimos 6 dias do intervalo
 get_last_five_days <- function(data) {
  unique_dates <- unique(data$Data) %>% sort()
  if(length(unique_dates) >= 6) {
   tail(unique_dates, 6)
  } else {
   unique_dates
  }
 }
 
 render_custom_value_box <- function(day_index, last_dates) {
  renderUI({
   # Pega a data correspondente ao índice
   selected_date <- last_dates[day_index]
   
   # Filtra os dados para essa data
   day_data <- filtered_data() %>% filter(Data == selected_date)
   
   # Pega a primeira categoria (assumindo que todas são iguais para a mesma data)
   categoria <- unique(day_data$ehf_cat)[1]
   
   # Calcula os valores mínimo e máximo
   temp_max_value <- round(max(day_data$temp_max, na.rm = TRUE), 1)
   temp_min_value <- round(min(day_data$temp_min, na.rm = TRUE), 1)
   
   # Determina a cor com base na categoria
   color <- determine_color_box(categoria)
   
   # Formata a data no formato dia/mês
   formatted_date <- format(selected_date, "%d/%m")
   
   # Cria o value box
   bslib::value_box(
    title = tags$div(
     paste(formatted_date),
     style = "text-align: center; font-size: 3em; font-weight: bold; color: #f8f9fa;"
    ), 
    value = tags$div(
     style = "font-size: 3em; font-weight: bold; text-align: center; color: #f8f9fa;", 
     paste0("Máx: ", temp_max_value, "°C",
            " Mín: ", temp_min_value, "°C")
    ), 
    theme_color = color,
    tags$div(
     style = "text-align: center; font-size: 1.2em; margin-top: 10px; color: #f8f9fa;",
     categoria
    ),
    class = "h-100",
    fill = TRUE,
    height = 400
   )
  })
 }
 # Gerar value boxes dinamicamente com os últimos 5 dias
 observe({
  last_dates <- get_last_five_days(filtered_data())
  
  # Verifica se há datas suficientes
  if(length(last_dates) >= 1) output$valueBox7 <- render_custom_value_box(1, last_dates)
  if(length(last_dates) >= 2) output$valueBox6 <- render_custom_value_box(2, last_dates)
  if(length(last_dates) >= 3) output$valueBox5 <- render_custom_value_box(3, last_dates)
  if(length(last_dates) >= 4) output$valueBox4 <- render_custom_value_box(4, last_dates)
  if(length(last_dates) >= 5) output$valueBox3 <- render_custom_value_box(5, last_dates)
  if(length(last_dates) >= 6) output$valueBox2 <- render_custom_value_box(6, last_dates)
 })
 
 # Gráfico principal#####
 output$grafico <- renderPlotly({
  req(input$date_range, input$municipio)
  
  plot_data <- final %>%
   filter(municipio == input$municipio,
          Data >= input$date_range[1], 
          Data <= input$date_range[2]) %>%
   mutate(
    ehf_cat = factor(
     ehf_cat,
     levels = c("Sem Excesso de Calor",
                "Excesso de Calor Leve",
                "Excesso de Calor severo",
                "Excesso de Calor extremo"),
     exclude = NULL
    )
   )
  
  diff_dias <- as.numeric(difftime(input$date_range[2], input$date_range[1], units = "days"))
  breaks <- ifelse(diff_dias > 90, "1 month", "4 days")
  
  # Criar o ggplot original
  p <- ggplot(plot_data, aes(x = Data)) +
   geom_rect(
    aes(xmin = Data - 0.5, 
        xmax = Data + 0.5,
        ymin = 19, 
        ymax = 45,
        fill = ehf_cat,
        text = paste("Data:", format(Data, "%d/%m/%Y"),
                     "<br>Temperatura:", temp_max, "°C",
                     "<br>Categoria:", ehf_cat)),
    alpha = 0.8
   ) +
   geom_point(aes(y = temp_max, text = paste("Temp:", temp_max, "°C")), 
              color = "#080808", size = 1.5) +
   geom_line(aes(y = temp_max), color = "#080808", linewidth = 1) +
   scale_fill_manual(
    name = "Categoria de calor",
    values = c("Sem Excesso de Calor" = "#228920",
               "Excesso de Calor Leve" = "#f1c40f",
               "Excesso de Calor severo" = "#e67e22",
               "Excesso de Calor extremo" = "#BA1B10",
               "Undefined" = "gray"),
    drop = FALSE
   ) +
   labs(
    y = "Temperatura Máxima (°C)",
    x = "Data"
   ) +
   ylim(19, 45) +
   theme_minimal() +
   theme(
    legend.position = "none",
    axis.title.y = element_text(size = 15, face = "bold"),
    axis.title.x = element_text(size = 15, face = "bold"),
    axis.text.y = element_text(size = 15, face = "bold"),
    axis.text.x = element_text(size = 15, face = "bold")
   ) +
   scale_x_date(
    breaks = date_breaks(breaks), 
    labels = date_format("%d\n%m/%y"),
    limits = c(input$date_range[1], input$date_range[2])
   )
  
  # Converter para plotly mantendo o estilo
  ggplotly(p, tooltip = "text") %>%
   layout(
    hoverlabel = list(
     bgcolor = "white",
     font = list(size = 14, color = "black")
    ),
    xaxis = list(
     fixedrange = TRUE
    ),
    yaxis = list(
     fixedrange = TRUE
    )
   ) %>%
   config(displayModeBar = FALSE) # Remove a barra de ferramentas padrão
 })
 # Gráfico do mapa####
 output$mapa <- renderLeaflet({
  req(mapa_data())
  
  # Carrega os dados espaciais
  mun <- readRDS("dados/mun_simplified.rds")
  ufs <- readRDS("dados/ufs_simplified.rds")
  

  
  # Cria o mapa com estilo cartográfico
  leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
   # Camada base - Estilo "Sete Mares"
   addProviderTiles(
    providers$Esri.OceanBasemap,
    options = providerTileOptions(
     variant = "Ocean/World_Ocean_Base"
    )
   ) %>%
   
   # Camada de relevo (opcional)
   addProviderTiles(
    providers$Esri.OceanBasemap,
    options = providerTileOptions(
     variant = "Ocean/World_Ocean_Reference"
    )
   ) %>%
   
   # Define a visualização inicial
   setView(lng = -37.4, lat = -8.5, zoom = 8) %>%
   
   # Grade do leafem (mais customizável)
   addGraticule(
    interval = 1,
    style = list(
     color = "rgba(100,100,100,1)",
     weight = 0.5,
     dashArray = "5,5"
    )
   ) %>%
   
   # Adiciona os municípios
   addPolygons(
    data = mun,
    fillColor = "transparent",
    color = "#af921e",  # Cor dourada vintage
    weight = 0.7,
    opacity = 0.8,
    fillOpacity = 0
   ) %>%
   
   # Adiciona os estados
   addPolygons(
    data = ufs,
    fillColor = "transparent",
    color = "#5c3c10",  # Cor marrom escuro
    weight = 2,
    opacity = 1,
    fillOpacity = 0
   ) %>%
   
   # Adiciona os dados principais
   addPolygons(
    data = mapa_data(),
    fillColor = ~fill_color,
    fillOpacity = input$opacidade_mapa,
    color = "#5c3c10",
    weight = 0.5,
    highlightOptions = highlightOptions(
     weight = 2,
     color = "#8b6914",
     fillOpacity = 0.7,
     bringToFront = TRUE
    ),
     label = ~paste(municipio, "Máx:",temp_max,"ºC",
                    "Mín:",temp_min,"ºC"),
    
    labelOptions = labelOptions(
     style = list(
      "font-weight" = "normal",
      "padding" = "28px",
      "border-radius" = "50px"
     ),
     textsize = "14px",
     direction = "auto"
    )
   ) %>%
  
   addControl(
    html = HTML('
    <div style="
      width: 80px;
      height: 80px;
      position: relative;
      border-radius: 50%;
      background-color: rgba(255, 255, 255, 0.8);
      box-shadow: 0 0 10px rgba(0,0,0,0.2);
    ">
      <!-- Seta Norte (▲) -->
      <div style="
        position: absolute;
        top: 15%;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 0;
        border-left: 8px solid transparent;
        border-right: 8px solid transparent;
        border-bottom: 16px solid #5c3c10;  /* Vermelho para Norte */
      "></div>
      
      <!-- Seta Sul (▼) -->
      <div style="
        position: absolute;
        bottom: 15%;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 0;
        border-left: 8px solid transparent;
        border-right: 8px solid transparent;
        border-top: 16px solid #5c3c10;  /* Verde para Sul */
      "></div>
      
      <!-- Marcadores Leste (L) e Oeste (O) -->
      <div style="position: absolute; top: 50%; left: 10%; color: #5c3c10; font-weight: bold; transform: translateY(-50%);">O</div>
      <div style="position: absolute; top: 50%; right: 10%; color: #5c3c10; font-weight: bold; transform: translateY(-50%);">L</div>
      
      <!-- Linha central (opcional) -->
      <div style="
        position: absolute;
        top: 50%;
        left: 50%;
        width: 60%;
        height: 2px;
        background: #5c3c10;
        transform: translate(-50%, -50%) rotate(90deg);
      "></div>
    </div>
  '),
    position = "topright"
   ) %>%
   
   # Adiciona escala estilizada (formato correto)
   addScaleBar(
    position = "bottomleft",
    options = scaleBarOptions(
     imperial = FALSE,
     metric = TRUE,
     updateWhenIdle = TRUE
    )
   ) %>%
   
   # Legenda estilizada
   addLegend(
    position = "bottomright",
    colors = unlist(cores_theme[c("danger", "orange", "warning", "success")]),
    labels = sprintf("<span style='font-size:20px'>%s</span>", 
                     c("Excesso extremo", "Excesso severo", "Excesso leve", "Sem excesso")),
    title = HTML("<span style='font-size:20px; font-weight:bold'>NÍVEL DE CALOR</span>"),
    opacity = 1,
    labFormat = labelFormat(transform = toupper)
   ) %>%
   
   # Adiciona nome do oceano com estilo vintage
   addControl(
    html = HTML('<div style="font-family: \'Times New Roman\', serif; font-size: 16px; color: #1a4a72; font-weight: bold; text-shadow: 1px 1px 1px white; background-color: rgba(255,255,255,0.5); padding: 3px 8px; border-radius: 3px;">Malha Municipial Político Administrativa - Pernambuco</div>'),
    position = "bottomleft"
   ) %>%
   
   # Adiciona borda decorativa (opcional)
   htmlwidgets::onRender(
    "function(el, x) {
        var map = this;
        map._container.style.border = '10px solid #dda22c';
        map._container.style.boxShadow = '0 0 20px rgba(0,0,0,0.3)';
      }"
   )
 })
  

 
 output$download_grafico <- downloadHandler(
  filename = function() {
   paste("mapas_excesso_calor_6dias_", Sys.Date(), ".png", sep = "")
  },
  content = function(file) {
   mun <- readRDS("dados/mun_simplified.rds")
   ufs <- readRDS("dados/ufs_simplified.rds")
   
   # 1. Primeiro precisamos carregar o arquivo completo com todos os dias
   dados_completos <- readRDS(list.files("dados", pattern = "mapa_.*\\.rds", full.names = TRUE)[1])
   
   # 2. Pegar os últimos 6 dias disponíveis (ou um intervalo específico)
   todas_datas <- sort(unique(dados_completos$Data_label), decreasing = TRUE)[1:6]
   
   # 3. Filtrar os dados para esses 6 dias
   dados_6dias <- dados_completos %>% 
    filter(Data_label %in% todas_datas) %>%
    mutate(
     ehf_cat = factor(
      ehf_cat,
      levels = c("Excesso de Calor extremo", 
                 "Excesso de Calor severo",
                 "Excesso de Calor Leve",
                 "Sem Excesso de Calor"),
      ordered = TRUE
     )
    )
   
   # 4. Criar o plot facetado
   p <- ggplot() +
    geom_sf(data = ufs, fill = "transparent", linewidth = 0.5, color = "black") +
    geom_sf(data = mun, fill = "transparent", color = "gray", alpha = 0.3, linewidth = 0.2) +
    geom_sf(data = dados_6dias, 
            aes(fill = ehf_cat, geometry = geometry), 
            alpha = 0.4) +  # Removi o input$opacidade_mapa para manter consistência
    facet_wrap(~Data_label, ncol = 3) +  # 2 linhas x 3 colunas = 6 mapas
    labs(title = "Mapas de Excesso de Calor - Últimos 6 Dias",
         caption = "Fonte: BR-DWGD/ERA5-Land/ECMWF Weather Forecast") +
    coord_sf(xlim = c(-42, -34), ylim = c(-6.4, -10.8), expand = FALSE) +
    scale_fill_manual(
     name = "Categoria de Calor",
     values = c("#BA1B10", "#e67e22", "#f1c40f", "#228920"),
     breaks = c("Excesso de Calor extremo", 
                "Excesso de Calor severo",
                "Excesso de Calor Leve",
                "Sem Excesso de Calor")
    ) +
    theme_minimal() +
    theme(
     plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
     legend.position = "bottom",
     legend.title = element_text(face = "bold"),
     strip.text = element_text(face = "bold", size = 10),
     panel.spacing = unit(1, "lines")
    )
   
   # 5. Exportar com tamanho fixo adequado para 6 mapas
   ggsave(file, plot = p, device = "png",
          width = 14, height = 10, dpi = 300, bg = "white")
  }
 )
 # Botão para resetar a visualização do mapa
 observeEvent(input$reset_map, {
  leafletProxy("mapa") %>%
   setView(lng = -37.4, lat = -8.5, zoom = 8)
 })
}