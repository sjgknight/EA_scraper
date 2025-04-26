#' Retrieve the Query Result Count from a JSON Script
#'
#' This function fetches the HTML content of the first page in a paginated query, extracts JSON data embedded in a script tag,
#' and retrieves the total count of results from the JSON structure.
#' when you run manually on https://www.fwc.gov.au/document-search how many results are there? Does not use <div class="fwc-pager-result-count">
#'
#'
#' @param base_query A character string representing the base query URL. It should include the endpoint and any necessary query parameters,
#' but not the page number (which will be appended as "1").
#' @return A numeric value representing the total count of results from the query. If the query fails to fetch or parse, it may throw an error.
#' @examples
#' \dontrun{
#' # Example usage with a base query
#' base_query <- "https://example.com/search?page="
#' total_count <- get_query_count(base_query)
#' print(total_count)
#' }
#' @details
#' The function performs the following steps:
#' 1. Appends the page number "1" to the `base_query` and fetches the HTML content of the first page.
#' 2. Searches the HTML for a `<script>` tag containing the term `aspViewModel`.
#' 3. Extracts the JSON data embedded in the `aspViewModel` variable using regular expressions.
#' 4. Parses the extracted JSON string into an R object using `jsonlite::fromJSON`.
#' 5. Retrieves the `count` field from the parsed JSON structure and returns it.
#'
#' @export
get_query_count <- function(base_query) {
  # Fetch the HTML of the first page
  page_html <- read_html(paste0(base_query, "1"))

  # Extract and parse the JSON data from the script containing 'aspViewModel'
  script_text <- page_html %>%
    html_node("script:contains('aspViewModel')") %>%
    html_text()

  json_data <- script_text %>%
    stringr::str_extract("aspViewModel = \\{.*\\};") %>% # Extract the JSON-like object
    stringr::str_remove("aspViewModel = ") %>%          # Remove variable assignment
    stringr::str_remove(";$") %>%                       # Remove trailing semicolon
    fromJSON(flatten = TRUE)                   # Parse as JSON

  # Extract and return the `count` field
  json_data$documentResult$count
}
