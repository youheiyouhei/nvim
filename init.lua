require("plugins")

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.api.nvim_exec("highlight SignColumn ctermbg=black", false)

vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w><c-h>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w><c-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w><c-j>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w><c-l>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-n>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>")

vim.api.nvim_set_keymap(
	"n",
	"<leader>g",
	"<cmd>lua require('fzf-lua').git_files()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>r",
	"<cmd>lua require('fzf-lua').grep_project()<CR>",
	{ noremap = true, silent = true }
)

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, bufopts)
end

require("lspconfig")["tsserver"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
		})
	end,
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("snippy").expand_snippet(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "snippy" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "path" },
		{ name = "cmdline" },
	},
})

require("snippy").setup({
	mappings = {
		is = {
			["<Tab>"] = "expand_or_advance",
			["<S-Tab>"] = "previous",
		},
	},
})

require("nvim_comment").setup()
require("lualine").setup()
require("auto-save").setup({})
require("nvim-autopairs").setup({})
require("gitsigns").setup()
require("nvim-treesitter.configs").setup({
	ensure_installed = { "go", "lua", "gomod", "markdown", "sql", " typescript", "vue", "json", "javascript" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
})

vim.opt.completeopt = "menu,menuone,noselect"
