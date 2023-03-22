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
#' @importFrom   rlang   .data .env
#' @export

run_gitsum_workflow <- function(repo_path, output_path, package, r_dir_only = TRUE) {
  gitsum::init_gitsum(repo_path, over_write = TRUE)

  gitsum_log <- gitsum::parse_log_detailed(repo_path)
  gitsum_results <- format_gitsum_log(gitsum_log, package = package, r_dir_only = r_dir_only)

  readr::write_tsv(gitsum_results, output_path, quote = "needed")
}

format_gitsum_log <- function(x, package, r_dir_only = TRUE) {
  unnested <- gitsum::set_changed_file_to_latest_name(
    gitsum::unnest_log(x)
  )

  if (r_dir_only) {
    unnested <- dplyr::filter(
      unnested,
      stringr::str_starts(.data[["changed_file"]], "R/")
    )
  }

  tibble::add_column(unnested, package = .env[["package"]], .before = 1)
}
