# nxvim-lspconfig

Ready-made [`nx.lsp`](https://github.com/davidrios/nxvim) configurations for the
most widely-used language servers — a native port of
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for
[nxvim](https://github.com/davidrios/nxvim).

Each server ships as a curated config table (command, filetypes, root markers, and
sensible default settings) that nxvim's own `nx.lsp` control surface understands
directly. There is **no neovim compatibility layer** — the presets are plain data
driven onto the documented `nx.lsp.*` API, so nothing blocks and nothing is
intercepted.

> This plugin only *configures* servers; it does not install them. Install the
> language server binaries yourself (each server's section links the upstream
> instructions). A missing binary fails **loud** — nxvim never pretends a server
> that isn't there is working.

## Install

Declare it with the built-in `:Plugins` manager in your `init.lua`, then call
`setup()` with the servers you want:

```lua
nx.plugins({
  {
    "davidrios/nxvim-lspconfig",
    config = function()
      require("nxvim-lspconfig").setup({
        servers = { "lua_ls", "pyright", "gopls", "rust_analyzer" },
      })
    end,
  },
})
```

Run `:PluginSync` to clone it. Open a file of a matching type and, if its server is
installed, it attaches automatically.

## Usage

### `setup({ … })`

```lua
require("nxvim-lspconfig").setup({
  -- Which servers to enable. One of:
  --   "all"                              every bundled server
  --   { "lua_ls", "pyright" }            a list of names (bundled defaults)
  --   { lua_ls = { settings = … } }      a map of name -> overrides
  --   { "gopls", eslint = false }        mixed; `false` skips a server
  servers = { "lua_ls", "pyright" },

  -- Applied to every server (the "*" base layer):
  capabilities = {},        -- client capabilities to broadcast
  settings = {},            -- settings merged into every server
  root_markers = {},        -- extra project-root markers
  on_attach = function(client, bufnr) end,

  -- Convenience toggles:
  keymaps = true,           -- install the default LSP keymaps (below)
  inlay_hints = false,      -- enable inlay hints for servers that provide them
})
```

`setup()` is additive — call `require("nxvim-lspconfig").enable({ … })` later to
turn on more servers with the same accepted shapes.

### Overriding a server

Pass a table as the server's value to deep-merge your changes over the bundled
preset:

```lua
require("nxvim-lspconfig").setup({
  servers = {
    "lua_ls",
    gopls = {
      settings = { gopls = { gofumpt = true } },
    },
    rust_analyzer = {
      settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
    },
  },
})
```

### Without `setup()` — the native path

Because the presets live on the plugin's runtimepath as `lsp/<name>.lua`, nxvim's
`nx.lsp` finds them on its own. Once the plugin is installed you can skip `setup()`
entirely and use the engine API directly:

```lua
nx.lsp.config("rust_analyzer", {                     -- optional overrides
  settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
})
nx.lsp.enable("rust_analyzer")
```

## Keymaps

nxvim already installs the core LSP maps buffer-local when a server attaches:
`gd`, `gD`, `gr`, `K`, and `<C-k>` (insert). With `keymaps = true` (the default)
this plugin adds the rest of the now-standard set on top, at the overridable rung
so your own maps always win:

| Key          | Action                       |
| ------------ | ---------------------------- |
| `grn`        | rename                       |
| `gra`        | code action                  |
| `grr`        | references                   |
| `gri`        | implementation               |
| `grt`        | type definition              |
| `gO`         | document symbols             |
| `<leader>ls` | workspace symbols            |
| `<leader>lf` | format buffer                |
| `<leader>lh` | toggle inlay hints           |

Set `keymaps = false` to manage all of these yourself.

## Bundled servers

| Name            | Language(s)           | Binary / install                         |
| --------------- | --------------------- | ---------------------------------------- |
| `bashls`        | Bash, sh              | `npm i -g bash-language-server`          |
| `clangd`        | C, C++, ObjC, CUDA    | ships with LLVM/Clang                     |
| `cssls`         | CSS, SCSS, Less       | `npm i -g vscode-langservers-extracted`  |
| `dockerls`      | Dockerfile            | `npm i -g dockerfile-language-server-nodejs` |
| `eslint`        | JS/TS linting         | `npm i -g vscode-langservers-extracted`  |
| `gopls`         | Go                    | `go install golang.org/x/tools/gopls@latest` |
| `html`          | HTML                  | `npm i -g vscode-langservers-extracted`  |
| `intelephense`  | PHP                   | `npm i -g intelephense`                  |
| `jsonls`        | JSON, JSONC           | `npm i -g vscode-langservers-extracted`  |
| `lemminx`       | XML, XSD, XSL, SVG    | LemMinX binary / jar                      |
| `lua_ls`        | Lua                   | [lua-language-server](https://luals.github.io/#install) |
| `marksman`      | Markdown              | [marksman release](https://github.com/artempyanykh/marksman/releases) |
| `omnisharp`     | C#, VB                | [omnisharp-roslyn release](https://github.com/OmniSharp/omnisharp-roslyn/releases) |
| `pyright`       | Python                | `npm i -g pyright`                       |
| `ruby_lsp`      | Ruby, ERB             | `gem install ruby-lsp`                   |
| `rust_analyzer` | Rust                  | `rustup component add rust-analyzer`     |
| `tailwindcss`   | Tailwind CSS          | `npm i -g @tailwindcss/language-server`  |
| `taplo`         | TOML                  | `cargo install --features lsp taplo-cli` |
| `terraformls`   | Terraform             | [terraform-ls release](https://github.com/hashicorp/terraform-ls/releases) |
| `ts_ls`         | JavaScript/TypeScript | `npm i -g typescript typescript-language-server` |
| `vimls`         | Vimscript             | `npm i -g vim-language-server`           |
| `yamlls`        | YAML                  | `npm i -g yaml-language-server`          |

Don't see one you need? You can still point `nx.lsp.config` / `nx.lsp.enable` at any
server of your own — this plugin just bundles the common ones with good defaults.

## Trying it locally

This repo ships a runnable demo (enables `lua_ls` for a sample file):

```sh
NXVIM_CONFIG=examples cargo run -p nxvim -- examples/sample.lua
```

(run from a checkout next to your nxvim checkout, or point `dir=` at this repo —
see `examples/init.lua`). With `lua-language-server` installed: hover with `K`,
jump with `gd`, rename with `grn`.

## Tests

The suite is built on nxvim's native `nx.test` framework and is fully hermetic — it
validates every bundled preset's shape and the `setup()` registration logic without
spawning a real server. Run it headlessly:

```sh
nxvim --test-plugin .
```

## License

MIT © David Rios
