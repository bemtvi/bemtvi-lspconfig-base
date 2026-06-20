-- yaml-language-server — https://github.com/redhat-developer/yaml-language-server
--
--     npm i -g yaml-language-server
--
-- Attach a schema with a `# yaml-language-server: $schema=<url>` modeline, or via
-- `settings.yaml.schemas` (see the upstream README).
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      -- yaml-language-server disables formatting by default; turn it on.
      format = { enable = true },
      keyOrdering = false,
    },
  },
}
