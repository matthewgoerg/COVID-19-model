library(shiny)
library(plotly)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # tags$head(
  #   tags$style(
  #     "body{
  #   min-height: 800px;
  #   height: auto;
  #   max-width: 1600px;
  #   margin: auto;
  #       }"
  #   )
  # ),
  
  # Tab title
  title="COVID-19 SIR Model",
  
  # App title ----
  p(HTML("<p>
          <span style=\"font-size:30px;\">COVID-19 SIR Model</span>
          <span style=\"font-size:15px;\">&nbsp;&nbsp;&nbsp;v0.4.1&nbsp;&nbsp;&nbsp;2020-04-10</span>
          </p>")),
  
  column(5, wellPanel(style = "overflow-y:scroll; max-height: 700px; position: relative;",
                      
                      # Input: Choose dataset ----
                      selectInput("dataset", "Choose a dataset:",
                                  choices = c("master")),
                      
                      # Button
                      downloadButton("downloadData", "Download"),
                      
                      
                      h3("Scenario variables"),
                      splitLayout(
                        p(" "), p(tags$b("low")), p(tags$b("moderate")), p(tags$b("high"))
                      ),
                      splitLayout(
                        h5("Hospitalization rate"),
                        textInput(inputId = "hospitalization_rate_a", label = NULL, value = paste0(17, "%")),
                        textInput(inputId = "hospitalization_rate_b", label = NULL, value = paste0(19, "%")),
                        textInput(inputId = "hospitalization_rate_c", label = NULL, value = paste0(19, "%"))
                      ),
                      splitLayout(
                        h5("ICU admit rate"),
                        textInput(inputId = "icu_admit_rate_a", label = NULL, value = paste0(8.5, "%")),
                        textInput(inputId = "icu_admit_rate_b", label = NULL, value = paste0(10, "%")),
                        textInput(inputId = "icu_admit_rate_c", label = NULL, value = paste0(15, "%"))
                      ),
                      splitLayout(
                        h5("Ventilator rate"),
                        textInput(inputId = "ventilator_rate_a", label = NULL, value = paste0(6.4, "%")),
                        textInput(inputId = "ventilator_rate_b", label = NULL, value = paste0(7.5, "%")),
                        textInput(inputId = "ventilator_rate_c", label = NULL, value = paste0(7, "%"))
                      ),
                      splitLayout(
                        h5("Mortality rate"),
                        textInput(inputId = "mortality_rate_a", label = NULL, value = paste0(5.3, "%")),
                        textInput(inputId = "mortality_rate_b", label = NULL, value = paste0(13.2, "%")),
                        textInput(inputId = "mortality_rate_c", label = NULL, value = paste0(23.7, "%"))
                      ),
                      splitLayout(
                        h5("ICU share of days"),
                        textInput(inputId = "icu_share_of_days_a", label = NULL, value = paste0(66, "%")),
                        textInput(inputId = "icu_share_of_days_b", label = NULL, value = paste0(66, "%")),
                        textInput(inputId = "icu_share_of_days_c", label = NULL, value = paste0(50, "%"))
                      ),
                      splitLayout(
                        h5("AAC LOS"),
                        numericInput(inputId = "los_aac_a", label = NULL, value = 10),
                        numericInput(inputId = "los_aac_b", label = NULL, value = 10),
                        numericInput(inputId = "los_aac_c", label = NULL, value = 14)
                      ),
                      splitLayout(
                        h5("ICU LOS"),
                        numericInput(inputId = "los_icu_a", label = NULL, value = 15),
                        numericInput(inputId = "los_icu_b", label = NULL, value = 15),
                        numericInput(inputId = "los_icu_c", label = NULL, value = 22)
                      ),
                      splitLayout(
                        h5("Days til hosp AAC"),
                        numericInput(inputId = "days_til_hosp_aac_a", label = NULL, value = 5),
                        numericInput(inputId = "days_til_hosp_aac_b", label = NULL, value = 5),
                        numericInput(inputId = "days_til_hosp_aac_c", label = NULL, value = 5)
                      ),
                      splitLayout(
                        h5("Days til hosp ICU"),
                        numericInput(inputId = "days_til_hosp_icu_a", label = NULL, value = 5),
                        numericInput(inputId = "days_til_hosp_icu_b", label = NULL, value = 5),
                        numericInput(inputId = "days_til_hosp_icu_c", label = NULL, value = 5)
                      ),
   
                      h3("Interventions"),
                      splitLayout(
                        dateInput(inputId = "intervention1_date", label = "Date:", value = '2020-01-01'),
                        numericInput(inputId = "factor_a1", label = "low", value = 0.0),
                        numericInput(inputId = "factor_b1", label = "moderate", value = 0.0),
                        numericInput(inputId = "factor_c1", label = "high", value = 0.0)),
                      splitLayout(
                        dateInput(inputId = "intervention2_date", label = NULL, value = '2020-02-28'),
                        numericInput(inputId = "factor_a2", label = NULL, value = 0.15),
                        numericInput(inputId = "factor_b2", label = NULL, value = 0.15),
                        numericInput(inputId = "factor_c2", label = NULL, value = 0.15)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention3_date", label = NULL, value = '2020-03-11'),
                        numericInput(inputId = "factor_a3", label = NULL, value = 0.2),
                        numericInput(inputId = "factor_b3", label = NULL, value = 0.2),
                        numericInput(inputId = "factor_c3", label = NULL, value = 0.2)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention4_date", label = NULL, value = '2020-03-16'),
                        numericInput(inputId = "factor_a4", label = NULL, value = 0.3),
                        numericInput(inputId = "factor_b4", label = NULL, value = 0.3),
                        numericInput(inputId = "factor_c4", label = NULL, value = 0.3)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention5_date", label = NULL, value = '2020-03-23'),
                        numericInput(inputId = "factor_a5", label = NULL, value = 0.4),
                        numericInput(inputId = "factor_b5", label = NULL, value = 0.4),
                        numericInput(inputId = "factor_c5", label = NULL, value = 0.4)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention6_date", label = NULL, value = '2020-04-01'),
                        numericInput(inputId = "factor_a6", label = NULL, value = 0.45),
                        numericInput(inputId = "factor_b6", label = NULL, value = 0.45),
                        numericInput(inputId = "factor_c6", label = NULL, value = 0.45)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention7_date", label = NULL, value = '2020-04-08'),
                        numericInput(inputId = "factor_a7", label = NULL, value = 0.5),
                        numericInput(inputId = "factor_b7", label = NULL, value = 0.5),
                        numericInput(inputId = "factor_c7", label = NULL, value = 0.5)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention8_date", label = NULL, value = '2020-04-15'),
                        numericInput(inputId = "factor_a8", label = NULL, value = 0.6),
                        numericInput(inputId = "factor_b8", label = NULL, value = 0.6),
                        numericInput(inputId = "factor_c8", label = NULL, value = 0.6)
                      ),
                      splitLayout(
                        dateInput(inputId = "intervention9_date", label = NULL, value = '2020-04-30'),
                        numericInput(inputId = "factor_a9", label = NULL, value = 0.75),
                        numericInput(inputId = "factor_b9", label = NULL, value = 0.75),
                        numericInput(inputId = "factor_c9", label = NULL, value = 0.75)
                      ),
                      
                      h3("Other variables"),
                      splitLayout(
                        dateInput(inputId = "start_date", label = "Start date", value = '2020-02-01'),
                        dateInput(inputId = "end_date", label = "End date", value = '2020-06-30')
                      ),
                      numericInput(inputId = "number_of_beds", label = "Number of beds:", value = 50),
                      textInput(inputId = "population_size", label = "Population size:", 
                                   value = prettyNum("415,610", big.mark=",", scientific=FALSE)),
                      textInput(inputId = "hospital_share_of_market", label = "Hospital share of market:", value = paste0(23, "%")),
                      numericInput(inputId = "time_to_death_from_infection", label = "Days til death from infection:", value = 21),
                      numericInput(inputId = "quarantine_days", label = "Quarantine days:", value = 14),
                      numericInput(inputId = "expected_doubling_time", label = "Expected doubling days:", value = 6.2)
                      
  )
  ),
  mainPanel(   width = 7,
               tabsetPanel(type = "tabs",
                           
                           tabPanel("Overview", p(HTML("<br/>This app forecasts the number of admitted patients for a hospital at given point of time (hospital census).")),
                                    
                                      p("Variables on the left can be customized in three scenarios: low, moderate, and high. Users should enter values where low <= moderate <= high.
                                      A \"low\" scenario is one where the pandemic threat is lower than a \"moderate\" scenario. The Intensive Care Unit (ICU) census is expected to be lower in a \"low\" scenario than a \"moderate\" scenario and
                                      a \"high\" scenario is one where the pandemic threat is greatest."),
                                                                          
                                      p("The scenarios are depicted in the plot on the \"Hospital Census\" tab. The plot shows the ICU census, AAC census, and Total census which is the sum of ICU and AAC census 
                                      By default, only the Total utilization line (red) is displayed. To view the other trends, click the names in the legend to toggle the desired lines."),
                                      
                                      p("The blue line represents the ICU census over time. The green line represents the AAC census over time.
                                      The \"moderate\" scenario is the solid line in the middle and the \"low\" and \"high\" scenarios are the edges of the transparent ribbon.
                                      The outcome of a scenario that falls between the \"low\" and \"high\" scenarios should be somewhere within that ribbon. The ribbon is not a confidence interval in a statistic sense."),
                                      
                                      h3("Scenario variables:"),
                                      
                                      p(HTML(
                                      "<b>Hospitalization rate:</b> percent of newly infected patients who are admitted to this hospital<br/>",
                                      "<b>ICU admit rate:</b>  percent of newly infected patients who are admitted to the ICU<br/>",
                                      "<b>Ventilator rate:</b>  percent of newly infected patients who are admitted to the hospital and require use of a ventilator<br/>",
                                      "<b>Mortality rate:</b>  percent of newly infected patients whose outcome is death<br/>",
                                      "<b>ICU share of days:</b> percent of days spent in the ICU",
                                      "<br/>",
                                      "<b>AAC LOS:</b>  average length of stay (in days) in Adult Acute Care (AAC) units such as Med/Surg.<br/>",
                                      "<b>ICU LOS:</b>  average length of stay (in days) for patients who are admitted to the ICU<br/>",
                                      "<b>Days til hosp AAC:</b> number of days after infection that patient is admitted to AAC <br/>",
                                      "<b>Days til hosp ICU:</b> number of days after infection that patient is admitted to the ICU</b> ")),
                                      
                                      h3("Interventions:"),
                                      
                                      p("This section allows users to customize the dates and estimated impact factor of different policy interventions. Each intervention is assumed to reduce the amount of person-to-person contact and reduce the rate 
                                      of new infections. For each intervention, users should enter a number between 0 and 1."),
                                    
                                      p("For example, if the state instituted social distancing on Feb 28, 2020 and it is estimated that this policy 
                                        will reduce the infection rate by 15%, then users should enter the date 2020-02-28 with an impact factor of 0.15. As new interventions are introduced, the cumulative 
                                        impact is expected to increase. Smoothing is applied between intervention dates to make transitions from one intervention to another less abrupt. This smoothing is shown for the \"moderate\" scenario in the 
                                        \"Intervention Smoothing\" tab."),
                                      p("The default scenario assumes that the intial infection took place on 2020-02-01 and that the first intervention took place on 2020-01-28."),
                                      
                                      h3("Other variables:"),
                                      
                                      p(HTML(
                                      "<b>Start date:</b> The date of the first infection in the hospital catchment area<br/>",
                                      "<b>End date:</b> The latest date for the prediction time frame<br/>",
                                      "<b>Number of beds:</b> number of beds in the hospital or health system being analyzed, shown on the plot as a dashed gray line<br/>",
                                      "<b>Population size:</b> number of people in the hospital's catchment area<br/>",
                                      "<b>Hospital share of market:</b> percent of people in the region that are served by this hospital<br/>",
                                      "<b>Days til death from infection:</b> for patients whose outcome is death, it is the number of days between infection and death<br/>",
                                      "<b>Quarantine days:</b> number of days to quarantine after exposure to the virus, per the CDC<br/>",
                                      "<b>Expected doubling days:</b> number of days it takes to double the number of new cases (AHA says to expect a doubling time of 7-10 days)<br/>"))
                                      ),
                           
                           tabPanel("Hospital Census", plotlyOutput("view", height = "100%"),
                                    p(HTML("<br/>AAC = Adult Acute Care, ICU = Intensive Care Unit, Total = AAC + ICU")),
                                    p("Click on the names in the legend to toggle the lines. Bold lines represent the \"moderate\" scenario and the semitransparent lines represent
                                      the \"low\" and \"high\" scenarios. The shaded region represents the possible outcomes between the \"low\" and \"high\" scenarios.")),
                           tabPanel("Intervention Smoothing", plotlyOutput("regime", height = "100%"))
                           
               )
               
  )
  
)
