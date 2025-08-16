vim.api.nvim_set_keymap("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w><c-h>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w><c-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w><c-j>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w><c-l>", { noremap = true, silent = true })

-- 画面分割
vim.api.nvim_set_keymap("n", "<leader>,", ":split<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>.", ":vsplit<CR>", { noremap = true, silent = true })

-- ターミナル
vim.api.nvim_set_keymap("n", "<leader>t", ":split | terminal<CR>", { noremap = true, silent = true })

-- ターミナルを開いた時に自動でインサートモードに入る
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert"
})
