-- bemtvi `btv.lsp.enable("vimls")` preset — resolved off the runtimepath by btv.lsp's
-- bundled-preset reader (`lsp/<name>.lua`). The canonical config table lives in
-- `lua/bemtvi-lspconfig/servers/vimls.lua` so it is also `require`-able and testable.
return require("bemtvi-lspconfig.servers.vimls")
