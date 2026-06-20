-- marksman — https://github.com/artempyanykh/marksman
--
-- A Markdown LSP: completion, cross-references, diagnostics. Distributed as a
-- self-contained binary per OS (download from the releases page).
return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
