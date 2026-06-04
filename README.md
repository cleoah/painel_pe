# 🔥 PE Heat Monitor - Painel de Calor Extremo para Pernambuco

[![R Version](https://img.shields.io/badge/R-4.2%2B-blue)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-1.7%2B-green)](https://shiny.rstudio.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## ⚠️ **ATENÇÃO - CREDENCIAIS NECESSÁRIAS ANTES DE EXECUTAR**

> ### **🔴 É OBRIGATÓRIO se registrar no site do Copernicus para obter o USER (UID) que dá acesso aos dados do ERA5!**
>
> **O USER não é o seu email! É uma sequência de letras e números aleatórios (ex: 345no3i45ho345o-lnoinbi-loinoaid9834)**
>
> **Passos para obter sua credencial:**
> 1. Acesse: **https://cds.climate.copernicus.eu/**
> 2. Clique em "Sign in" e faça seu cadastro
> 3. Após logado, vá em seu perfil (canto superior direito)
> 4. Role até a seção **"API key"**
> 5. Copie o **UID** (é uma string como `345no3i45ho345o-lnoinbi-loinoaid9834`)
> 6. Use este UID no script `funcao/todas_as_funcoes.R` na variável `MEU_USER`
>
> **Sem este passo, o download dos dados do ERA5 NÃO funcionará!**

---

## 📌 Sobre o Projeto

O **painel_pe** é um painel interativo desenvolvido em **R/Shiny** para monitoramento de **calor extremo** nos municípios de Pernambuco. O sistema combina dados históricos de temperatura (ERA5) com previsões de curto prazo (Open-Meteo) para calcular o **Excesso de Calor (EHF - Excess Heat Factor)** e identificar eventos de calor extremo.

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
painel_pe/
│
├── App_PE/ # Aplicação Shiny
│ ├── global.R # Bibliotecas e dados carregados
│ ├── server.R # Lógica do painel (15 KB)
│ ├── ui.R # Interface do usuário (5 KB)
│ ├── manifest.json # Metadados da aplicação (400 KB)
│ └── .History # Histórico do R
│
├── dados/ # Base de dados principal
│ └── brpedf.rda # Dados de temperatura por município
│ (gerado pelo dados_prep.R)
│
├── dados_temp/ # Downloads temporários do ERA5
│
├── funcao/ # Funções auxiliares
│ ├── calculo_EHF.R # Cálculo do Excess Heat Factor
│ ├── download_ano_era.R # Download de dados históricos ERA5
│ ├── previsao.R # Previsão Open-Meteo API
│ ├── processamento_dado_era.R # Processamento dos NetCDF
│ ├── todas_as_funcoes.R # Script principal de atualização
│ └── VERIFICAR STATUS DA BASE.R # Verificação da base
│
├── imagem/ # Imagens e assets do projeto
│
├── rsconnect/ # Configurações de deploy Shiny
│
├── dados_prep.R # ETL e atualização completa
├── painel_pe.Rproj # Projeto RStudio
├── .gitattributes # Configuração Git
├── .Rhistory # Histórico de comandos
└── README.md # Documentação


## 📂 Descrição dos Scripts

### Pasta `App_PE/` - Aplicação Shiny

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| `global.R` | Carrega bibliotecas e dados para toda a aplicação | 1 KB |
| `server.R` | Lógica de backend - processamento, filtros e reatividade | 15 KB |
| `ui.R` | Interface do usuário - layout, inputs e outputs | 5 KB |
| `manifest.json` | Metadados para deploy no shinyapps.io | 400 KB |

### Pasta `funcao/` - Funções Auxiliares

| Script | Descrição |
|--------|-----------|
| `todas_as_funcoes.R` | **Script principal** - Contém `atualizar_dados()` para baixar e processar ERA5 |
| `download_ano_era.R` | Download de dados históricos do ERA5 por ano |
| `processamento_dado_era.R` | Processamento de arquivos NetCDF do ERA5 |
| `calculo_EHF.R` | Cálculo do Excess Heat Factor para ondas de calor |
| `previsao.R` | Busca previsões de 5 dias via Open-Meteo API |
| `VERIFICAR STATUS DA BASE.R` | Função para verificar status e integridade da base |

### Scripts Raiz

| Arquivo | Descrição |
|---------|-----------|
| `dados_prep.R` | ETL completo - atualiza base histórica e previsões |
| `painel_pe.Rproj` | Arquivo de projeto RStudio |

## 🚀 Como Executar

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/painel_pe.git
cd painel_pe


