-- Runnable demo for bemtvi-lspconfig — a guided tour of setup().
--
--     BEMTVI_CONFIG=examples bemtvi examples/sample.lua
--
-- Run it from a checkout of this repo. It enables lua-language-server for the
-- sample buffer — install that first (https://luals.github.io/#install). If the
-- binary isn't on $PATH the server start fails LOUD with a notification: bemtvi
-- never pretends a missing server works.
--
-- With lua_ls installed, open examples/sample.lua and try the LSP keys it
-- documents at the top of the file: K, gd, grr, grn, gra, gO, <leader>lf,
-- <leader>lh.

vim.g.mapleader = " "

-- Load the plugin straight from this repo (a local-dev spec: `dir` is never
-- cloned). A real config would declare `{ "bemtvi/bemtvi-lspconfig", config = … }`
-- and run `:PluginSync` — see the README's Install section.
btv.plugins({
  {
    name = "bemtvi-lspconfig",
    dir = vim.fn.expand("<sfile>:p:h:h"), -- the repo root (this file's grandparent dir)
    config = function()
      local lspconfig = require("bemtvi-lspconfig")

      lspconfig.setup({
        -- ----- which servers to turn on ------------------------------------
        -- `servers` accepts four shapes, and you can mix them in one table:
        --   "all"                       every bundled server
        --   { "lua_ls", "pyright" }     a list of bare names (bundled defaults)
        --   { lua_ls = { … } }          a map of name -> overrides (deep-merged)
        --   { eslint = false }          a `false` value skips that server
        servers = {
          -- Bare names take the bundled preset unchanged. These are wrong-
          -- filetype for the Lua sample, so they simply never attach here —
          -- enabling them costs nothing until you open a .py / .sh file.
          "pyright",
          "bashls",

          -- name = { … } deep-merges your overrides over the preset. This one
          -- lands on lua_ls — the server the demo actually runs — so you can see
          -- the effect: extra globals silence the "undefined global" diagnostic,
          -- and array-index inlay hints get turned on.
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = { globals = { "btv", "vim" } },
                hint = { enable = true, arrayIndex = "Enable" },
              },
            },
          },

          -- More servers you could add the same way — kept commented so the demo
          -- never asks for a binary you might not have installed:
          -- gopls = { settings = { gopls = { gofumpt = true } } },
          -- rust_analyzer = {
          --   settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
          -- },

          -- A `false` value explicitly skips a server — handy when you enable
          -- "all" but want to drop one.
          eslint = false,
        },

        -- ----- the global "*" layer (inherited by every server above) -------
        -- Broadcast capabilities, shared settings, and extra root markers apply
        -- to every enabled server. Capabilities normally come from your
        -- completion plugin; left empty here.
        capabilities = {},
        settings = {},
        root_markers = { ".git" },

        -- Runs whenever any server attaches to a buffer — a good hook for
        -- buffer-local maps or, here, a confirmation notification.
        on_attach = function(client, bufnr)
          btv.notify(("LSP attached: %s (buf %d)"):format(client.name, bufnr))
        end,

        -- ----- convenience toggles ------------------------------------------
        -- Install the default LSP keymaps (grn / gra / grr / gri / grt / gO /
        -- <leader>ls / <leader>lf / <leader>lh) on top of bemtvi's built-in
        -- gd / gD / gr / K / <C-k>. Set to false to manage maps yourself.
        keymaps = true,

        -- Turn inlay hints on for servers that provide them (lua_ls does). Toggle
        -- them per-buffer at runtime with <leader>lh.
        inlay_hints = true,
      })

      -- setup() is additive. Two more ways to reach for servers later:
      --
      --   • lspconfig.enable({ "jsonls", "yamlls" })  -- same shapes, no repeat
      --                                                  of the global layer
      --
      --   • the native path — skip setup() entirely and drive btv.lsp directly,
      --     since the presets already live on the runtimepath as lsp/<name>.lua:
      --
      --       btv.lsp.config("taplo", { … })   -- optional overrides
      --       btv.lsp.enable("taplo")
    end,
  },
})
