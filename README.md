# 🔥 PE Heat Monitor - Painel de Calor Extremo para Pernambuco

[![R Version](https://img.shields.io/badge/R-4.2%2B-blue)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-1.7%2B-green)](https://shiny.rstudio.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

## 📌 Sobre o Projeto

O **PE Heat Monitor** é um painel interativo desenvolvido em **R/Shiny** para monitoramento de **calor extremo** nos municípios de Pernambuco. O sistema combina dados históricos de temperatura (ERA5) com previsões de curto prazo (Open-Meteo) para calcular o **Excesso de Calor (EHF - Excess Heat Factor)** e identificar eventos de calor extremo.

### 🎯 Funcionalidades

- 📊 **Visualização histórica** de temperaturas por município
- 🌡️ **Previsão de 5 dias** para cada município
- 🔥 **Cálculo do EHF** (Excess Heat Factor) para identificação de ondas de calor
- 📅 **Filtros dinâmicos** por data, município e período
- 📈 **Gráficos interativos** de séries temporais
- 💾 **Base de dados atualizada automaticamente** via ERA5

### 🗺️ Abrangência

- **184 municípios** de Pernambuco
- Período: **Agosto/2025 até dados mais recentes disponíveis**
- Atualização automática via script `dados_prep`

## 🛠️ Tecnologias Utilizadas

| Ferramenta | Finalidade |
|------------|------------|
| **R** | Linguagem principal |
| **Shiny** | Framework para dashboard interativo |
| **ECMWFr** | Download de dados do ERA5 (Copernicus) |
| **Open-Meteo API** | Previsões meteorológicas (5 dias) |
| **data.table** | Processamento eficiente de dados |
| **leaflet** | Mapas interativos |
| **plotly** | Gráficos dinâmicos |
| **DT** | Tabelas interativas |

## 📁 Estrutura do Projeto
PE-Heat-Monitor/
├── dados/
│ └── brpedf.rda # Base de dados principal
├── funcao/
│ ├── download_era5.R # Download dados históricos
│ ├── process_era5.R # Processamento ERA5
│ ├── download_forecast.R # Previsão Open-Meteo
│ ├── calc_ehf.R # Cálculo do EHF
│ └── atualizar_base.R # Script de atualização
├── dados_prep.R # ETL e atualização completa
├── global.R # Bibliotecas e dados carregados
├── server.R # Lógica do painel
├── ui.R # Interface do usuário
├── app.R # Arquivo principal (shiny::runApp)
├── README.md # Este arquivo
└── LICENSE # Licença do projeto

