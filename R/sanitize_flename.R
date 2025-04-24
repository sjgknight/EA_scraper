
sanitize_filename <- function(query) {
  # Replace unsafe characters (anything except alphanumeric and spaces) with a dash
  gsub("[^a-zA-Z0-9 ]", "", query)
}
