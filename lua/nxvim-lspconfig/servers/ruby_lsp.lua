-- ruby-lsp — https://github.com/Shopify/ruby-lsp
--
--     gem install ruby-lsp
return {
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = "auto",
  },
}
