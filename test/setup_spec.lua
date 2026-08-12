-- setup() / enable() registration logic, asserted against btv.lsp's config registry.
-- Hermetic: no real language server is spawned (test mode has no LSP transport) — we
-- only check that the right config layers were accumulated and marked enabled.

local lspconfig = require("bemtvi-lspconfig")

-- Wipe the engine's LSP registry so each test starts clean (these are the same
-- tables btv.lsp accumulates into; see crates/bemtvi-lua/src/prelude/lsp.lua).
local function reset()
  btv.lsp._config = {}
  btv.lsp._enabled = {}
end

btv.test.describe("bemtvi-lspconfig.setup", function()
  btv.test.before_each(reset)

  btv.test.it("enables a list of servers with their bundled cmd", function()
    lspconfig.setup({ servers = { "lua_ls", "bashls" } })
    btv.test.expect(btv.lsp._enabled["lua_ls"]).to_be(true)
    btv.test.expect(btv.lsp._enabled["bashls"]).to_be(true)
    -- The bundled preset is registered, so the engine knows how to spawn it.
    btv.test.expect(btv.lsp._config["lua_ls"].cmd[1]).to_be("lua-language-server")
  end)

  btv.test.it("merges a per-server override over the bundled preset", function()
    lspconfig.setup({
      servers = {
        lua_ls = { settings = { Lua = { diagnostics = { globals = { "btv" } } } } },
      },
    })
    local cfg = btv.lsp._config["lua_ls"]
    -- override applied…
    btv.test.expect(cfg.settings.Lua.diagnostics.globals[1]).to_be("btv")
    -- …and the bundled defaults are still there (deep merge, not replace).
    btv.test.expect(cfg.settings.Lua.hint.enable).to_be(true)
    btv.test.expect(btv.lsp._enabled["lua_ls"]).to_be(true)
  end)

  btv.test.it("skips a server whose map value is false", function()
    lspconfig.setup({ servers = { "gopls", eslint = false } })
    btv.test.expect(btv.lsp._enabled["gopls"]).to_be(true)
    btv.test.expect(btv.lsp._enabled["eslint"]).to_be_nil()
  end)

  btv.test.it('"all" enables every bundled server', function()
    lspconfig.setup({ servers = "all" })
    for _, name in ipairs(lspconfig.servers) do
      btv.test.expect(btv.lsp._enabled[name]).to_be(true)
    end
  end)

  btv.test.it("an unknown server fails loud", function()
    btv.test.expect(function()
      lspconfig.setup({ servers = { "nonexistent_ls" } })
    end).to_error("unknown server")
  end)

  btv.test.it("global capabilities + settings land on the '*' layer", function()
    lspconfig.setup({
      servers = { "lua_ls" },
      capabilities = { workspace = { configuration = true } },
      settings = { telemetry = { enable = false } },
    })
    btv.test.expect(btv.lsp._config["*"].capabilities.workspace.configuration).to_be(true)
    btv.test.expect(btv.lsp._config["*"].settings.telemetry.enable).to_be(false)
  end)

  btv.test.it("installs an on_attach on '*' when keymaps are on (the default)", function()
    lspconfig.setup({ servers = { "lua_ls" } })
    btv.test.expect(type(btv.lsp._config["*"].on_attach)).to_be("function")
  end)

  btv.test.it("installs no on_attach when keymaps are off and nothing else asks", function()
    lspconfig.setup({ servers = { "lua_ls" }, keymaps = false })
    btv.test.expect((btv.lsp._config["*"] or {}).on_attach).to_be_nil()
  end)

  btv.test.it("composes a user on_attach even with keymaps off", function()
    local ran = false
    lspconfig.setup({
      servers = { "lua_ls" },
      keymaps = false,
      on_attach = function()
        ran = true
      end,
    })
    local on_attach = btv.lsp._config["*"].on_attach
    btv.test.expect(type(on_attach)).to_be("function")
    -- Calling it runs the user hook (a fake client/bufnr is enough here).
    on_attach({ name = "lua_ls", server_capabilities = {} }, 0)
    btv.test.expect(ran).to_be_truthy()
  end)

  btv.test.it("M.enable adds servers incrementally", function()
    lspconfig.enable("marksman")
    btv.test.expect(btv.lsp._enabled["marksman"]).to_be(true)
    btv.test.expect(btv.lsp._config["marksman"].cmd[1]).to_be("marksman")
  end)
end)
