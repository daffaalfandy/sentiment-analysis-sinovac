if (interactive()) {
  library(shiny)
  library(shinycustomloader)
  library(shinythemes)
  library(SnowballC)
  library(twitteR)
  library(tm)
  library(NLP)
  library(plyr)
  library(ggplot2)
  library(RColorBrewer)
  library(wordcloud)
  library(Rstem)
  library(sentiment)
  
  source("main.R")
  
  choiceslist <- list('sinovac', 'vaccine', 'covid19', 'chinese')
  
  ## UI ##
  ui <- navbarPage(theme = shinytheme('flatly'),
                   tags$head(
                     tags$style(HTML("@import url('//fonts.googleapis.com/css?family=Poppins:200,300,400,600,700,800');"))
                   ),
                   
                   windowTitle = "Sentiment Analysis of Twitter Data `sinovac`", fluid = TRUE, inverse = FALSE,
                   
                   tabPanel(strong("Home"),
                            headerPanel(h1('Visualization', 
                                        style = "font-family: 'Poppins', cursive; font-weight: 500; 
                                                 line-height: 1.1; color: #FF5733")),
                            sidebarPanel(width = 3, 
                                         checkboxGroupInput(inputId = "keyword",
                                                            label = "Choose the keyword: ", 
                                                            choices = choiceslist,
                                                            selected = "sinovac"),
                                         hr(),
                                         sliderInput(inputId = "slider",
                                                     label = "Data Count: ",
                                                     min = 1, max = 100, value = 50),
                                         actionButton("update", "Changes", class = "btn-primary")
                            ),
                            mainPanel(h4("Application Description"),
                                      splitLayout(style = "border: 1px solid silver;",
                                                  cellWidths = 430,
                                                  cellArgs = list(style = "padding: 6px;"),
                                                  plotOutput("plot1"),
                                                  plotOutput("plot2")
                                      ),
                                      splitLayout(style = "border: 1px solid server",
                                                  plotOutput("plot")))
                            ),
                   tabPanel(strong("Tweet Data"),
                            mainPanel(tabsetPanel(id = 'dataset',
                                                  tabPanel("Real Tweets", dataTableOutput("table_real")),
                                                  tabPanel("Cleaned Tweets", dataTableOutput("table_cleaned"))))
                            ),
                   tabPanel(strong("Classification"),
                            mainPanel(h4("A table of the sentiment scores across four dictionaries"), withLoader()))
                   
                   )
}