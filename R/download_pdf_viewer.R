
download_pdf_viewer <- function(encoded_path, publication_id) {

  base_pdf_url <- "https://www.fwc.gov.au/document-search/pdfviewer?st=3&id="

  # Construct the PDF Viewer URL
  pdf_viewer_url <- paste0(base_pdf_url, encoded_path)

  tryCatch({
    # Get the HTML response from the PDF Viewer URL
    response <- GET(pdf_viewer_url, add_headers(
      "Referer" = pdf_viewer_url,
      "User-Agent" = "Mozilla/5.0",
      "Accept" = "*/*",
      "Accept-Encoding" = "gzip, deflate, br",
      "Connection" = "keep-alive"
    ))

    if (status_code(response) == 200) {
      # Extract the HTML content
      html_content <- content(response, as = "text")

      # writeLines(html_content, "viewer_response.html")

      # Extract the actual PDF URL from the JavaScript variable `pdf_url`
      pdf_url <- stringr::str_match(html_content, "var pdf_url = '(.*?)';")[, 2]
      message("Extracted PDF URL: ", pdf_url)

      if (!is.na(pdf_url)) {
        # Decode HTML entities in the URL

        # Step 4: Clean the PDF URL
        pdf_url <- gsub("&amp;", "&", pdf_url)  # Decode HTML entities (&amp; -> &)
        pdf_url <- gsub("#.*$", "", pdf_url)   # Remove fragment identifiers (e.g., #search)
        message("Cleaned PDF URL: ", pdf_url) # Debugging output

        #pdf_url <- URLdecode(pdf_url)
        message("Decoded PDF URL: ", pdf_url)

        # Download the actual PDF
        pdf_response <- GET(pdf_url, add_headers(
          "Referer" = pdf_viewer_url,
          "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:137.0) Gecko/20100101 Firefox/137.0",
          "Accept" = "*/*",
          "Accept-Encoding" = "gzip, deflate, br",
          "Connection" = "keep-alive"
        ))


        if (status_code(pdf_response) == 200) {
          # Save the PDF content locally
          file_name <- paste0(here::here("data/pdfs/"),publication_id, ".pdf")
          writeBin(content(pdf_response, "raw"), file_name)
          message("Downloaded: ", file_name)
          return(TRUE)
        } else {
          message("Failed to download actual PDF for PublicationID: ", publication_id,
                  " - HTTP Status: ", status_code(pdf_response))
          return(FALSE)
        }
      } else {
        message("Could not find PDF URL in viewer HTML for PublicationID: ", publication_id)
        return(FALSE)
      }
    } else {
      message("Failed to access PDF Viewer for PublicationID: ", publication_id,
              " - HTTP Status: ", status_code(response))
      return(FALSE)
    }
  }, error = function(e) {
    message("Error accessing PDF Viewer: ", pdf_viewer_url)
    return(FALSE)
  })
}
