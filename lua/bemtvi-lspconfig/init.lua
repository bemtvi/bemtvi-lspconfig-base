-- bemtvi-lspconfig — ready-made btv.lsp configs for the most-used language servers.
--
-- A native port of nvim-lspconfig: one curated config table per server (cmd /
-- filetypes / root markers / sensible default settings), driven onto bemtvi's own
-- `btv.lsp` control surface. There is no neovim compatibility layer here — each
-- server ships as data the engine's bundled-preset reader already understands.
--
-- Two ways to use it:
--
--   1. The native path — bemtvi's `btv.lsp` reads each server's preset straight off
--      this plugin's runtimepath (`lsp/<name>.lua`), so once it is installed you can
--      just:
--
--          btv.lsp.enable("rust_analyzer")
--          btv.lsp.config("rust_analyzer", { settings = { … } })  -- to override
--
--   2. The convenience path — `setup()` enables a batch of servers, applies global
--      `capabilities` / `on_attach`, installs a default keymap set, and lets you
--      override any server inline:
--
--          require("bemtvi-lspconfig").setup({
--            servers = {
--              "lua_ls", "pyright", "gopls",
--              rust_analyzer = { settings = { ["rust-analyzer"] = { … } } },
--            },
--          })
--
-- It builds entirely on the documented `btv.lsp.*` API (config/enable, the language
-- verbs, the inlay-hint toggle) — nothing blocks, nothing is intercepted.

local M = {}

-- Every server this plugin bundles a preset for (one `servers/<name>.lua` data
-- table + one `lsp/<name>.lua` re-export each). Sorted; used for validation, the
-- `"all"` shortcut, and the docs.
M.servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "intelephense",
  "jsonls",
  "lemminx",
  "lua_ls",
  "marksman",
  "omnisharp",
  "pyright",
  "ruby_lsp",
  "rust_analyzer",
  "tailwindcss",
  "taplo",
  "terraformls",
  "ts_ls",
  "vimls",
  "yamlls",
}

-- The bundled set, as a lookup, so an unknown name fails loud instead of silently
-- enabling nothing.
local KNOWN = {}
for _, n in ipairs(M.servers) do
  KNOWN[n] = true
end

-- The last opts passed to setup(), for introspection / tests. nil until setup runs.
M.config = nil

-- ----- the default keymaps ---------------------------------------------------
-- bemtvi already installs the core LSP maps buffer-local on attach (gd / gD / gr /
-- K / <C-k>). This adds the rest of the now-standard set on top, at the OVERRIDABLE
-- rung (`default = true`) so a user's own map for the same key always wins. Opt out
-- of the whole set with `setup({ keymaps = false })`.
local DEFAULT_KEYMAPS = {
  { "n", "grn", btv.lsp.rename, "LSP rename" },
  { "n", "gra", btv.lsp.code_action, "LSP code action" },
  { "n", "grr", btv.lsp.references, "LSP references" },
  { "n", "gri", btv.lsp.implementation, "LSP implementation" },
  { "n", "grt", btv.lsp.type_definition, "LSP type definition" },
  { "n", "gO", btv.lsp.document_symbol, "LSP document symbols" },
  { "n", "<leader>ls", btv.lsp.workspace_symbol, "LSP workspace symbols" },
  { "n", "<leader>lf", btv.lsp.format, "LSP format buffer" },
}

local function install_default_keymaps(bufnr)
  for _, m in ipairs(DEFAULT_KEYMAPS) do
    btv.keymap.set(m[1], m[2], m[3], { buffer = bufnr, default = true, desc = m[4] })
  end
end

-- Flip inlay hints for a buffer (the RHS of the `<leader>lh` toggle).
local function toggle_inlay_hints()
  local on = btv.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  btv.lsp.inlay_hint.enable(not on, { bufnr = 0 })
end

-- ----- the "*" all-clients layer --------------------------------------------

