-- vscode-css-language-server — https://github.com/hrsh7th/vscode-langservers-extracted
--
--     npm i -g vscode-langservers-extracted
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
