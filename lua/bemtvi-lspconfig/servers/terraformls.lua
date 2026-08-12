-- terraform-ls — https://github.com/hashicorp/terraform-ls
--
-- HashiCorp's Terraform language server. Download a released binary from
-- https://github.com/hashicorp/terraform-ls/releases.
return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
}
