# Plotly has trouble when loaded as a Library in app.R so.. global.R
# See https://stackoverflow.com/a/51016132
library(shiny)
library(plotly)
library(tidyverse)

# Input descriptions.
hospitalization_rate <- "percent of newly infected patients who are admitted to this hospital"
icu_admit_rate <- "percent of newly infected patients who are admitted to the ICU"
ventilator_rate <- "percent of newly infected patients who are admitted to the hospital and require use of a ventilator"
mortality_rate <- "percent of newly infected patients whose outcome is death"
icu_share_of_days <- "percent of days spent in the ICU"
los_aac <- "average length of stay (in days) in Adult Acute Care (AAC) units such as Med/Surg."
los_icu <- "average length of stay (in days) for patients who are admitted to the ICU"
days_til_hosp_aac <- "number of days after infection that patient is admitted to AAC"
days_til_hosp_icu <- "number of days after infection that patient is admitted to the ICU"

# OHSU logo colors
color_ohsu_logo__yellow <- "#ffca38"
color_ohsu_logo__blue <- "#5d97c9"
color_ohsu_logo__green <- "#56b146"