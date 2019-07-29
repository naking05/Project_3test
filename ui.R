#load libraries
library(shiny)
library(tidyverse)
library(plotly)

#data management
load("nba_shots.RData")
players = nba_shots %>% distinct(player_name) %>% pull()
made = nba_shots %>% distinct(shot_made_flag ) %>% pull()

#define UI for application
shinyUI(fluidPage(
    
    tagList(
        navbarPage(
            "NBA Player Shooting App",
            
            #describe app
            tabPanel("About The Application","To be completed later"),
            
            #show raw data
            tabPanel("Shot Data", 
                     sidebarLayout(
                         sidebarPanel(
                             downloadButton("nbadata", "Download"), width = 1.5),
                         
                         mainPanel(
                             h2("NBA Player Shots Information"),
                             dataTableOutput("rawdata")
                         ))
            ),
            
            #user data exploration
            tabPanel("Shot Summaries",
                     #sidebar with a slider input for number of bins 
                     sidebarLayout(
                         sidebarPanel(
                             #drop down menu for player
                             selectInput("player_choice", label = h3("Select Player"),
                                         choices = players, selected = "LeBron James"),
                             
                             #drop down menu for season based on a certain player
                             uiOutput("season_choice"),
                             
                             radioButtons("shots_made", label = h3("Shot Status"), choices = list("all", "made", "missed"))
                             
                             
                         ),
                         
                         #show output based on user selections
                         mainPanel(
                             
                             tabsetPanel(type = "tabs",
                                         tabPanel(h4("Spatial Display"), plotOutput("court_shots")),
                                         tabPanel(h4("Basket Distance"),  plotlyOutput("shot_distances")),
                                         tabPanel(h4("Court Position"), plotOutput("court_position")),
                                         tabPanel(h4("Time Remaining"), 
                                                  plotlyOutput("coupled1"),
                                                  plotOutput("coupled2")
                                         ))
                             
                        )
                    )
                ),
            
              tabPanel("Shot Clustering",
                #sidebar with a slider input for number of bins 
                sidebarLayout(
                  sidebarPanel(
                         #drop down menu for player
                         selectInput("player_choice", label = h3("Select Player"),
                               choices = players, selected = "LeBron James"),
                    
                         #drop down menu for season based on a certain player
                         uiOutput("season_choice2"),
                    
                         selectInput("hclustMethod", label="Method", choices=list(
                           "Single"="single","Complete"="complete","Average"="average",
                           "Centroid"="centroid"
                         ),selected="single"),
                         
                         selectInput("metric", label="Distance", choices=list(
                           "Euclidian"="euclidian","Maximum"="maximum","Manhattan"="manhattan",
                           "Canberra"="canberra","Binary"="binary","Minkowski"="minkowski"
                         ),selected="single")
                         
                  ),
                  
                  mainPanel(
                  
                  #show a plot of the generated distribution
                         plotOutput("treePlot")

                )
              ))
            ) #close navbarPage
        ) #close taglist
    ) #close fluidpage
) #close shinyUI