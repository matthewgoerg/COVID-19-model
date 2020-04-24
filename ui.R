# Define UI for dataset viewer app ----
ui <- bootstrapPage(

  tags$head(
    # Additional items to include in the <head> element
    includeHTML("html/head.html"),

    # These can be moved to html/head.html.
    # OHSU Favicon
    tags$link(rel="shortcut icon",
              href="https://www.ohsu.edu/favicon.ico"),
    # OHSU default font
    tags$link(rel="stylesheet", type = "text/css",
              href = "https://fonts.googleapis.com/css?family=Lato:300,400,700"),
    # OHSU Base CSS
    tags$link(rel="stylesheet", type = "text/css",
              href = "https://www.ohsu.edu/themes/custom/ohsu_digs/dist/kyruus.css"),
    # Local CSS including overrides for OHSU and Bootstrap css
    # This is compiled from SCSS in app.scss and should not be edited directly
    # because edits will be overridden the next time SCSS is compiled.
    tags$link(rel="stylesheet", type = "text/css",
              href = "app.css"),
  ),

  # App title
  title="COVID-19 SIR Model",

  # Site Header and early HTML
  htmlTemplate("html/body-start.html",
               title = "COVID-19 SIR Model",
               version = "v0.4.1 2020-04-10",
               parent_text = "Advanced Computing Center",
               parent_url = "https://www.ohsu.edu/advanced-computing-center"
  ),

tags$main(id='app', class='layout-full-width main-content container-fluid',

  column(5, wellPanel(

                      h3("Scenario variables"),
                      div(class='form-row--scenario-variables__heading-row form-row__heading-row',
                        htmlTemplate("html/form-row__scenario-variables.html",
                          help_text = "",
                          row_label = "",
                          input_1 = 'low',
                          input_2 = 'moderate',
                          input_3 = 'high'
                        )
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = hospitalization_rate,
                        row_label = "Hospitalization rate",
                        input_1 = textInput(inputId = "hospitalization_rate_a", label = NULL, value = paste0(17, "%")),
                        input_2 = textInput(inputId = "hospitalization_rate_b", label = NULL, value = paste0(19, "%")),
                        input_3 = textInput(inputId = "hospitalization_rate_c", label = NULL, value = paste0(19, "%"))
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = icu_admit_rate,
                        row_label = HTML("<abbr title='Intensive care unit'>ICU</abbr> admit rate"),
                        input_1 = textInput(inputId = "icu_admit_rate_a", label = NULL, value = paste0(8.5, "%")),
                        input_2 = textInput(inputId = "icu_admit_rate_b", label = NULL, value = paste0(10, "%")),
                        input_3 = textInput(inputId = "icu_admit_rate_c", label = NULL, value = paste0(15, "%"))
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = ventilator_rate,
                        row_label = "Ventilator rate",
                        input_1 = textInput(inputId = "ventilator_rate_a", label = NULL, value = paste0(6.4, "%")),
                        input_2 = textInput(inputId = "ventilator_rate_b", label = NULL, value = paste0(7.5, "%")),
                        input_3 = textInput(inputId = "ventilator_rate_c", label = NULL, value = paste0(7, "%"))
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = mortality_rate,
                        row_label = "Mortality rate",
                        input_1 = textInput(inputId = "mortality_rate_a", label = NULL, value = paste0(5.3, "%")),
                        input_2 = textInput(inputId = "mortality_rate_b", label = NULL, value = paste0(13.2, "%")),
                        input_3 = textInput(inputId = "mortality_rate_c", label = NULL, value = paste0(23.7, "%"))
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = icu_share_of_days,
                        row_label = "ICU share of days",
                        input_1 = textInput(inputId = "icu_share_of_days_a", label = NULL, value = paste0(66, "%")),
                        input_2 = textInput(inputId = "icu_share_of_days_b", label = NULL, value = paste0(66, "%")),
                        input_3 = textInput(inputId = "icu_share_of_days_c", label = NULL, value = paste0(50, "%"))
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = los_aac,
                        row_label = HTML("<abbr title='Adult Acute Care'>AAC</abbr> <abbr title='Length of stay'>LOS</abbr>"),
                        input_1 = numericInput(inputId = "los_aac_a", label = NULL, value = 10),
                        input_2 = numericInput(inputId = "los_aac_b", label = NULL, value = 10),
                        input_3 = numericInput(inputId = "los_aac_c", label = NULL, value = 14)
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = los_icu,
                        row_label = HTML("<abbr title='Intensive care unit'>ICU</abbr> <abbr title='Length of stay'>LOS</abbr>"),
                        input_1 = numericInput(inputId = "los_icu_a", label = NULL, value = 15),
                        input_2 = numericInput(inputId = "los_icu_b", label = NULL, value = 15),
                        input_3 = numericInput(inputId = "los_icu_c", label = NULL, value = 22)
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = days_til_hosp_aac,
                        row_label = HTML("Days til hosp <abbr title='Adult Acute Care'>AAC</abbr>"),
                        input_1 = numericInput(inputId = "days_til_hosp_aac_a", label = NULL, value = 5),
                        input_2 = numericInput(inputId = "days_til_hosp_aac_b", label = NULL, value = 5),
                        input_3 = numericInput(inputId = "days_til_hosp_aac_c", label = NULL, value = 5)
                      ),
                      htmlTemplate("html/form-row__scenario-variables.html",
                        help_text = days_til_hosp_icu,
                        row_label = HTML("Days til hosp ICU <abbr title='Intensive care unit'>ICU</abbr>"),
                        input_1 = numericInput(inputId = "days_til_hosp_icu_a", label = NULL, value = 5),
                        input_2 = numericInput(inputId = "days_til_hosp_icu_b", label = NULL, value = 5),
                        input_3 = numericInput(inputId = "days_til_hosp_icu_c", label = NULL, value = 5)
                      ),


                      h3("Interventions"),
                      div(class='form-row--interventions-variables__heading-row form-row__heading-row',
                        htmlTemplate("html/form-row__interventions-variables.html",
                          date_input = dateInput(inputId = "intervention1_date", label = "Date:", value = '2020-01-01'),
                          input_1 = numericInput(inputId = "factor_a1", label = "low", value = 0.0),
                          input_2 = numericInput(inputId = "factor_b1", label = "moderate", value = 0.0),
                          input_3 = numericInput(inputId = "factor_c1", label = "high", value = 0.0)
                        ),
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention2_date", label = NULL, value = '2020-02-28'),
                        input_1 = numericInput(inputId = "factor_a2", label = NULL, value = 0.15),
                        input_2 = numericInput(inputId = "factor_b2", label = NULL, value = 0.15),
                        input_3 = numericInput(inputId = "factor_c2", label = NULL, value = 0.15)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention3_date", label = NULL, value = '2020-03-11'),
                        input_1 = numericInput(inputId = "factor_a3", label = NULL, value = 0.2),
                        input_2 = numericInput(inputId = "factor_b3", label = NULL, value = 0.2),
                        input_3 = numericInput(inputId = "factor_c3", label = NULL, value = 0.2)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention4_date", label = NULL, value = '2020-03-16'),
                        input_1 = numericInput(inputId = "factor_a4", label = NULL, value = 0.3),
                        input_2 = numericInput(inputId = "factor_b4", label = NULL, value = 0.3),
                        input_3 = numericInput(inputId = "factor_c4", label = NULL, value = 0.3)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention5_date", label = NULL, value = '2020-03-23'),
                        input_1 = numericInput(inputId = "factor_a5", label = NULL, value = 0.4),
                        input_2 = numericInput(inputId = "factor_b5", label = NULL, value = 0.4),
                        input_3 = numericInput(inputId = "factor_c5", label = NULL, value = 0.4)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention6_date", label = NULL, value = '2020-04-01'),
                        input_1 = numericInput(inputId = "factor_a6", label = NULL, value = 0.45),
                        input_2 = numericInput(inputId = "factor_b6", label = NULL, value = 0.45),
                        input_3 = numericInput(inputId = "factor_c6", label = NULL, value = 0.45)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention7_date", label = NULL, value = '2020-04-08'),
                        input_1 = numericInput(inputId = "factor_a7", label = NULL, value = 0.5),
                        input_2 = numericInput(inputId = "factor_b7", label = NULL, value = 0.5),
                        input_3 = numericInput(inputId = "factor_c7", label = NULL, value = 0.5)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention8_date", label = NULL, value = '2020-04-15'),
                        input_1 = numericInput(inputId = "factor_a8", label = NULL, value = 0.6),
                        input_2 = numericInput(inputId = "factor_b8", label = NULL, value = 0.6),
                        input_3 = numericInput(inputId = "factor_c8", label = NULL, value = 0.6)
                      ),
                      htmlTemplate("html/form-row__interventions-variables.html",
                        date_input = dateInput(inputId = "intervention9_date", label = NULL, value = '2020-04-30'),
                        input_1 = numericInput(inputId = "factor_a9", label = NULL, value = 0.75),
                        input_2 = numericInput(inputId = "factor_b9", label = NULL, value = 0.75),
                        input_3 = numericInput(inputId = "factor_c9", label = NULL, value = 0.75)
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
                                      paste("<b>Hospitalization rate:</b>", hospitalization_rate, "<br>"),
                                      paste("<b>ICU admit rate:</b>", icu_admit_rate, "<br/>"),
                                      paste("<b>Ventilator rate:</b>", ventilator_rate, "<br/>"),
                                      paste("<b>Mortality rate:</b>", mortality_rate, "<br/>"),
                                      paste("<b>ICU share of days:</b>", icu_share_of_days, "<br/>"),
                                      paste("<b>AAC LOS:</b>", los_aac, "<br/>"),
                                      paste("<b>ICU LOS:</b>", los_icu, "<br/>"),
                                      paste("<b>Days til hosp AAC:</b>", days_til_hosp_aac, "<br/>"),
                                      paste("<b>Days til hosp ICU:</b>", days_til_hosp_icu)
                                      )),
                                      
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
)
