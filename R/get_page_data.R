

# Function to get JSON data from a page
get_page_data <- function(base_query,target_page) {
  #target_page <- 1
  query_url <- glue("{base_query}{target_page}")

  page_content <- tryCatch({
    read_html(query_url)
  }, error = function(e) {
    message("Error: ", e)
    return(NULL)
  })

  if (!is.null(page_content)) {
    script_text <- page_content %>%
      html_node("script:contains('aspViewModel')") %>%
      html_text()

    #    fromJSON(json_data, flatten = TRUE)
    # Extract the JSON string from the JavaScript variable assignment
    json_match <- regmatches(script_text, regexpr("aspViewModel = \\{.*\\};", script_text))

    if (length(json_match) == 0) return(NULL)

    json_clean <- sub("aspViewModel = ", "", json_match)
    json_clean <- sub(";$", "", json_clean)

    # Parse JSON
    json_data <- tryCatch({
      fromJSON(json_clean, flatten = TRUE)
    }, error = function(e) {
      message("JSON parsing error: ", e)
      return(NULL)
    })

    return(json_data)
  } else {
    return(NULL)
  }
}
