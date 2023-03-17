describe("extract_package_names", {
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

  it("Extracts package names from .ctv xml content", {
    expect_equal(
      extract_package_names(xml),
      c("devtools", "knitr", "roxygen2", "aoos", "aprof")
    )
  })
})
