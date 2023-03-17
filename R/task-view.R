#' Import a vector of package names from a "Task View" page
#'
#' @param   url   A URL containing a Task View page.
#'
#' @export

import_task_view_packages <- function(url) {
  xml2::read_xml(url) %>%
    extract_package_names()
}

#' Extract package names from the xml for a .ctv formatted file
#'
#' @param   xml   The xml content within a .ctv format file

extract_package_names <- function(xml) {
  # package names are each stored in a <pkg> tag on the task view page
  # and the list of <pkg> tags is stored in a <packagelist> tag

  # extract the package names
  xml %>%
    xml2::xml_find_all("packagelist/pkg") %>%
    xml2::xml_text()
}
