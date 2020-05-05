# Define server logic to summarize and view selected dataset ----
server <- function(input, output, session) {
  
  # here is the plot to show the Regime Smoothing
  output$regime <- renderPlotly({
    
    # identify the beginning of the time period
    day_zero <- as.Date(input$start_date)
    
    time_frame <- as.numeric(as.Date(input$end_date) - as.Date(input$start_date))
    
    # day number from 1 to time_frame
    days <- seq(0, time_frame, 1)
    
    # date from day_zero to end of time period
    dates <- seq(as.Date(input$start_date), as.Date(input$end_date), 1)
    
    # combine days and dates into a data.frame and rename columns
    master <- cbind.data.frame(days, as.Date(dates))
    names(master) <- c('day', 'date')
    
    # intervention table
    # here you identify interventions, their estimated influence,
    # and the date they were implemented (comes from user input)
    date <- c(day_zero-1, day_zero, input$intervention2_date, input$intervention3_date, 
              input$intervention4_date, input$intervention5_date, input$intervention6_date, 
              input$intervention7_date, input$intervention8_date, input$intervention9_date)
    
    interv_factor <- c(0, input$factor_b1, input$factor_b2, input$factor_b3, input$factor_b4,
                       input$factor_b5, input$factor_b6, input$factor_b7, input$factor_b8,
                       input$factor_b9)
    
    intervention <- cbind.data.frame(date, interv_factor)
    names(intervention) <- c('date', 'intervention_factor')
    
    # we want to smooth the effects of the interventions
    margin <- vector()
    margin[1] <- 0
    
    # based on logic from the workbook
    for(i in 2:nrow(intervention)) {
      if(i == nrow(intervention)) {
        margin[i] <- mean(margin[2:8])
      } else {
        margin[i] <- (intervention$intervention_factor[i] - intervention$intervention_factor[i - 1]) / min(7, intervention$date[i + 1] - intervention$date[i])
      }
    }
    
    intervention$margin <- margin
    
    # join the list of interventions to the master table and fill the dates forward
    master <- master %>%
      left_join(intervention) %>%
      fill(intervention_factor, margin)
    
    # start with all zeros
    master$smooth <- 0
    
    # add the marginal increases in factor to smooth out the regime effects
    for(i in 2:nrow(master)) {
      master$smooth[i] <- min(master$intervention_factor[i], (master$smooth[i-1]+master$margin[i]))
    }
    
    # drop the intermediate calculation columns
    master <- master %>%
      select(day, date, smooth)
    names(master) <- c('day', 'date', 'smooth')
    
    # generate the Regime Smoothing plot
    p <- ggplot(master) + geom_line(aes(date, smooth), size = 1.5) + ylim(0, 1) +
      theme_minimal() + theme(legend.position = "bottom") + ylab("factor") +
      labs(title = "Intervention Factor")
    
    # Get a dynamic width based on client screen size
    cl_width  <- session$clientData$output_image_width
    cl_height <- session$clientData$output_image_height
    fig <- ggplotly(p) %>% layout(height = cl_height, width = cl_width)

    fig
    
  })

  
  output$view <- renderPlotly({
    
    observe({
      if (!str_detect(input$icu_admit_rate_a, "%")) {
        updateTextInput(session, "icu_admit_rate_a", NULL, 
                        value = paste0(input$icu_admit_rate_a, "%"))
      }
      if (!str_detect(input$icu_admit_rate_b, "%")) {
        updateTextInput(session, "icu_admit_rate_b", NULL, 
                        value = paste0(input$icu_admit_rate_b, "%"))
      }
      if (!str_detect(input$icu_admit_rate_c, "%")) {
        updateTextInput(session, "icu_admit_rate_c", NULL, 
                        value = paste0(input$icu_admit_rate_c, "%"))
      }
      if (!str_detect(input$ventilator_rate_a, "%")) {
        updateTextInput(session, "ventilator_rate_a", NULL, 
                        value = paste0(input$ventilator_rate_a, "%"))
      }
      if (!str_detect(input$ventilator_rate_b, "%")) {
        updateTextInput(session, "ventilator_rate_b", NULL, 
                        value = paste0(input$ventilator_rate_b, "%"))
      }
      if (!str_detect(input$ventilator_rate_c, "%")) {
        updateTextInput(session, "ventilator_rate_c", NULL, 
                        value = paste0(input$ventilator_rate_c, "%"))
      }
      if (!str_detect(input$mortality_rate_a, "%")) {
        updateTextInput(session, "mortality_rate_a", NULL, 
                        value = paste0(input$mortality_rate_a, "%"))
      }
      if (!str_detect(input$mortality_rate_b, "%")) {
        updateTextInput(session, "mortality_rate_b", NULL, 
                        value = paste0(input$mortality_rate_b, "%"))
      }
      if (!str_detect(input$mortality_rate_c, "%")) {
        updateTextInput(session, "mortality_rate_c", NULL, 
                        value = paste0(input$mortality_rate_c, "%"))
      }
      if (!str_detect(input$hospitalization_rate_a, "%")) {
        updateTextInput(session, "hospitalization_rate_a", NULL, 
                        value = paste0(input$hospitalization_rate_a, "%"))
      }
      if (!str_detect(input$hospitalization_rate_b, "%")) {
        updateTextInput(session, "hospitalization_rate_b", NULL, 
                        value = paste0(input$hospitalization_rate_b, "%"))
      }
      if (!str_detect(input$hospitalization_rate_c, "%")) {
        updateTextInput(session, "hospitalization_rate_c", NULL, 
                        value = paste0(input$hospitalization_rate_c, "%"))
      }
      if (!str_detect(input$hospital_share_of_market, "%")) {
        updateTextInput(session, "hospital_share_of_market", NULL, 
                        value = paste0(input$hospital_share_of_market, "%"))
      }
      if (!str_detect(input$icu_share_of_days_a, "%")) {
        updateTextInput(session, "icu_share_of_days_a", NULL, 
                        value = paste0(input$icu_share_of_days_a, "%"))
      }
      if (!str_detect(input$icu_share_of_days_b, "%")) {
        updateTextInput(session, "icu_share_of_days_b", NULL, 
                        value = paste0(input$icu_share_of_days_b, "%"))
      }
      if (!str_detect(input$icu_share_of_days_c, "%")) {
        updateTextInput(session, "icu_share_of_days_c", NULL, 
                        value = paste0(input$icu_share_of_days_c, "%"))
      }
      if (!str_detect(input$population_size, ",")) {
        updateTextInput(session, "population_size", NULL, 
                        value = prettyNum(input$population_size, big.mark=",", scientific=FALSE))
      }
    })

    # identify the beginning of the time period
    day_zero <- as.Date(input$start_date)
    
    # here are some of the user input values and the values that
    # are derived from user inputs
    number_of_beds <- input$number_of_beds
    population_size <- input$population_size
    population_size <- as.numeric(gsub("\\,", "", population_size))
    
    hospital_share_of_market <- input$hospital_share_of_market
    hospital_share_of_market <- as.numeric(gsub("[^[:digit:]., ]", "", hospital_share_of_market))/ 100
    
    cases_on_day_one <- 1*hospital_share_of_market
    susceptible_day_one <- population_size - cases_on_day_one
       
    # the following inputs come as a group of three (for the low/moderate/high scenarios)
    # since they are displayed as whole number percentages to the user, they need to be converted
    # to numeric and divided by 100 before they are put into the model
    hospitalization_rates <- c(input$hospitalization_rate_a, input$hospitalization_rate_b, input$hospitalization_rate_c)
    hospitalization_rates <- as.numeric(gsub("[^[:digit:]., ]", "", hospitalization_rates))/ 100
    icu_admit_rates <- c(input$icu_admit_rate_a, input$icu_admit_rate_b, input$icu_admit_rate_c) 
    icu_admit_rates <- as.numeric(gsub("[^[:digit:]., ]", "", icu_admit_rates))/ 100
    ventilator_rates <- c(input$ventilator_rate_a, input$ventilator_rate_b, input$ventilator_rate_c)
    ventilator_rates <- as.numeric(gsub("[^[:digit:]., ]", "", ventilator_rates))/ 100
    mortality_rates <- c(input$mortality_rate_a, input$mortality_rate_b, input$mortality_rate_c)
    mortality_rates <- as.numeric(gsub("[^[:digit:]., ]", "", mortality_rates))/ 100
    icu_days <- c(input$icu_share_of_days_a, input$icu_share_of_days_b, input$icu_share_of_days_c)
    icu_days <- as.numeric(gsub("[^[:digit:]., ]", "", icu_days))/ 100
    
    time_to_death_from_infection <- input$time_to_death_from_infection
    recovered_day_one <- 0
    
    # CDC says to quarantine for 14 days, 1/14 is being used.
    inverse_of_mean_recovery_time <- 1/input$quarantine_days
    
    # AHA says to expect a doubling time of 7-10 days.
    expected_doubling_time <- input$expected_doubling_time 
    
    early_phase_rate_of_growth <- 2^(1/expected_doubling_time)-1
    effective_contact_rate <- early_phase_rate_of_growth + inverse_of_mean_recovery_time
    
    los_aac_list <- c(input$los_aac_a, input$los_aac_b, input$los_aac_c)
    los_icu_list <- c(input$los_icu_a, input$los_icu_b, input$los_icu_c)
    days_til_hosp_aac_list <- c(input$days_til_hosp_aac_a, input$days_til_hosp_aac_b, input$days_til_hosp_aac_c)
    days_til_hosp_icu_list <- c(input$days_til_hosp_icu_a, input$days_til_hosp_icu_b, input$days_til_hosp_icu_c)
    
    icu_share_of_days <- input$icu_share_of_days
    icu_share_of_days <- as.numeric(gsub("[^[:digit:]., ]", "", icu_share_of_days))/ 100
    
    time_frame <- as.numeric(as.Date(input$end_date) - as.Date(input$start_date))
    
    # day number from 1 to time_frame
    days <- seq(0, time_frame, 1)
    
    # date from 2020-01-23 to that date + 500 days
    dates <- seq(as.Date(input$start_date), as.Date(input$end_date), 1)
    
    # combine days and dates into a data.frame and rename columns
    master <- cbind.data.frame(days, as.Date(dates))
    names(master) <- c('day', 'date')
    
    # intervention table
    # here you identify interventions, their estimated influence,
    # and the date they were implemented (comes from user input)
    date <- c(day_zero-1, day_zero, input$intervention2_date, input$intervention3_date, 
              input$intervention4_date, input$intervention5_date, input$intervention6_date, 
              input$intervention7_date, input$intervention8_date, input$intervention9_date)
    
    interv_factor1 <- c(0, input$factor_a1, input$factor_a2, input$factor_a3, input$factor_a4,
                        input$factor_a5, input$factor_a6, input$factor_a7, input$factor_a8,
                        input$factor_a9)
    interv_factor2 <- c(0, input$factor_b1, input$factor_b2, input$factor_b3, input$factor_b4,
                        input$factor_b5, input$factor_b6, input$factor_b7, input$factor_b8,
                        input$factor_b9)
    interv_factor3 <- c(0, input$factor_c1, input$factor_c2, input$factor_c3, input$factor_c4,
                        input$factor_c5, input$factor_c6, input$factor_c7, input$factor_c8,
                        input$factor_c9)
    
    intervention <- cbind.data.frame(as.Date(date), interv_factor1, interv_factor2, interv_factor3)
    names(intervention) <- c('date', 'intervention_factor1', 'intervention_factor2', 'intervention_factor3')
    intervention$date <- as.Date(intervention$date)
    
    calc_census <- function(intervention, intervention_number, hospitalization_rate,
                                icu_admit_rate, ventilator_rate, mortality_rate, los_aac, 
                                los_icu, days_til_hosp_aac, days_til_hosp_icu,
                                icu_share_of_days) {
      
      # multiply the intervention factor by 1.1 if this is the low intervention
      if(intervention_number == 1) {
        intervention[,2] <- intervention[,2] * 1.1
      }
      
      margin <- vector()
      margin[1] <- 0
      
      # based on logic from the workbook
      for(i in 2:nrow(intervention)) {
        if(i == nrow(intervention)) {
          margin[i] <- mean(margin[2:8])
        } else {
          margin[i] <- (intervention$intervention_factor[i] - intervention$intervention_factor[i - 1]) / min(7, intervention$date[i + 1] - intervention$date[i])
        }
      }
      
      intervention$margin <- margin
      
      # join the list of interventions to the master table and fill the dates forward
      master <- master %>%
        left_join(intervention) %>%
        fill(intervention_factor, margin)
      
      # start with all zeros
      master$smooth <- 0
      
      # add the marginal increases in factor to smooth out the regime effects
      for(i in 2:nrow(master)) {
        master$smooth[i] <- min(master$intervention_factor[i], (master$smooth[i-1]+master$margin[i]))
      }
      
      # drop the intermediate calculation columns
      master <- master %>%
        select(day, date, smooth)
  
      names(master) <- c('day', 'date', 'intervention_factor')
      
      susceptible <- vector()
      infected <- vector()
      recovered <- vector()
      newly_infected <- vector()
      
      susceptible[1] <- susceptible_day_one
      infected[1] <- cases_on_day_one
      recovered[1] <- recovered_day_one
      newly_infected[1] <- infected[1]
      
      for(i in 2:(time_frame + 1)) {
        susceptible[i] <- susceptible[i-1] - ((1-master$intervention_factor[i])*effective_contact_rate/population_size*susceptible[i-1]*infected[i-1])
        infected[i] <- ((1-master$intervention_factor[i])*effective_contact_rate/population_size*susceptible[i-1]*infected[i-1]-inverse_of_mean_recovery_time*infected[i-1])+infected[i-1]
        recovered[i] <- inverse_of_mean_recovery_time*infected[i-1]+recovered[i-1]
        newly_infected[i] <- infected[i]+(recovered[i] - recovered[i-1]) - infected[i-1]
      }
      
      master$susceptible <- susceptible
      master$infected <- infected
      master$recovered <- recovered
      master$newly_infected <- newly_infected
      
      master$admit_in_hospital <- newly_infected*hospitalization_rate
      master$admit_in_icu <- newly_infected*icu_admit_rate
      master$admit_in_aac <- master$admit_in_hospital - master$admit_in_icu
      master$admit_w_ventilator <- newly_infected * ventilator_rate
      master$mortality_incidence <- master$infected * mortality_rate
      
      partial_adult_acute <- vector()
      partial_icu <- vector()
      
      for(i in 1:(time_frame + 1)) {
        
        start <- max(1, i - (los_aac + days_til_hosp_aac))
        stop <- max(1, i - (days_til_hosp_aac))
        partial_adult_acute[i] <- sum(master$admit_in_aac[start:stop])
        
        start <- max(1, i - (los_icu+days_til_hosp_icu))
        stop <- max(1, i - (days_til_hosp_icu))
        partial_icu[i] <- sum(master$admit_in_icu[start:stop])
        
      }
      
      master$partial_adult_acute <- partial_adult_acute
      master$partial_icu <- partial_icu
      
      master$aac_tot <- master$partial_adult_acute + (1 - icu_share_of_days) * partial_icu
      master$icu_tot <- master$partial_icu * icu_share_of_days
      master$hosp_total <- master$aac_tot + master$icu_tot
      
      mortality <- vector()
      
      for(i in 1:(time_frame + 1)) {
        
        mortality[i] <- master$mortality_incidence[max(1, i - time_to_death_from_infection)]
        
      }
      
      master$mortality <- mortality
      
      aac_results <- master %>%
        mutate(adm = aac_tot) %>%
        select(date, adm) %>%
        mutate(adm_type = "AAC")
      
      icu_results <- master %>%
        mutate(adm = icu_tot) %>%
        select(date, adm) %>%
        mutate(adm_type = "ICU")
      
      total_results <- master %>%
        mutate(adm = icu_tot + aac_tot) %>%
        select(date, adm) %>%
        mutate(adm_type = "Total")
      
      results <- bind_rows(aac_results, icu_results, total_results)
      
      if(intervention_number == 1) {
        names(results) <- c('date', 'low', 'adm_type')
      } else if(intervention_number == 2) {
        names(results) <- c('date', 'moderate', 'adm_type')        
      } else if(intervention_number == 3) {
        names(results) <- c('date', 'high', 'adm_type')        
      }

      return(results)
    }
    
    for(i in 1:3) {
      if(i == 1) {
        intervention_loop <- cbind.data.frame(intervention[,1], intervention[,i+1])
        names(intervention_loop) <- c('date', 'intervention_factor')
        display_plot <- calc_census(intervention_loop, i, hospitalization_rates[i],
                                        icu_admit_rates[i], ventilator_rates[i],
                                        mortality_rates[i], los_aac_list[i], los_icu_list[i], 
                                        days_til_hosp_aac_list[i], days_til_hosp_icu_list,
                                        icu_days[i])
      } else {
        intervention_loop <- cbind.data.frame(intervention[,1], intervention[,i+1])
        names(intervention_loop) <- c('date', 'intervention_factor')
        additional_intervention <- calc_census(intervention_loop, i, hospitalization_rates[i],
                                                   icu_admit_rates[i], ventilator_rates[i],
                                                   mortality_rates[i], los_aac_list[i], los_icu_list[i], 
                                                   days_til_hosp_aac_list[i], days_til_hosp_icu_list,
                                                   icu_days[i])
        display_plot <- display_plot %>%
          left_join(additional_intervention)
      }
    }
    
    # removing this to make the y-axis display range flexible
    # y_limit <- 50
    
    p <- ggplot(display_plot, aes(date, group = adm_type, color = adm_type)) +
      geom_line(aes(date, moderate), size = 1.5) +
      scale_x_date(date_labels = "%B") +
      geom_ribbon(aes(ymin=low, ymax=high, group = adm_type, color = adm_type, fill = adm_type),
                  alpha=0.1,       #transparency
                  linetype=1,      #solid, dashed or other line types
                  size=1) +
      geom_hline(yintercept = number_of_beds, linetype = "dashed", alpha = 0.4) +
      theme_minimal() + theme(legend.title = element_blank()) +
      # coord_cartesian(ylim=c(0, y_limit)) + 
      ylab("census") +
      scale_color_manual(values=c(color_ohsu_logo__yellow, color_ohsu_logo__blue, color_ohsu_logo__green)) +
      scale_fill_manual(values=c(color_ohsu_logo__yellow, color_ohsu_logo__blue, color_ohsu_logo__green)) +
      labs(title = "Predicted Hospital Census Over Time")

    # Get a dynamic width based on client screen size
    cl_width  <- session$clientData$output_image_width
    cl_height <- session$clientData$output_image_height
    fig <- ggplotly(p, height = cl_height, width = cl_width) %>%
      add_annotations( text="Type", xref="paper", yref="paper",
                       x=1.02, xanchor="left",
                       y=0.8, yanchor="bottom",    # Same y as legend below
                       legendtitle=TRUE, showarrow=FALSE ) %>%
      layout( legend=list(y=0.8, yanchor="top"))
    
    legendItems <- list("Total" = TRUE, "AAC" = "legendonly", "ICU" = "legendonly")
    
    # remove the ", 1)" part from the ggplotly legend names
    for (i in 1:length(fig$x$data)){
      if (!is.null(fig$x$data[[i]]$name)){
        fig$x$data[[i]]$name =  gsub("\\(","",str_split(fig$x$data[[i]]$name,",")[[1]][1])
        fig$x$data[[i]]$visible <- legendItems[[fig$x$data[[i]]$name]]
      }
    }
    
    fig
  },
  )
  
  
  # Reactive value for selected dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "master" = master)
  })
  
  # Table of selected dataset ----
  output$table <- renderTable({
    datasetInput()
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
    
  
}