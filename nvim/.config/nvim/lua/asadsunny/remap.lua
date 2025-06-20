vim.g.mapleader = " "
vim.keymap.set("n", "-", ":Oil<CR>")

vim.highlight.on_yank({
    higroup = "YankHighlight", -- The highlight group to use
    timeout = 150,          -- How long the highlight stays (in ms)
})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- puts cursor in the center during scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<C-f>", "<C-f>zz") -- Make full-page scroll a jump
vim.keymap.set("n", "<C-b>", "<Nop>")
vim.keymap.set("c", "<C-b>", "<Nop>")

-- switch back to previous buffer
vim.keymap.set("n", "<leader>bb", ":b#<CR>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')

vim.keymap.set("n", "<leader>s", ":w<CR>")

vim.keymap.set("n", "<leader>wq", ":wq<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>1", ":q!<CR>")

vim.keymap.set("n", "G", "Gzz")

-- kickstart configurations (thanks teej!)

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_set_keymap(
    "n",
    "<leader>n",
    ":lua vim.cmd('edit ' .. vim.fn.expand('%:p:h') .. '/' .. vim.fn.input('New file name: '))<CR>",
    { noremap = true, silent = true }
)
-- vim.api.nvim_set_keymap("i", "<Esc>[80kb", "<C-W>", { noremap = true, silent = true })
--
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.setqflist()
    vim.cmd("copen")
end, { desc = "Show all diagnostics in quickfix list" })

vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

vim.api.nvim_set_keymap(
    "n",                                   -- Mode: 'n' for normal mode
    "<leader>rt",                          -- The actual key combination (e.g., <space>rt or \rt)
    ":ShellRunWin<CR>",                    -- The command to execute (calls your custom command)
    {
        noremap = true,                    -- Prevents remapping (recommended)
        silent = true,                     -- Prevents the command from echoing at the bottom
        desc = "Run command in new tmux window", -- A description for `:h mapleader` and tools like `which-key.nvim`
    }
)

vim.api.nvim_set_keymap(
    "n",                                 -- Mode: 'n' for normal mode
    "<leader>rh",                        -- The actual key combination (e.g., <space>rt or \rt)
    ":ShellRunPane<CR>",                 -- The command to execute (calls your custom command)
    {
        noremap = true,                  -- Prevents remapping (recommended)
        silent = true,                   -- Prevents the command from echoing at the bottom
        desc = "Run command in new tmux pane", -- A description for `:h mapleader` and tools like `which-key.nvim`
    }
)

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
