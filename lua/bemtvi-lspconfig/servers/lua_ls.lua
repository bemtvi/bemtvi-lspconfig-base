-- lua-language-server — https://github.com/luals/lua-language-server
--
-- Install: https://luals.github.io/#install (the `lua-language-server` binary must
-- be on $PATH). The default `cmd` assumes that.
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".emmyrc.json",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
    },
  },
}
