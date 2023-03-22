#' Run gitsum on an R package repository and store the results in a .tsv
#'
#' @param   repo_path   Scalar character. Filepath to a git repository for the R package under
#'   analysis.
#' @param   output_path   Scalar character. Filepath for storing the gitsum results as a `.tsv`.
#' @param   package   Scalar character. The name of the package that is being analysed.
#' @param   r_dir_only   Scalar logical. Should we restrict analysis to the `R/` source code
#'   directory (default: TRUE)?
#'
#' @return   tibble containing gitsum results for the repo (invisibly). This function is mainly
#'   called to set up a .tsv as a side-effect.
#'
#' @importFrom   rlang   .data
#' @export

run_gitsum_workflow <- function(repo_path, output_path, package, r_dir_only = TRUE) {
  gitsum_results <- get_gitsum_results(repo_path, .package = package)

  readr::write_tsv(gitsum_results, output_path)
}

get_gitsum_results <- function(path, .package) {
  gitsum::init_gitsum(path, over_write = TRUE)

  gitsum::parse_log_detailed(path) |>
    gitsum::unnest_log() |>
    gitsum::set_changed_file_to_latest_name() |>
    dplyr::filter(stringr::str_starts(.data[["changed_file"]], "R/")) |>
    tibble::add_column(package = .package, .before = 1)
}
