local ok, nvim_lsp = pcall(require, 'lspconfig')
local present, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not (ok and present) then
  return
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities,
  }
  if server.name == 'sumneko_lua' then
    local sumneko = { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
    opts = vim.tbl_deep_extend('force', sumneko, opts)
  end
    server:setup(opts)
end)

for key, icon in pairs({
  Error='',
  Hint='',
  Warn=''
}) do
  local hl = 'DiagnosticSign' .. key
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single',
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'single',
})
