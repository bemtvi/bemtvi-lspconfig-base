-- clangd — https://clangd.llvm.org/installation.html
--
-- Ships with LLVM/Clang (>= 11 recommended). clangd relies on a JSON compilation
-- database (`compile_commands.json`); symlink it to your source-tree root if it
-- lives in a build directory.
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
  capabilities = {
    textDocument = { completion = { editsNearCursor = true } },
    offsetEncoding = { "utf-8", "utf-16" },
  },
}
