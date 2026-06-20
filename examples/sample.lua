-- A sample Lua file for the nxvim-lspconfig demo. Open it with lua-language-server
-- installed and try the LSP keys: `K` (hover), `gd` (go to definition), `grn`
-- (rename), `gra` (code action), `<leader>lf` (format).

local function greet(name)
  return "hello, " .. name
end

local function add(a, b)
  return a + b
end

local message = greet("nxvim")
local total = add(2, 3)

print(message, total)

return {
  greet = greet,
  add = add,
}
