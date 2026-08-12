-- bemtvi `btv.lsp.enable("clangd")` preset — resolved off the runtimepath by btv.lsp's
-- bundled-preset reader (`lsp/<name>.lua`). The canonical config table lives in
-- `lua/bemtvi-lspconfig/servers/clangd.lua` so it is also `require`-able and testable.
return require("bemtvi-lspconfig.servers.clangd")
