#
# # Function to extract context around a specific phrase
# extract_context <- function(data, phrase, window = 3) {
#   data %>%
#     mutate(
#       context_around_phrase = map2(
#         document.text, document.PublicationID,
#         ~ {
#           # Find the specific phrase in the text
#           match_start <- str_locate(.x, fixed(phrase))[1, "start"]
#           match_end <- str_locate(.x, fixed(phrase))[1, "end"]
#
#           if (!is.na(match_start)) {
#             # Extract surrounding context (e.g., 3 sentences before and after)
#             sentences <- unlist(str_split(.x, "(?<=[.!?])\\s+"))
#             phrase_index <- which(str_detect(sentences, fixed(phrase)))
#             start_index <- max(1, phrase_index - window)
#             end_index <- min(length(sentences), phrase_index + window)
#             context <- paste(sentences[start_index:end_index], collapse = " ")
#             return(context)
#           } else {
#             return(NA) # Return NA if the phrase is not found
#           }
#         }
#       )
#     )
# }
#
# # Function to compare extracted text with model text
# compare_with_model <- function(extracted_texts, model_text) {
#   map_dbl(extracted_texts, ~ textTinyR::cosine_similarity(.x, model_text))
# }
#
# # Example usage
# key_terms <- c("automation")
# specific_phrase <- "technology in relation to its enterprise that is likely to have a significant effect on the employees"
# model_text <- "This term applies if the employer: has made a definite decision to introduce a major change to production, program, organisation, structure or technology in relation to its enterprise that is likely to have a significant effect on the employees; ..."
#
# # Assuming `documents` is your data frame
# documents <- documents %>%
#   extract_paragraphs(key_terms = key_terms) %>%
#   extract_context(phrase = specific_phrase)
#
# # Compare extracted text with model text
# documents <- documents %>%
#   mutate(
#     similarity_to_model = compare_with_model(context_around_phrase, model_text)
#   )
#
# # View results
# print(documents)
