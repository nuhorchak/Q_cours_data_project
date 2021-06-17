library(rmarkdown)
library(bookdown)

#PLEASE NOTE THAT THIS ONLY WORKS WITH SINGLE RMD DOCUMENTS FOR THIS TYPE OF BLOG POST TEMPLATE
bookdown::render_book(input = 'Uhorchak_Data_analysis_info_paper.Rmd',
                      output_format = 'bookdown::markdown_document2',
                      output_dir = '.',
                      output_file = 'readme.md')
