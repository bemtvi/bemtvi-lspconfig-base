-- typescript-language-server — https://github.com/typescript-language-server/typescript-language-server
--
--     npm install -g typescript typescript-language-server
--
-- Add a `tsconfig.json` / `jsconfig.json` to your project root. The root is taken
-- from the nearest package-manager lockfile (monorepo-friendly), then `.git`.
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package-lock.json",
    "yarn.lock",
    "pnpm-lock.yaml",
    "bun.lock",
    "package.json",
    ".git",
  },
  init_options = { hostInfo = "nxvim" },
}
