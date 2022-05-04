#' Create new post at posts/
#'
#' @param name name of the post
#' @param dir parent directory to create post subdirectory in
#' @param prefix prefix of subdirectory
#' @param date
#'
#' @return newly created path
new_post <- function(name,
                     dir = "posts",
                     prefix = paste0(Sys.Date(), "_"),
                     date = format(Sys.Date())
) {

  dir_path <- new_post_subdir(name = name, dir = dir, prefix)
  file_path <- use_index_qmd(dir_path, dir_parent = dir, date = date)

  invisible(file_path)
}


# New post subdirectory ---------------------------------------------------


new_post_subdir <- function(name,
                            dir = "posts",
                            prefix = paste0(Sys.Date(), "_")
) {

  dir_name <- paste0(prefix, name)
  ## Check Dir Exist
  has_dir <- fs::dir_exists(here::here(dir, dir_name))
  if(has_dir) stop("directory ", dir_name, " already exist.")

  path <- fs::dir_create(here::here(dir, dir_name))

  cli::cli_alert_success("Create directory {.field {dir_name}} at {.file {path}}")
  invisible(path)

}


# Use Index qmd -----------------------------------------------------------


use_index_qmd <- function(dir_path,
                          dir_parent = "posts",
                          date = format(Sys.Date())
) {

  file_path <- fs::path(dir_path, "index", ext = "qmd")
  ## Check file Exist
  if(fs::file_exists(file_path)) stop("`index.qmd` already exist at ", file_path)

  ## Path to `here::i_am()`
  here_path <- fs::path("posts", fs::path_file(dir_path), "index", ext = "qmd")

  rmarkdown::pandoc_template(
    list(date = date, here_path = here_path),
    template = here::here("_dev/template/index-template.qmd"), # A pandoc template
    output = here::here(file_path)
  )

  cli::cli_alert_success("Create file {.field index.qmd} at {.file {file_path}}")
  invisible(file_path)

}
