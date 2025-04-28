# Programmer: George Whittington
# Data: 2025-04-24
# Purpose: Turn the R function from the second problem in homework #4 (the 
#          function to plot the college data) into an R Shiny app. My version 
#          is at this link: College Info (shinyapps.io). Make your own version 
#          of this app and publish it on shinyapps.io as described in the notes. 
#          Submit the app folder as a zip file on eLC and give the link to the 
#          app as a comment in the submission. Your app should have the same or
#          similar features as mine, but will use your own function with the
#          variables that you chose. It is fine for you to change your function 
#          if needed.

library(shiny)
library(bslib)
library(tidyverse)
library(gridExtra)

# Read in data ----
df <- read_csv("Data/MERGED2015_16_PP.csv",na=c("NULL", "PrivacySuppressed"))

# Load in function(s) ----
source("Functions/plot_college_data.R")

# Define UI ----
ui <- page_sidebar(
  title = "Q2: College Scorecard Data",
  sidebar = sidebar(
    width = 400,
    ### Card 1
    card(
      selectizeInput(
        inputId = "college_name",
        label = tags$p("Institution",
                       style = "font-size: 18px; font-weight: 500;"),
        choices = NULL,
      ),
      tags$br(),
      helpText("Enter the institution name. If you backspace and then start 
                typing it will autofill suggestions. If the line is missing in 
                the plot, it means that this data was missing for the institution.")
    ),
    ### Card 2
    card(
      checkboxGroupInput(
        inputId = "plot_list",
        label = tags$p("Select the Variables to Plot",
                       style = "font-size: 18px; font-weight: 500;"),
        choices = list("Average Faculty Salary"="AVGFACSAL",
                       "In-state Tuition and Fees"="TUITIONFEE_IN",
                       "Percentage of Degrees Awarded in Mathematics and Statistics"="PCIP27", 
                       "Percentage of Undergraduates Who Receive a Pell Grant"="PCTPELL"),
        selected = c("AVGFACSAL", "TUITIONFEE_IN", "PCIP27", "PCTPELL")
      )
    ),
    ### Card 3
    card(
      radioButtons(
        inputId = "match_control",
        label = tags$p("Match Control?",
                       style = "font-size: 18px; font-weight: 500;"),
        choices = list("yes"=TRUE, "no"=FALSE),
        selected = FALSE
      ),
      helpText("If Match Control is yes, then the data for the graphs are 
                limited to institutions of the same control type (public,
                private not-for-profit, for-profit) as the target institution")
    ),
    ### Card 4
    card(
      radioButtons(
        inputId = "match_ic",
        label = tags$p("Match IC Level?",
                       style = "font-size: 18px; font-weight: 500;"),
        choices = list("yes"=TRUE, "no"=FALSE),
        selected = FALSE
      ),
      helpText("If Match IC Level is yes, then the data for the graphs are 
                limited to institutions of the same level (four-year,two-year,
                less-than-two-year) as the target institution")
    )
  ),
  card(
    plotOutput(outputId = "plot_college_data")
  )
)

# Define server logic ----
server <- function(input, output, session) {
  # This was recommended as a warning message
  updateSelectizeInput(
    session, "college_name", choices = df$INSTNM,
    server = TRUE, selected = "University of Georgia"
  )
  
  output$plot_college_data <- renderPlot(
    plot_college_data(
      df,
      input$college_name,
      input$plot_list,
      input$match_control,
      input$match_ic
    )
  )
}

# Run the app ----
shinyApp(ui = ui, server = server)