-- The bundled server presets. Pure (no editor state) — just require each table and
-- assert its shape. Run with `bemtvi --test-plugin .`.

local lspconfig = require("bemtvi-lspconfig")

-- A `cmd` is spawnable when it is a non-empty list of strings (or a builder fn).
local function valid_cmd(cmd)
  if type(cmd) == "function" then
    return true
  end
  if type(cmd) ~= "table" or #cmd == 0 then
    return false
  end
  for _, a in ipairs(cmd) do
    if type(a) ~= "string" then
      return false
    end
  end
  return true
end

btv.test.describe("bemtvi-lspconfig.servers", function()
  -- Every bundled server is a well-formed config table the engine can act on.
  for _, name in ipairs(lspconfig.servers) do
    btv.test.it("preset '" .. name .. "' is a usable config", function()
      local cfg = require("bemtvi-lspconfig.servers." .. name)
      btv.test.expect(type(cfg)).to_be("table")
      -- A spawnable cmd…
      btv.test.expect(valid_cmd(cfg.cmd)).to_be_truthy()
      -- …and a non-empty filetype list (what the FileType dispatcher matches on).
      btv.test.expect(type(cfg.filetypes)).to_be("table")
      btv.test.expect(#cfg.filetypes > 0).to_be_truthy()
    end)

    -- The native path: `lsp/<name>.lua` re-exports the very same table, so
    -- `btv.lsp.enable("<name>")` (with no setup()) resolves the identical preset.
    btv.test.it("preset '" .. name .. "' is mirrored by its lsp/ re-export", function()
      local files = btv.runtime_file("lsp/" .. name .. ".lua", false)
      btv.test.expect(files and files[1]).to_be_truthy()
    end)
  end

  -- A couple of concrete spot-checks so a careless edit to a marquee server trips a
  -- test rather than shipping silently.
  btv.test.it("lua_ls drives lua-language-server for lua files", function()
    local cfg = require("bemtvi-lspconfig.servers.lua_ls")
    btv.test.expect(cfg.cmd[1]).to_be("lua-language-server")
    btv.test.expect(vim.tbl_contains(cfg.filetypes, "lua")).to_be_truthy()
  end)

  btv.test.it("rust_analyzer points init_options and settings at the same table", function()
    local cfg = require("bemtvi-lspconfig.servers.rust_analyzer")
    btv.test.expect(cfg.cmd[1]).to_be("rust-analyzer")
    -- rust-analyzer needs its config in BOTH places; they must be the one table.
    btv.test.expect(cfg.init_options).to_be(cfg.settings["rust-analyzer"])
  end)

  btv.test.it("ts_ls covers the js/ts family", function()
    local cfg = require("bemtvi-lspconfig.servers.ts_ls")
    btv.test.expect(vim.tbl_contains(cfg.filetypes, "typescript")).to_be_truthy()
    btv.test.expect(vim.tbl_contains(cfg.filetypes, "typescriptreact")).to_be_truthy()
    btv.test.expect(vim.tbl_contains(cfg.filetypes, "javascript")).to_be_truthy()
  end)
end)
