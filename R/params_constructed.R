n_results <- get_query_count(base_query)

pages <- ceiling(n_results/50)

sanitized_filename <- sanitize_filename(
  stringr::str_trim(URLdecode(query)))

file_pattern <- paste0("^\\d{4}-\\d{2}-\\d{2}-",
                       gsub(" ", "-", sanitized_filename), "\\.rds$") # File pattern for matching
