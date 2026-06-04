# 🔥 PE Heat Monitor - Painel de Calor Extremo para Pernambuco

[![R Version](https://img.shields.io/badge/R-4.2%2B-blue)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-1.7%2B-green)](https://shiny.rstudio.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## ⚠️ **ATENÇÃO - CREDENCIAIS NECESSÁRIAS ANTES DE EXECUTAR**

> ### **🔴 É OBRIGATÓRIO se registrar no site do Copernicus para obter o USER (UID)**
>
> **O USER não é o seu email! É uma sequência de letras e números aleatórios (ex: 9eieoweomq-345f-4e56b-321f-123456789d)**
>
> **⚠️ Importante: Você só precisa do USER (UID). NÃO precisa da API Key!**
>
> **Como obter seu USER (UID):**
> 1. Acesse: **https://cds.climate.copernicus.eu/**
> 2. Clique em "Sign in" e faça seu cadastro
> 3. Após logado, vá em seu perfil (canto superior direito)
> 4. O **UID** aparece no campo "User ID" ou na URL do seu perfil
> 5. Copie o UID (exemplo: `9eieoweomq-345f-4e56b-321f-123456789d`)
>
> **Configuração no script:**
> ```r
> wf_set_key(user = "seu-uid-aqui")  # Apenas o USER, sem key!
> ```
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

```
### Depois de instalados todos os pacotes necessários

## 1. Abrir o projeto
    Abra o arquivo painel_pe.Rproj no RStudio
    
## 2. Configurar USER do Copernicus (OBRIGATÓRIO)
    Abra o script todas_as_funcoes.R e configure o MEU_USER

## 3. Atualizar base de dados (primeira execução)
    abra o arquivo dados_pre.R
   
## 4. Executar o painel Shiny (pasta App_PE)
    execute o runApp no script global.R 


### 📊 Fluxo de Dados

                        ┌─────────────────────────────────────┐
                    │         dados_prep.R (ETL)          │
                    └─────────────────────────────────────┘
                                      │
            ┌─────────────────────────┼─────────────────────────┐
            ↓                         ↓                         ↓
    ┌───────────────┐         ┌───────────────┐         ┌─────────────┐
    │  funcao/      │         │  funcao/      │         │  funcao/    │
    │  download_    │         │  processa-    │         │  previsao.R │
    │  ano_era.R    │         │  mento_era.R  │         │             │
    └───────┬───────┘         └───────┬───────┘         └──────┬──────┘
            ↓                         ↓                         ↓
    ┌───────────────────────────────────────────────────────────────┐
    │                    todas_as_funcoes.R                         │
    │                 (atualizar_dados - ERA5)                      │
    └───────────────────────────────────────────────────────────────┘
                                      ↓
                            ┌─────────────────┐
                            │  dados/         │
                            │  brpedf.rda     │
                            └────────┬────────┘
                                      ↓
                    ┌─────────────────┼─────────────────┐
                    ↓                 ↓                 ↓
            ┌───────────────┐  ┌─────────────┐  ┌─────────────┐
            │  calculo_EHF  │  │  previsao   │  │  VERIFICAR  │
            │      .R       │  │     .R      │  │  STATUS.R   │
            └───────┬───────┘  └──────┬──────┘  └──────┬──────┘
                    ↓                 ↓                 ↓
                    └─────────────────┼─────────────────┘
                                      ↓
                            ┌─────────────────┐
                            │    App_PE/      │
                            │  global.R       │
                            │  server.R       │
                            │  ui.R           │
                            └─────────────────┘
                                      ↓
                            ┌─────────────────┐
                            │  Dashboard      │
                            │  Interativo     │
                            └─────────────────┘
### 📄 Licença

Distribuído sob licença MIT. Veja LICENSE para mais informações.

### 🙏 Agradecimentos

   # Copernicus Climate Change Service - Dados ERA5

   # Open-Meteo - Previsões meteorológicas gratuitas

   # Nairn & Fawcett (2013) - Metodologia EHF

   # RStudio/Posit - Shiny Framework



### 📜 Termos de Uso do Copernicus Climate Data Store (CDS)

O Copernicus Climate Data Store (CDS) é operado pelo European Centre for Medium-Range Weather Forecasts (ECMWF) em nome da União Europeia (UE). O acesso ao CDS e todo o seu Conteúdo é regulado por estes Termos de Uso e pela Copernicus Data Protection and Privacy Statement:

Artigo 1 - Descrição dos Produtos e Serviços

O CDS contém informações geofísicas e outros conjuntos de dados ("Produtos") e aplicações para usuários ("Serviços"), conjuntamente referidos como "Conteúdo".

Artigo 2 - Registro

O download do Conteúdo requer registro prévio. Para se registrar, os usuários deverão fornecer os seguintes dados: Nome e sobrenome, um endereço de e-mail válido, país de residência e o setor em que trabalham. Os usuários podem optar por informar a organização que representam. O registro - e qualquer licença aceita sob ele - aplica-se apenas ao seu titular nomeado. Cada usuário só pode ter uma conta.

Artigo 3 - Acesso

O CDS ou qualquer de seu Conteúdo pode estar indisponível temporariamente para manutenção programada ou devido a circunstâncias imprevistas.

Artigo 4 - Licenças

O Conteúdo acessível através do CDS só pode ser usado sob os termos da licença atribuída a ele, conforme atualizada periodicamente pelos licenciadores.

Artigo 5 - Sem Endosso

Nenhum usuário pode representar ou implicar publicamente que o ECMWF e/ou a UE estão participando, patrocinando, aprovando ou endossando a forma ou propósito do uso ou reprodução de qualquer Conteúdo.

Artigo 6 - Direito de Modificação

O ECMWF reserva o direito de modificar estes Termos de Uso a qualquer momento. Quaisquer Termos de Uso revisados serão publicados no site do CDS. As modificações entrarão em vigor imediatamente após a publicação dos Termos de Uso revisados.

Artigo 7 - Descontinuação e Rescisão

O ECMWF reserva o direito, a qualquer momento, de modificar ou descontinuar, temporária ou permanentemente, o Conteúdo, bem como qualquer meio de acessá-lo ou utilizá-lo, a seu exclusivo critério, com ou sem aviso prévio aos usuários.

O ECMWF pode, a seu exclusivo critério, sob quaisquer circunstâncias, por qualquer motivo ou sem motivo, e com ou sem aviso prévio aos usuários, suspender ou rescindir o acesso de qualquer usuário ao Conteúdo, particularmente em casos de violação destes Termos de Uso ou de quaisquer termos de licença aplicáveis.

Artigo 8 - Exclusão de Responsabilidade e Garantias

Exceto em casos de violações intencionais ou por negligência grave de seus funcionários ou representantes, ou reivindicações baseadas em lesão à vida, corpo ou saúde, nem o ECMWF nem a UE serão responsáveis perante qualquer usuário do CDS por qualquer perda ou dano de qualquer tipo incorrido em conexão com o uso do CDS.

O ECMWF e/ou a UE também não serão responsáveis pela precisão, utilidade ou disponibilidade de qualquer Conteúdo.

Qualquer Conteúdo disponibilizado para download ou uso através ou dentro do CDS é fornecido "como está" sem garantias adicionais de qualquer tipo, expressas ou implícitas, incluindo, mas não se limitando à qualidade, desempenho, comercialização ou adequação para um uso ou propósito específico. Sujeito ao exposto, nem o ECMWF nem a UE serão responsáveis por quaisquer danos, incluindo, mas não se limitando a danos diretos, indiretos, especiais, incidentais, punitivos, exemplares ou consequenciais decorrentes do uso ou da incapacidade de usar o Conteúdo.

Nem o ECMWF nem a UE serão responsáveis e não aceitam representação ou responsabilidade pela funcionalidade ou conteúdo de sites externos, serviços ou produtos de software hiperligados a partir do CDS.

O ECMWF e a UE se isentam de todas as garantias relacionadas ao fornecimento de Conteúdo através do CDS.

Artigo 9 - Privilégios e Imunidades

Nada nestes Termos de Uso ou relacionado a eles será considerado uma renúncia a quaisquer dos privilégios e imunidades do ECMWF e/ou da UE em conformidade com seus respectivos Protocolos sobre Privilégios e Imunidades.

Artigo 10 - Resolução de Disputas

Qualquer disputa entre o ECMWF e/ou a UE e partes interessadas decorrente ou relacionada ao uso do CDS ou seu Conteúdo será resolvida amigavelmente por negociação. Se a disputa não puder ser resolvida dessa forma, será finalmente resolvida sob as Regras de Arbitragem da Câmara de Comércio Internacional por três árbitros nomeados de acordo com as referidas regras, reunindo-se em Londres, Inglaterra. Os procedimentos serão em inglês. O direito de apelação por qualquer das partes perante qualquer tribunal nacional sobre uma questão de direito que surja no curso de qualquer procedimento arbitral ou de uma decisão proferida em qualquer procedimento arbitral fica, por meio deste, acordado como excluído.

Artigo 11 - Proteção de Dados Pessoais

A Copernicus Data Protection and Privacy Statement aplica-se a todos os dados pessoais fornecidos pelo usuário para se registrar.

Artigo 12 - Divisibilidade

Se qualquer disposição destes Termos de Uso for considerada inválida, ilegal ou de outra forma inexequível, tal inexequibilidade não afeta nenhuma outra disposição; os Termos de Uso devem então ser interpretados como se nunca tivessem contido a(s) disposição(ões) em questão e devem ser interpretados, na medida do possível, de forma a manter sua intenção original.

Versão 1.2 (Março 2024)
