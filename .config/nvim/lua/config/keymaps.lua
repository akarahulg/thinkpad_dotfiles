-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- Add these mappings for coc.nvim completion
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<Tab>', [[coc#pum#visible() ? coc#pum#next(1) : coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('snippetNext', [])\<CR>" : "<Tab>"]], {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', [[coc#pum#visible() ? coc#pum#prev(1) : coc#jumpable(-1) ? "\<C-r>=coc#rpc#request('snippetPrev', [])\<CR>" : "<S-Tab>"]], {expr = true, noremap = true})

