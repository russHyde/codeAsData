#' Import a vector of package names from a "Task View" page
#'
#' The file can either be a legacy `.ctv` file or a modern markdown-format task-view.
#'
#' @param   url   A filepath or URL containing a Task View page
#' @return   Character vector of package names
#'
#' @export

import_task_view_packages <- function(url) {
  if (tools::file_ext(url) == "ctv") {
    packages <- import_task_view_packages_ctv(url)
    return(packages)
  }

  task_view <- ctv::read.ctv(url)
  task_view[["packagelist"]][["name"]]
}

#' Import a vector of package names from a (legacy) xml-format "Task View" page
#'
#' The old format of task-views used a ".ctv" file format, that was xml based.
#'
#' @param   url   A filepath or URL pointing to a .ctv file
#' @return   Character vector of package names

import_task_view_packages_ctv <- function(url) {
  xml <- xml2::read_xml(url)
  extract_package_names(xml)
}

#' Extract package names from the xml for a .ctv formatted file
#'
#' @param   xml   The xml content within a .ctv format file

extract_package_names <- function(xml) {
  # package names are each stored in a <pkg> tag on the task view page
  # and the list of <pkg> tags is stored in a <packagelist> tag

  # extract the package names
  package_nodes <- xml2::xml_find_all(xml, "packagelist/pkg")
  xml2::xml_text(package_nodes)
}