-- Compose the global `on_attach`: default keymaps (unless opted out), the
-- inlay-hint toggle map + initial enable (when asked), then the user's own
-- on_attach. Returns nil when there is nothing to do, so we don't register an
-- empty hook.
local function build_on_attach(opts)
  local want_keymaps = opts.keymaps ~= false
  local want_inlay = opts.inlay_hints == true
  local user = opts.on_attach
  if not (want_keymaps or want_inlay or user) then
    return nil
  end
  return function(client, bufnr)
    if want_keymaps then
      install_default_keymaps(bufnr)
      btv.keymap.set("n", "<leader>lh", toggle_inlay_hints, {
        buffer = bufnr,
        default = true,
        desc = "LSP toggle inlay hints",
      })
    end
    -- Turn inlay hints on for servers that provide them (opt-in via setup).
    if want_inlay and client.server_capabilities and client.server_capabilities.inlay_hints then
      btv.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    if user then
      user(client, bufnr)
    end
  end
end

-- Apply the global "*" override layer (inherited by every server): broadcast
-- capabilities, extra root markers, shared settings, and the composed on_attach.
local function apply_global(opts)
  local star = {}
  if opts.capabilities ~= nil then
    star.capabilities = opts.capabilities
  end
  if opts.root_markers ~= nil then
    star.root_markers = opts.root_markers
  end
  if opts.settings ~= nil then
    star.settings = opts.settings
  end
  local on_attach = build_on_attach(opts)
  if on_attach then
    star.on_attach = on_attach
  end
  if next(star) ~= nil then
    btv.lsp.config("*", star)
  end
end

-- ----- per-server registration ----------------------------------------------

-- Register one server's bundled preset (deep-merged with the user's override) into
-- btv.lsp's config registry. An unknown name fails loud — the whole point of this
-- plugin is its curated set, so a typo is a mistake, not a silent no-op.
local function register(name, override)
  if not KNOWN[name] then
    error(
      "bemtvi-lspconfig: unknown server '" .. tostring(name) .. "'. Bundled servers: " .. table.concat(M.servers, ", "),
      2
    )
  end
  local base = require("bemtvi-lspconfig.servers." .. name)
  btv.lsp.config(name, vim.tbl_deep_extend("force", base, override or {}))
end

-- Walk a `servers` value, calling fn(name, override) for each server to enable.
-- Accepts:
--   "all"                              every bundled server
--   { "lua_ls", "pyright" }            a list of names (no overrides)
--   { lua_ls = { settings = … } }      a map of name -> override table
--   { "gopls", eslint = false }        mixed; `false` value skips that server
local function each_server(servers, fn)
  if type(servers) == "string" then
    if servers == "all" then
      for _, n in ipairs(M.servers) do
        fn(n, nil)
      end
    else
      fn(servers, nil) -- a single server name
    end
    return
  end
  if type(servers) ~= "table" then
    error('bemtvi-lspconfig: `servers` must be a name, a list, a map, or "all"', 2)
  end
  for k, v in pairs(servers) do
    if type(k) == "number" then
      fn(v, nil)
    elseif v ~= false then
      fn(k, type(v) == "table" and v or nil)
    end
  end
end

-- ----- public API ------------------------------------------------------------

-- M.enable(servers) — register and enable a batch of servers (see each_server for
-- the accepted shapes). Idempotent and additive: call it as many times as you like.
function M.enable(servers)
  local names = {}
  each_server(servers, function(name, override)
    register(name, override)
    names[#names + 1] = name
  end)
  if #names > 0 then
    btv.lsp.enable(names)
  end
  return M
end

-- M.setup(opts) — the one-call entry point.
--   opts.servers       "all" | list of names | map name -> (override-table | false)
--   opts.capabilities  client capabilities broadcast to every server ("*")
--   opts.settings      settings merged into every server ("*")
--   opts.root_markers  extra root markers for every server ("*")
--   opts.on_attach     function(client, bufnr) run when any server attaches
--   opts.keymaps       install the default LSP keymaps? (default true)
--   opts.inlay_hints   turn inlay hints on for capable servers? (default false)
function M.setup(opts)
  opts = opts or {}
  if type(opts) ~= "table" then
    error("bemtvi-lspconfig.setup: opts must be a table", 2)
  end

  apply_global(opts)

  if opts.servers ~= nil then
    M.enable(opts.servers)
  end

  M.config = opts
  return M
end

return M
