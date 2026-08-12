-- dockerfile-language-server — https://github.com/rcjsuen/dockerfile-language-server-nodejs
--
--     npm install -g dockerfile-language-server-nodejs
return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile", ".git" },
}
