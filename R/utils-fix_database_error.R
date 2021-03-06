
# Checks whether "id" column evaluates to logical
# If so, returns number of rows modified
check_id_logical <- function(data, id_expr, id) {

  nrows_modified <- tryCatch(
    with(data, eval(id_expr)) %>% sum(),
    error = function(e) {stop(glue::glue("In the `id` column, \'{id}\' does not evaluate to a logical."), call. = FALSE)}
  )

  return(nrows_modified)

}

# Checks that the replacement value for an integer variable is also an integer
fix_integer <- function(variable, value, id) {

  # Confirm new value is integer
  if(as.integer(value) != value) {
    stop(
      glue::glue(
        "The variable '{variable}' is an integer, but the value '{value}' for id '{id}' is not."
      ),
      call. = FALSE
    )
  } else {
    return(as.integer(value))
  }

}

# Checks if factor level of replacement value exists, if not, creates new level
fix_factor <- function(data, variable, value, id) {

  # If the new label in database_fixes exists in factor variable
  # type is factor and new value is already a level in the factor
  if(as.character(value) %in% attr(data[[variable]], "levels")) {
    newfactor <- factor(value, levels = attr(data[[variable]], "levels"))
  } else {

    # Create factor variable which includes new levels
    # The first item in the list will be all variable values from data[[variable]]
    # The second item in the list will be the new variable value
    # TODO: Confirm no issue with using this notation - if "variable" only corresponds to one variable
    # pluck(2) should always pick the correct value (see example https://forcats.tidyverse.org/reference/fct_unify.html)

    newfactor <- forcats::fct_unify(list(data[[variable]], factor(value))) %>% purrr::pluck(2)

    # Print a message that the fix is not an existing factor level
    message(glue::glue("The new value of {variable} for id '{id}' does not exist as a current factor level. ",
                       "'{value}' has been added as a new level."))

  }

  # Return new factor value
  return(newfactor)

}

# Checks whether replacement value can be coerced to date (date is in correct format), if not give error
fix_date <- function(variable_type, variable, value, id) {

  # Note: need to specify a format or you won't get NA for non-R date format (for as.Date)
  if(variable_type %in% c("POSIXct", "POSIXlt", "POSIXt")) newdate <- as.Date(value, format = "%Y-%m-%d")
  if(variable_type %in% c("Date")) newdate <- suppressWarnings(lubridate::ymd(value))

  # Warning if this generates NA
  if(is.na(newdate)) {
    stop(glue::glue("The new value for {variable} is `NA`. ",
                       "Please ensure that the value '{value}' for '{id}' is in standard R date format YYYY-MM-DD."),
            call. = FALSE)
  }

  return(newdate)

}

# Extracts unit from difftime variable in main data and converts new value to difftime
fix_difftime <- function(data, variable, value) {

  # Pull the units from the original variable
  units <- attr(data[[variable]], "units")

  # Use those units to calculate new difftime
  newdifftime <- as.difftime(as.numeric(value), units = units)

  return(newdifftime)

}

