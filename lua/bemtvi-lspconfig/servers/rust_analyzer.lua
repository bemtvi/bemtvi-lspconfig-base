-- rust-analyzer — https://github.com/rust-lang/rust-analyzer
--
-- Install with `rustup component add rust-analyzer`, or grab a release binary. See
-- https://rust-analyzer.github.io/book/configuration.html for the full settings.
--
-- rust-analyzer reads its configuration both from the pulled `workspace/configuration`
-- (`settings["rust-analyzer"]`) and from `initializationOptions`; we mirror the same
-- table into both so the server is configured no matter which path it takes.
local opts = {
  cargo = { buildScripts = { enable = true } },
  procMacro = { enable = true },
  lens = {
    enable = true,
    run = { enable = true },
    implementations = { enable = true },
  },
}

return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  settings = { ["rust-analyzer"] = opts },
  init_options = opts,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
}
