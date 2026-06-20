-- intelephense — https://github.com/bmewburn/vscode-intelephense
--
--     npm install -g intelephense
--
-- A PHP language server. A licence key (set via `settings.intelephense.licenceKey`)
-- unlocks the premium features; the core server works without one.
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
  settings = {
    intelephense = {
      telemetry = { enabled = false },
    },
  },
}
