#' Retrieve and Parse JSON Data from a Web Page
#'
#' This function retrieves JSON data embedded in a web page's JavaScript variable and parses it into an R object.
#'
#' @param base_query A character string representing the base URL or query to retrieve the web page.
#' @param target_page A numeric or character value representing the page number or target page to append to the base query.
#' @return A parsed JSON object (as a list or data frame if `flatten = TRUE`) if successful, or `NULL` if an error occurs or no JSON data is found.
#' @examples
#' \dontrun{
#' base_query <- "https://example.com/api/data?page="
#' target_page <- 1
#' json_data <- get_page_data(base_query, target_page)
#' }
#'
#' @export
get_page_data <- function(base_query, target_page) {
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
