xml_string <- r"(<CRANTaskView>
  <packagelist>
    <pkg priority="core">devtools</pkg>
    <pkg priority="core">knitr</pkg>
    <pkg priority="core">roxygen2</pkg>
    <pkg>aoos</pkg>
    <pkg>aprof</pkg>
  </packagelist>
  </CRANTaskView>)"

xml <- xml2::read_xml(xml_string)
packages <- c("devtools", "knitr", "roxygen2", "aoos", "aprof")

describe("import_task_view_packages", {
  it("Extracts package names from .ctv xml file", {
    tempfile <- withr::local_tempfile()
    xml2::write_xml(xml, tempfile)

    expect_equal(
      import_task_view_packages(tempfile),
      packages
    )
  })
})

describe("extract_package_names", {
  it("Extracts package names from .ctv xml content", {
    expect_equal(
      extract_package_names(xml),
      packages
    )
  })
})
