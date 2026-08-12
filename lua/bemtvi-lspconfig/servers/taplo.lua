-- taplo — https://taplo.tamasfe.dev/cli/usage/language-server.html
--
--     cargo install --features lsp --locked taplo-cli
--
-- A TOML toolkit / language server.
return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { ".taplo.toml", "taplo.toml", ".git" },
}
