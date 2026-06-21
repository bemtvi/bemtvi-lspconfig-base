-- Runnable demo for nxvim-lspconfig.
--
--     NXVIM_CONFIG=examples nxvim examples/sample.lua
--
-- It enables lua-language-server for this buffer. Install it first
-- (https://luals.github.io/#install) — if the binary isn't on $PATH the server
-- start fails LOUD with a notification (nxvim never pretends a missing server
-- works). With it installed: hover with `K`, jump with `gd`, rename with `grn`,
-- code-action with `gra`, format with `<leader>lf`.

vim.g.mapleader = " "

-- Load the plugin straight from this repo (a local-dev spec: `dir` is never cloned).
-- A real config would use `{ "davidrios/nxvim-lspconfig", config = … }` + `:PluginSync`.
nx.plugins({
  {
    name = "nxvim-lspconfig",
    dir = vim.fn.expand("<sfile>:p:h:h"), -- the repo root (this file's grandparent dir)
    config = function()
      require("nxvim-lspconfig").setup({
        -- Enable a handful of servers. A bare name takes the bundled defaults; a
        -- name = { … } entry layers your overrides on top.
        servers = {
          "lua_ls",
          "pyright",
          "bashls",
          -- gopls = { settings = { gopls = { gofumpt = true } } },
        },
        -- Installs the default LSP keymaps (grn / gra / grr / gri / grt / gO /
        -- <leader>ls / <leader>lf / <leader>lh) on top of nxvim's built-in
        -- gd / gD / gr / K / <C-k>. Set to false to manage maps yourself.
        keymaps = true,
        -- Turn inlay hints on for servers that provide them.
        inlay_hints = true,
        on_attach = function(client, _bufnr)
          nx.notify("LSP attached: " .. client.name)
        end,
      })
    end,
  },
})
