#' Import a vector of package names from a "Task View" page
#'
#' The file can either be a legacy `.ctv` file or a modern markdown-format task-view.
#'
#' @param   url   A filepath or URL containing a Task View page
#' @return   Character vector of package names
#'
#' @export

import_task_view_packages <- function(url) {
  task_view <- ctv::read.ctv(url)
  as.character(
    task_view[["packagelist"]][["name"]]
  )
}
