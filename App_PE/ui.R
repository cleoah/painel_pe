library(bslib)
library(shiny)
library(shinyWidgets)
library(shinycssloaders)

# UI Definition
ui <- page_fluid(
 theme = bs_theme(
  bg = "#FFFFFF",
  fg = "#000000",
  version = 5,
  "primary" = "#236421",
  "success" = "#22881F",    # Verde
  "warning" = "#F2BB38",    # Amarelo
  "orange" = "#EA591C",     # Laranja
  "danger" = "#B91A12",     # Vermelho
  "secondary" = "#6c757d" ,  # Cinza
  base_font = font_google("Open Sans"),
  heading_font = font_google("Montserrat")
 ),
 
 tags$head(
  tags$style(HTML("
      .custom-card {
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        margin-bottom: 15px;
        height: 100%;  /* Garante que todos os cards tenham a mesma altura */
      }
      .value-box {
        transition: transform 0.3s;
      }
      .value-box:hover {
        transform: translateY(-5px);
      }
    "))
 ),
 
 # Card principal (container dos value boxes)
 card(   # Aba do mapa
  nav_panel(
   "Mapa de Calor",
   card_body(
    tags$h1("Distribuição espacial do Fator de excesso de Calor - Pernambuco",
            class = "text-center fw-bold mb-4"),
    
    fluidRow(
     column(
      width = 4,
      selectInput(
       "data_mapa", 
       "Selecione a data:", 
       choices = unique(mapa$Data_label),
       selected =  mapa$Data_label[which.max(as.Date(mapa$Data))],  # Isso define a última data como padrão
       width = "100%"
      )
     ),
     column(
      width = 4,
      sliderInput(
       "opacidade_mapa",
       "Opacidade do mapa:",
       min = 0.1, 
       max = 1, 
       value = 0.4,
       width = "100%"
      )
     ),
     column(
      width = 4,
      actionButton(
       "reset_map",
       "Resetar Visualização",
       icon = icon("sync"),
       class = "btn-outline-primary",
       style = "margin-top: 25px; width: 100%;"
      )
     )
    ),
    
    # Mapa Leaflet
    leafletOutput("mapa", height = "700px") %>%
     withSpinner(type = 6, color = "#228920"),
    
    # Rodapé do mapa
    div(
     class = "d-flex justify-content-between mt-3 align-items-center",
     downloadButton(
      "download_grafico",
      "Exportar Mapa",
      class = "btn-success btn-download"
     ),
     div(
      class = "text-muted",
      "Fonte: ERA5-Land/ECMWF Weather Forecast/IBGE"
     )
    )
   )
  )

 ),
 
 # Abas principais
 navset_card_tab(
  id = "main_tabs",
  full_screen = TRUE,
  card_header(
   tags$h1("Níveis de alerta e temperaturas por município - previsão", 
           class = "text-center fw-bold mb-4")
  ),
  
  # Aba de análise temporal
  
   card_body(
    fluidRow(
     column(
      width = 6,
      airDatepickerInput(
       "date_range",
       "Selecione o período:",
       range = TRUE,
       value = c(max(final$Data) - 15, max(final$Data)),
       language = "pt-BR"
      )
     ),
     column(
      width = 6,
      pickerInput(
       "municipio",
       "Selecione o município:",
       choices = unique(final$municipio),
       # selected = "RECIFE",
       options = list(`live-search` = TRUE)
      )
     ),
     plotlyOutput("grafico", height = "400px") %>%
      withSpinner(type = 6, color = "#228920"),
     card_image(
      file = "imagem/legenda_.png",
      class = "mt-3 mx-auto",
      style = "width: 65%;"
     )
    )
   ),
  
   card_body(
    # Layout em 2 linhas de 3 colunas para os value boxes
    layout_columns(
     col_widths = c(4, 4, 4),  # 3 colunas por linha (12 unidades no total)
     row_heights = "auto",      # Altura automática
     gap = "15px",              # Espaçamento entre os cards
     # Value Boxes (6 no total)
     uiOutput("valueBox7"),
     uiOutput("valueBox6"),
     uiOutput("valueBox5"),
     uiOutput("valueBox4"),
     uiOutput("valueBox3"),
     uiOutput("valueBox2"),
     uiOutput("valueBox1")
    ),
    # Legenda (opcional, se necessário)
    card_image(
     file = "imagem/legenda_box.png",
     class = "mt-3 mx-auto",
     style = "width: 50%;"
    )
   

  )
 )
)