library(shiny)
library(shinyWidgets)
library(shinythemes)
library(tidyquant)
library(plotly)

server <- function(input, output) {
    
    observeEvent(c(input$period,input$stocks), {
        
        prices <- prices %>%
            filter(symbol %in% input$stocks)
        
        if (input$period == 1) {
            prices <- prices %>%
                filter(
                    date >= today()-months(1)) }
        
        if (input$period == 2) {
            prices <- prices %>%
                filter(date >= today()-months(3)) }
        
        if (input$period == 3) {
            prices <- prices %>%
                filter(date >= today()-months(6)) }
        
        if (input$period == 5) {
            prices <- prices %>%
                filter(year(date) == year(today()))}
        
        #Create a plot 
        output$plot <- renderPlotly({
            print(
                ggplotly(prices %>%
                             group_by(symbol) %>%
                             mutate(init_close = if_else(date == min(date), close,NA_real_)) %>%
                             mutate(value = round(100 * close / sum(init_close,na.rm=T),1)) %>%
                             ungroup() %>%
                             ggplot(aes(date, value, colour = symbol)) +
                             geom_line(size = 1, alpha = .6) + 
                             geom_area(aes(fill=symbol),position="identity",alpha=.1) +
                             theme_minimal(base_size=12) +
                             theme(axis.title=element_blank(),
                                   panel.grid = element_blank(),
                                   legend.text = element_text(colour="black"))
                )
            )
        })
    })
}
