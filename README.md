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
> language server binaries yourself. A missing binary fails **loud** — nxvim never
> pretends a server that isn't there is working.

## Install

Declare it with the built-in `:Plugins` manager, then call `setup()` with the servers
you want, and `:PluginSync`:

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

Open a file of a matching type and, if its server is installed, it attaches
automatically. `servers` accepts `"all"`, a list of names, a `name -> overrides` map,
or a mix (`false` skips a server). Or skip `setup()` and drive `nx.lsp.config` /
`nx.lsp.enable` directly — the presets are on the runtimepath as `lsp/<name>.lua`.

## Documentation

Full docs — `setup()` and its options, `enable()`, overriding a server, the native
`nx.lsp` path, the default keymaps, and the full bundled-server list with install
commands — live in the help file. The same source renders both on GitHub and in the
editor:

- In editor: `:help nxvim-lspconfig`
- On GitHub: [doc/nxvim-lspconfig.md](./doc/nxvim-lspconfig.md) (the help source)

## Trying it locally

This repo ships a runnable demo (enables `lua_ls` for a sample file):

```sh
NXVIM_CONFIG=examples nxvim examples/sample.lua
```

(run from a checkout of this repo). With `lua-language-server` installed: hover with
`K`, jump with `gd`, rename with `grn`.

## Development

The suite is built on nxvim's native `nx.test` framework and is fully hermetic — it
validates every bundled preset's shape and the `setup()` registration logic without
spawning a real server:

```sh
nxvim --test-plugin .
```

The vimdoc `doc/nxvim-lspconfig.txt` is **generated** from `doc/nxvim-lspconfig.md` via
[panvimdoc](https://github.com/kdheepak/panvimdoc): edit the `.md`, then run
`bash scripts/gen-vimdoc.sh` (needs `pandoc` + `git`). Never edit the `.txt` by hand.

## License

MIT © David Rios
