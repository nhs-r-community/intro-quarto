# Inspired from this blog https://www.mm218.dev/posts/2022-08-04-how-to-use-quarto-for-parameterized-reporting/#parameterized-reports

library(shiny)
library(quarto)

local_covid <- NHSRdatasets::covid19 

ui <- fluidPage(
  
  titlePanel("Covid country numbers"),
  
  selectizeInput(
    "country",
    "Country:",
    c("United_Kingdom", 
      "Ireland",
      "New_Zealand")),
  
  actionButton(
    "render",
    "Render!"
  ),
  
  textOutput("status")
)

server <- function(input, output) {
  
  output$status <- renderText({
    if (input$render) {
      isolate(
        quarto::quarto_render(
          "covid-report.qmd",
          execute_params = list(country = input$country)
        )
      )
      paste("Rendering complete at", Sys.time())
    }
  })
  
}

shinyApp(ui = ui, server = server)
