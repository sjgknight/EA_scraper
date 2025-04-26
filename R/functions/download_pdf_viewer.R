#' Download PDF from a Viewer URL
#'
#' This function downloads a PDF document from a given encoded path using the specified base PDF viewer URL.
#' It checks if the PDF file already exists in the specified output directory. If the file exists, it skips downloading.
#' Otherwise, it parses the viewer's HTML content to extract the actual PDF URL and downloads the PDF file locally.
#'
#' @param encoded_path A character string representing the encoded path of the PDF resource.
#' @param publication_id A character string representing the publication ID used for naming the downloaded PDF file.
#' @param output_dir A character string specifying the directory where the PDF file will be saved. Defaults to `"data/pdfs/"`.
#' @param base_pdf_url A character string representing the base URL for the PDF viewer. Defaults to `"https://www.fwc.gov.au/document-search/pdfviewer?st=3&id="`.
#' @return A logical value: `TRUE` if the PDF download is successful or the file already exists, otherwise `FALSE`.
#' @examples
#' \dontrun{
#' # Example usage:
#' encoded_path <- "aHR0cHM6Ly9zYXNyY2RhdGFwcmRhdWVhYS5ibG9iLmNvcmUud2luZG93cy5uZXQvZW50ZXJwcmlzZWFncmVlbWVudHMvMjAyNS8yL2FlNTI3OTA0LnBkZg2"
#' publication_id <- "AE527904"
#' download_pdf_viewer(encoded_path, publication_id)
#'
#' # Example with custom output directory and base URL
#' custom_dir <- "custom_pdfs/"
#' custom_base_url <- "https://example.com/pdfviewer?st=3&id="
#' download_pdf_viewer(encoded_path, publication_id, output_dir = custom_dir, base_pdf_url = custom_base_url)
#' }
#' @details
#' The function performs the following steps:
#' 1. Checks if the file `{publication_id}.pdf` exists in the `output_dir`.
#'    - If the file exists, it skips the download and returns `TRUE`.
#' 2. Constructs the PDF viewer URL using the `base_pdf_url` and `encoded_path`.
#' 3. Sends a GET request to the viewer URL to retrieve the HTML content.
#' 4. Extracts the actual PDF URL from a JavaScript variable (`pdf_url`) in the HTML content.
#' 5. Cleans and decodes the extracted PDF URL.
#' 6. Sends a GET request to the cleaned PDF URL to download the PDF.
#' 7. Saves the PDF file locally in the `output_dir` directory with the name `{publication_id}.pdf`.
#'
#' If any step fails (e.g., due to an expired SAS token, a 403 error, or missing PDF URL), the function returns `FALSE`.
#'
#' @export
download_pdf_viewer <- function(encoded_path,
                                publication_id,
                                output_dir = "data/pdfs/",
                                base_pdf_url = "https://www.fwc.gov.au/document-search/pdfviewer?st=3&id="
) {

  file_name <- paste0(here::here(output_dir),publication_id, ".pdf")

  # Check if the file already exists
  if (file.exists(file_name)) {
    message("File already exists: ", file_name, ". Skipping download.")
    return(TRUE) # Skip downloading if the file exists
  }


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

      # Extract the actual PDF URL from the JavaScript variable `pdf_url`
      pdf_url <- stringr::str_match(html_content, "var pdf_url = '(.*?)';")[, 2]
      message("Extracted PDF URL: ", pdf_url)

      if (!is.na(pdf_url)) {
        # Decode HTML entities in the URL

        # Step 4: Clean the PDF URL
        pdf_url <- gsub("&amp;", "&", pdf_url)  # Decode HTML entities (&amp; -> &)
        pdf_url <- gsub("#.*$", "", pdf_url)   # Remove fragment identifiers (e.g., #search)
        message("Cleaned PDF URL: ", pdf_url) # Debugging output

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
