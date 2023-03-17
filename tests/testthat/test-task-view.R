xml_testdata <- list(
  string = r"(<CRANTaskView>
  <name>PackageDevelopment</name>
  <topic>Package Development</topic>
  <maintainer email="thosjleeper@gmail.com">Thomas J. Leeper</maintainer>
  <version>2018-07-31</version>
  <info>
  </info>
  <packagelist>
    <pkg priority="core">devtools</pkg>
    <pkg priority="core">knitr</pkg>
    <pkg priority="core">roxygen2</pkg>
    <pkg>aoos</pkg>
    <pkg>aprof</pkg>
  </packagelist>
  <links>
  </links>
  </CRANTaskView>)",
  packages = c("aoos", "aprof", "devtools", "knitr", "roxygen2")
)
xml_testdata$xml <- xml2::read_xml(xml_testdata$string)

md_testdata <- list(
  string = r"(---
name: Bayesian
topic: Bayesian Inference
output: pdf_document
---

## CRAN Task View: Bayesian Inference

Blah blah Bayes

### General Purpose Model-Fitting Packages

-   The `r pkg("arm", priority = "core")` package contains R
functions for Bayesian inference using lm, glm, mer and etc.
-   `r pkg("BayesianTools")` is an R package for
general-purpose MCMC and SMC samplers, as well as plot and etc
)",
  packages = c("arm", "BayesianTools")
)

describe("import_task_view_packages", {
  it("Extracts package names from .ctv xml file", {
    tempfile <- withr::local_tempfile(fileext = ".ctv")
    xml2::write_xml(xml_testdata$xml, tempfile)

    expect_equal(
      import_task_view_packages(tempfile),
      xml_testdata$packages
    )
  })

  it("Extracts package names from task-view markdown file", {
    tempfile <- withr::local_tempfile(fileext = ".md")
    cat(md_testdata$string, file = tempfile)

    expect_equal(
      import_task_view_packages(tempfile),
      md_testdata$packages
    )
  })
})
