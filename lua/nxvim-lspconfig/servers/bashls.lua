-- bash-language-server — https://github.com/bash-lsp/bash-language-server
--
--     npm i -g bash-language-server
return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh" },
  root_markers = { ".git" },
  settings = {
    bashIde = {
      -- Glob for the background cross-file analysis. The non-recursive default
      -- avoids scanning all of $HOME when editing e.g. ~/foo.sh.
      globPattern = "*@(.sh|.inc|.bash|.command)",
    },
  },
}
