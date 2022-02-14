
require('nvim-autopairs').setup { fast_wrap = {} }
cmp_autopairs = require('nvim-autopairs.completion.cmp')
require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done()

require('blankline').setup {
	indentLine_enabled = 1,
	char = "▏",
	filetype_exclude = {
		 "help",
		 "terminal",
		 "dashboard",
		 "packer",
		 "lspinfo",
		 "TelescopePrompt",
		 "TelescopeResults",
		 "nvchad_cheatsheet",
		 "lsp-installer",
		 "",
	},
	buftype_exclude = { "terminal" },
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
}

require('colorizer').setup('*', {
	RGB = true,
	RRGGBB = true,
	names = false,
	RRGGBBAA = false,
	rgb_fn = false,
	hsl_fn = false,
	css = false,
	css_fn = false,
	mode = "background",
})
vim.cmd "ColorizerReloadAllBuffers"

require('luasnip.loaders.from_vscode').load()
require('luasnip').config.set_config({
	history = true,
	updateevents = 'TextChanged,TextChangedI'
})

require('lsp_signature').setup {
	 bind = true,
	 doc_lines = 0,
	 floating_window = true,
	 fix_pos = true,
	 hint_enable = true,
	 hint_prefix = " ",
	 hint_scheme = "String",
	 hi_parameter = "Search",
	 max_height = 22,
	 max_width = 120,
	 handler_opts = {
			border = "single",
	 },
	 zindex = 200,
	 padding = "",
}

require('gitsigns').setup {
	 signs = {
			add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
			change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
			delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
			topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
			changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
	 },
}
