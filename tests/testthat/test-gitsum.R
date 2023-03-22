describe("run_gitsum_workflow on a repo with some commits", {
  # GIVEN: A git repository exists
  repo_path <- withr::local_tempdir(pattern = "repoPrefix")
  withr::local_dir(repo_path)
  dir.create("R")
  gert::git_init()

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
