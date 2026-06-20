-- nxvim `nx.lsp.enable("yamlls")` preset — resolved off the runtimepath by nx.lsp's
-- bundled-preset reader (`lsp/<name>.lua`). The canonical config table lives in
-- `lua/nxvim-lspconfig/servers/yamlls.lua` so it is also `require`-able and testable.
return require("nxvim-lspconfig.servers.yamlls")
