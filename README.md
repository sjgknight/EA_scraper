Repository contains scripts to search the Fair Work enterprise agreement database https://www.fwc.gov.au/document-search

Note FairWork material is covered under a non-permissive copyright https://www.fwc.gov.au/about-us/legal-and-freedom-information/about-website/copyright
("You may download, display, print and reproduce this material in unaltered form only (retaining this notice) for your personal, non-commercial use or use within your organisation."). It is unclear if FairWork is the publisher (and owner) of agreements or if these are considered third party copyright. 

## Functions 

- `get_page_data.R` This function retrieves JSON data embedded in a web page's JavaScript variable and parses it into an R object.
- `download_pdf_viewer.R` This function downloads the PDF viewer script from the Fair Work website and saves it to a specified directory.

- `params.R` This file contains parameters for the project, such as the base URL for the Fair Work website and the directory to save downloaded files.
- `params_constructed.R` This file constructs the parameters for the project, such as the base URL for the Fair Work website and the directory to save downloaded files. (if I turned this into a package, this would be unexported functions)


## Psuedo-vignettes

- `get_awards.Rmd` This file contains a pseudo-vignette that demonstrates how to use the `get_page_data` and `download_pdf_viewer` functions to retrieve data from the Fair Work website.

There will be a `text_processR.Rmd` psuedo-vignette that demonstrates how to process the text data, but it's not implemented yet.


### Project context

This is an R project created with [projectR](https://github.com/sjgknight/projectR). 

It includes a default directory structure, gitignore templates, and a setup.R script in the R directory. To use this script, run `source('R/setup.R')` from the project directory. 

To connect to GitHub, run `usethis::use_github()` or `usethis::use_git()`. 

Project requires some directories that are in .gitignore, run:

```

dir.create("data")
dir.create("output")

```

Github copilot used to support code development and debugging. 
