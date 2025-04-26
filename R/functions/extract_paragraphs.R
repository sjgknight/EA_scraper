# extract_keyterm_matches <- function(data, key_terms, exclude_titles = TRUE) {
#   # Iterate over each key term
#   list_of_dfs <- purrr::map(
#     key_terms,
#     ~ {
#       key_term <- .x
#
#       # Add a new column for the current key term
#       data %>%
#         dplyr::mutate(
#           matches = purrr::map2(
#             document.text, document.PublicationID,
#             ~ {
#               # Extract the current document title and party name for this iteration
#               current_title <- data %>%
#                 dplyr::filter(document.PublicationID == .y) %>%
#                 dplyr::pull(document.DocumentTitle) %>%
#                 as.character()
#
#               current_party <- data %>%
#                 dplyr::filter(document.PublicationID == .y) %>%
#                 dplyr::pull(document.PartyName) %>%
#                 as.character()
#
#               # Handle empty or missing document.text
#               if (is.na(.x) || .x == "") {
#                 return(tibble::tibble(paragraph = character(0)))
#               }
#
#               # Split text into paragraphs
#               paragraphs <- unlist(stringr::str_split(.x, "\n\n"))
#
#               # Filter paragraphs containing the key term
#               key_paragraphs <- paragraphs[stringr::str_detect(paragraphs, key_term)]
#
#               # Exclude paragraphs if key terms are in the DocumentTitle or PartyName
#               if (exclude_titles) {
#                 # Check if current_title and current_party are valid
#                 current_title <- ifelse(is.na(current_title) | current_title == "", "", current_title)
#                 current_party <- ifelse(is.na(current_party) | current_party == "", "", current_party)
#
#                 filtered_paragraphs <- key_paragraphs[!stringr::str_detect(key_paragraphs, current_title) &
#                                                         !stringr::str_detect(key_paragraphs, current_party)]
#               } else {
#                 filtered_paragraphs <- key_paragraphs
#               }
#
#               # Return the results as a tibble
#               tibble::tibble(paragraph = filtered_paragraphs)
#             }
#           )
#         ) %>%
#         # Unnest the matches column into long format
#         tidyr::unnest_longer(matches, values_to = "paragraph") %>%
#         # Ensure all documents are included, even if no matches are found
#         tidyr::replace_na(list(paragraph = "No relevant paragraphs found")) %>%
#         # Select the relevant columns
#         dplyr::select(document.PublicationID, paragraph)
#     }
#   )
#
#   # Name the list of data frames by the first 10 characters of the key terms
#   names(list_of_dfs) <- purrr::map_chr(key_terms, ~ substr(.x, 1, 10))
#
#   return(list_of_dfs)
# }
