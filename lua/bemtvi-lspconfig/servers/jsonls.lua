-- vscode-json-language-server — https://github.com/hrsh7th/vscode-langservers-extracted
--
--     npm i -g vscode-langservers-extracted
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  init_options = { provideFormatter = true },
}
