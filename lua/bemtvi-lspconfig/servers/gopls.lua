-- gopls — https://github.com/golang/tools/tree/master/gopls
--
--     go install golang.org/x/tools/gopls@latest
--
-- Settings reference: https://go.dev/gopls/settings
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      semanticTokens = true,
    },
  },
}
