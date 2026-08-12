-- vscode-eslint-language-server — https://github.com/hrsh7th/vscode-langservers-extracted
--
--     npm i -g vscode-langservers-extracted
--
-- A linting engine for JavaScript / TypeScript. Set up an ESLint config in your
-- project (`.eslintrc*` or flat `eslint.config.*`) for it to do anything.
return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "package.json",
    ".git",
  },
  -- See https://github.com/Microsoft/vscode-eslint#settings-options.
  settings = {
    validate = "on",
    useESLintClass = false,
    experimental = {},
    codeActionOnSave = { enable = false, mode = "all" },
    format = true,
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onType",
    problems = { shortenToSingleLine = false },
    nodePath = "",
    workingDirectory = { mode = "auto" },
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
  },
}
