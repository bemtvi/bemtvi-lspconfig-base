-- omnisharp-roslyn — https://github.com/OmniSharp/omnisharp-roslyn
--
-- A C# language server. Download a release and put the `omnisharp` launcher on
-- $PATH (or point `cmd` at it). `-lsp` mode speaks LSP over stdio.
return {
  cmd = { "omnisharp", "-z", "--encoding", "utf-8", "--languageserver" },
  filetypes = { "cs", "vb" },
  root_markers = { "omnisharp.json", ".git" },
  capabilities = {
    workspace = {
      -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
      workspaceFolders = false,
    },
  },
  settings = {
    FormattingOptions = {
      -- Read code-style / naming / analyzer settings from .editorconfig.
      EnableEditorConfigSupport = true,
    },
    RoslynExtensionsOptions = {
      -- Show unimported types / extension methods in completion.
      EnableImportCompletion = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
}
