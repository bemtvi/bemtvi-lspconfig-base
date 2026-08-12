-- A sample Lua module for the bemtvi-lspconfig demo. Open it with
-- lua-language-server installed and try the LSP keys — each is meaningful here:
--
--   K            hover — rest on `Account`, `balance`, or `deposit` for the
--                annotated types and doc comments below
--   gd           go to definition — on a call like `Account.new(...)`
--   grr          references — on `balance`, jump through every use in the file
--   grn          rename — rename `balance`; watch every reference update
--   gra          code action — offered on a diagnostic (try deleting a `return`)
--   gO           document symbols — an outline of this file
--   <leader>lf   format the buffer
--   <leader>lh   toggle inlay hints (inline parameter + type hints)
--
-- The LuaCATS annotations (---@class, ---@param, ---@return) are what make the
-- hovers and inlay hints rich — lua_ls reads them directly.

---@class Account
---@field owner string   name of the account holder
---@field balance number current balance
local Account = {}
Account.__index = Account

--- Open a new account with a starting balance.
---@param owner string    name of the account holder
---@param opening number  starting balance
---@return Account
function Account.new(owner, opening)
  return setmetatable({ owner = owner, balance = opening }, Account)
end

--- Add funds to the account.
---@param amount number
---@return number balance the updated balance
function Account:deposit(amount)
  self.balance = self.balance + amount
  return self.balance
end

--- Remove funds, erroring if they exceed the balance.
---@param amount number
---@return number balance the updated balance
function Account:withdraw(amount)
  assert(amount <= self.balance, "insufficient funds")
  self.balance = self.balance - amount
  return self.balance
end

--- A free function (not a method) so `gd` jumps somewhere different than the
--- `Account:` methods above.
---@param account Account
---@return string
local function describe(account)
  return string.format("%s: %d", account.owner, account.balance)
end

-- A short script exercising the type above. Hover any local (`K`) to see the
-- type lua_ls infers; toggle inlay hints (`<leader>lh`) to see the parameter
-- names and inferred types rendered inline.
local acct = Account.new("bemtvi", 100)
acct:deposit(50)
acct:withdraw(30)

print(describe(acct))

return {
  Account = Account,
  describe = describe,
}
