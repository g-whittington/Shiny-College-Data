# Programmer: George Whittington
# Data: 2025-04-24
# Purpose: Define the function for Q2 to use

plot_college_data <- function(df, college_name, plot_list, match_control, match_ic) {
  # handle case of no college name or plots selected 
  if (college_name == "" || is.null(plot_list)) {
    return(ggplot())
  }
  
  plot_labels <- list(
    "AVGFACSAL"="Average Faculty Salary",
    "TUITIONFEE_IN"="In-state Tuition and Fees",
    "PCIP27"="Percentage of Degrees Awarded in Mathematics and Statistics",
    "PCTPELL"="Percentage of Undergraduates Who Receive a Pell Grant"
  )

  # group data
  if (match_control) {
    control <- as.numeric(df |> dplyr::filter(INSTNM==college_name) |> select("CONTROL"))
    if (match_ic) {
      ic <- as.numeric(df |> dplyr::filter(INSTNM==college_name) |> select("ICLEVEL"))
      df <- df |> dplyr::filter(CONTROL==control, ICLEVEL==ic)
    } else {
      df <- df |> dplyr::filter(CONTROL==control)
    }
  } else if (match_ic) {
    ic <- as.numeric(df |> dplyr::filter(INSTNM==college_name) |> select("ICLEVEL"))
    df <- df |> dplyr::filter(ICLEVEL==ic)
  }
  
  # create function to create plot of each variable 
  to_plot <- list()
  
  for (i in 1:length(plot_list)) {
    school_place <- (df |> dplyr::filter(INSTNM==college_name))[[plot_list[i]]]
    
    to_plot[[i]] <- df |> ggplot(aes(x = .data[[plot_list[i]]])) +
      geom_histogram(colour="#724", fill="#E48", bins=20, na.rm=TRUE) +
      geom_vline(
        xintercept = school_place,
        colour="#F81",
        linewidth = 2
      ) +
     annotate(
       "text",
       x = school_place,
       y = +Inf,
       hjust= 1.5,
       angle = "90",
       label = college_name,
      ) +
      labs(
        x=plot_labels[[plot_list[i]]],
        title=plot_labels[[plot_list[i]]]
      ) 
  }
  
  grid.arrange(grobs=to_plot, ncol=2)
}





