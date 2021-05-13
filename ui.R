# A shiny app for Neurscience related-stock performance
# May 2021
# Daniela Aguilar
# daniela.agrz12@gmail.com

library(shiny)
library(shinyWidgets)
library(shinythemes)
library(tidyquant)
library(tidyverse)
library(plotly)

tickers <- c("NERV","ACAD","SAGE","VRTX","AXSM","MNMD")
prices <- tq_get(tickers, 
                 get  = "stock.prices",
                 from = today()-months(12),
                 to   = today(),
                 complete_cases = F) %>%
    select(symbol,date,close)

ui <- fluidPage(#theme = shinytheme("superhero")),
    titlePanel("Neuroscience related- Stocks performance"), 
    sidebarLayout(
        sidebarPanel(width = 3,
                     pickerInput(
                         inputId = "stocks",
                         label = h4("Stocks"),
                         choices = c(
                             "Minerva Neurosciences"  = tickers[1], 
                             "Acadia"                 = tickers[2],
                             "Sage Therapeutics"      = tickers[3],
                             "Vertex Pharma"          = tickers[4],
                             "Axsome Therapeutics"    = tickers[5],
                             "Mind Medicine"          = tickers[6]),
                         selected = tickers,   
                         options = list(`actions-box` = TRUE), 
                         multiple = T),
                     
                     radioButtons("period", label = h4("Time Period"),
                                  choices = list("1 month" = 1, "3 months" = 2, "6 months" = 3, "12 months" = 4, "YTD" = 5), 
                                  selected = 4)
        ), 
        mainPanel(
            plotlyOutput("plot", height=500)
        )
    )
)

