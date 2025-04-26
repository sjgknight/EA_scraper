  #' Sanitize a Filename
  #'
  #' This function takes a string input and replaces unsafe characters (anything except alphanumeric characters and spaces) with an empty string.
  #'
  #' @param query A character string representing the input filename or query to sanitize.
  #' @return A sanitized character string containing only alphanumeric characters and spaces.
  #' @examples
  #' sanitize_filename("example!filename#123")
  #' # Returns: "examplefilename123"
  #'
  #' sanitize_filename("unsafe /file\\name.txt")
  #' # Returns: "unsafe filename"
  #'
  #' @export
  sanitize_filename <- function(query) {
    # Replace unsafe characters (anything except alphanumeric and spaces) with an empty string
    gsub("[^a-zA-Z0-9 ]", "", query)
  }
