-- lemminx — https://github.com/eclipse/lemminx
--
-- An XML language server (the one behind VS Code's "XML" extension). Distributed
-- as a binary / jar; the `lemminx` launcher must be on $PATH.
return {
  cmd = { "lemminx" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  root_markers = { ".git" },
}
