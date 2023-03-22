describe("run_gitsum_workflow on a repo with some commits", {
  # GIVEN: A git repository exists
  repo_path <- withr::local_tempdir(pattern = "repoPrefix")
  withr::local_dir(repo_path)
  dir.create("R")
  gert::git_init()
  gert::git_config_set("user.name", "Who Ever")
  gert::git_config_set("user.email", "who.ever@notreal.com")

  # AND: The repo contains a single-line commit
  first_file <- withr::local_tempfile(
    tmpdir = "R", pattern = "script", fileext = ".R", lines = "x = 123"
  )
  single_line_message <- "first commit"
  gert::git_add(first_file)
  gert::git_commit(message = single_line_message)

  # AND: The repo contains a multi-line commit
  second_file <- withr::local_tempfile(
    tmpdir = "R", pattern = "script", fileext = ".R", lines = "y = 234"
  )
  multi_line_message <- "second commit
    ---
    A really interesting commit, by the way"
  gert::git_add(second_file)
  gert::git_commit(message = multi_line_message)

  # WHEN: run_gitsum_workflow() is ran (creating a .tsv)
  results_file <- withr::local_tempfile(pattern = "gitsum", fileext = ".tsv")
  gitsum_results <- run_gitsum_workflow(".", results_file, "somePackage")

  it("returns a dataframe containing the commit messages", {
    # THEN: the results dataframe contains all the commit messages
    expect_equal(
      single_line_message, gitsum_results[["message"]][1]
    )
    expect_equal(
      multi_line_message, gitsum_results[["message"]][2]
    )
  })
  it("creates a .tsv that can be read back into R", {
    # THEN: the .tsv can be read into R, and contains the same content as before saving it
    results_from_file <- readr::read_tsv(results_file, col_types = readr::cols())
    expect_equal(
      single_line_message, results_from_file[["message"]][1]
    )
    expect_equal(
      multi_line_message, results_from_file[["message"]][2]
    )
  })
})

make_raw_gitsum_log <- function() {
  tibble::tibble(
    short_hash = "abc123",
    author_name = "Joe Bloggs",
    date = as.POSIXct("2023-03-22 01:30:00"),
    short_message = "New repo",
    hash = "abc123456fgh",
    left_parent = NA_character_,
    right_parent = NA_character_,
    author_email = "joe.blogs.data@blah.com",
    weekday = "Wed",
    month = "Mar",
    monthday = 22L,
    time = NA,
    year = 2023L,
    timezone = "+0000",
    message = "New repo",
    description = NA_character_,
    total_files_changed = 2L,
    total_insertions = 2L,
    total_deletions = 0L,
    commit_nr = 1L,
    short_description = NA_character_,
    is_merge = FALSE,
    nested = list(
      tibble::tibble(
        changed_file = c("README.md", "R/my-script.R"),
        edits = c(1L, 1L),
        insertions = c(1L, 1L),
        deletions = c(0L, 0L),
        is_exact = TRUE
      )
    )
  )
}

describe("format_gitsum_log", {
  gitsum_log <- make_raw_gitsum_log()

  it("restricts to R/ directory by default", {
    formatted_gitsum_results <- format_gitsum_log(gitsum_log, package = "thePackage")

    expect_true("R/my-script.R" %in% formatted_gitsum_results[["changed_file"]])
    expect_false("README.md" %in% formatted_gitsum_results[["changed_file"]])
  })

  it("includes files outwith R/ if requested", {
    formatted_gitsum_results <- format_gitsum_log(
      gitsum_log, package = "thePackage", r_dir_only = FALSE
    )

    expect_true("R/my-script.R" %in% formatted_gitsum_results[["changed_file"]])
    expect_true("README.md" %in% formatted_gitsum_results[["changed_file"]])
  })

  it("adds the package name to the gitsum table", {
    formatted_gitsum_results <- format_gitsum_log(gitsum_log, package = "thePackage")

    expect_equal(formatted_gitsum_results[["package"]], "thePackage")
  })
})
