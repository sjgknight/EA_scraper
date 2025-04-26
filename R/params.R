# DONT EDIT THESE LINES
start_page <- 1
query <- URLencode(query)
base_query <- glue::glue('https://www.fwc.gov.au/document-search?options=SearchType_3%2CSortOrder_agreement-relevance&q={query}&pagesize=50&page=')

data_dir <- here::here("data/")
