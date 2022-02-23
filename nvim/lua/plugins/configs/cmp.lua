local ok, cmp = pcall(require, 'cmp')
local present, luasnip = pcall(require, 'luasnip')
if not (ok and present) then
    return
end

cmp.setup {
   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },
   formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
         local icons = require 'plugins.configs.lspkind_icons'
         vim_item.kind = string.format('%s', icons[vim_item.kind])

         vim_item.menu = ({
            luasnip = '[Snip]',
            buffer = '[Buf]',
            path = '[Path]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[Lua]',
         })[entry.source.name]

         return vim_item
      end,
   },
   mapping = {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
         behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      },
      ['<Tab>'] = function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif luasnip.expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
         else
            fallback()
         end
      end,
      ['<S-Tab>'] = function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif luasnip.jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
         else
            fallback()
         end
      end,
   },
   sources = {
      { name = 'nvim_lsp' --[[, max_item_count = 10]] },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
   },
   experimental = {
     ghost_text = true
   }
}
