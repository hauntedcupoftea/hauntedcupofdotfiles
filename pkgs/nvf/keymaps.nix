{ ... }:
{
  vim.keymaps = [
    # ── Windows ──────────────────────────────────────────────────────────
    { key = "<C-h>"; mode = "n"; action = "<C-w>h"; desc = "Move left"; }
    { key = "<C-j>"; mode = "n"; action = "<C-w>j"; desc = "Move down"; }
    { key = "<C-k>"; mode = "n"; action = "<C-w>k"; desc = "Move up"; }
    { key = "<C-l>"; mode = "n"; action = "<C-w>l"; desc = "Move right"; }
    { key = "<leader>|"; mode = "n"; action = "<cmd>vsplit<cr>"; desc = "Split vertical"; }
    { key = "<leader>-"; mode = "n"; action = "<cmd>split<cr>"; desc = "Split horizontal"; }

    # ── File tree ─────────────────────────────────────────────────────────
    { key = "<leader>e";  mode = "n"; action = "<cmd>Neotree toggle<cr>";  desc = "File tree"; }
    { key = "<leader>E";  mode = "n"; action = "<cmd>Neotree reveal<cr>";  desc = "Reveal in tree"; }

    # ── Telescope ─────────────────────────────────────────────────────────
    { key = "<leader>ff"; mode = "n"; action = "<cmd>Telescope find_files<cr>";             desc = "Find files"; }
    { key = "<leader>fg"; mode = "n"; action = "<cmd>Telescope live_grep<cr>";              desc = "Live grep"; }
    { key = "<leader>fb"; mode = "n"; action = "<cmd>Telescope buffers<cr>";                desc = "Buffers"; }
    { key = "<leader>fr"; mode = "n"; action = "<cmd>Telescope oldfiles<cr>";               desc = "Recent files"; }
    { key = "<leader>fs"; mode = "n"; action = "<cmd>Telescope lsp_document_symbols<cr>";   desc = "Symbols (file)"; }
    { key = "<leader>fS"; mode = "n"; action = "<cmd>Telescope lsp_workspace_symbols<cr>";  desc = "Symbols (workspace)"; }
    { key = "<leader>fd"; mode = "n"; action = "<cmd>Telescope diagnostics<cr>";            desc = "Diagnostics"; }

    # ── LSP ───────────────────────────────────────────────────────────────
    { key = "gd";          mode = "n"; action = "<cmd>lua vim.lsp.buf.definition()<cr>";    desc = "Definition"; }
    { key = "gD";          mode = "n"; action = "<cmd>lua vim.lsp.buf.declaration()<cr>";   desc = "Declaration"; }
    { key = "gr";          mode = "n"; action = "<cmd>lua vim.lsp.buf.references()<cr>";    desc = "References"; }
    { key = "gi";          mode = "n"; action = "<cmd>lua vim.lsp.buf.implementation()<cr>"; desc = "Implementation"; }
    { key = "gt";          mode = "n"; action = "<cmd>lua vim.lsp.buf.type_definition()<cr>"; desc = "Type definition"; }
    { key = "K";           mode = "n"; action = "<cmd>lua vim.lsp.buf.hover()<cr>";         desc = "Hover docs"; }
    { key = "<leader>rn";  mode = "n"; action = "<cmd>lua vim.lsp.buf.rename()<cr>";        desc = "Rename symbol"; }
    { key = "<leader>ca";  mode = "n"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>";   desc = "Code action"; }
    { key = "<leader>ca";  mode = "v"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>";   desc = "Code action (sel)"; }
    { key = "<leader>ns";  mode = "n"; action = "<cmd>Navbuddy<cr>";                        desc = "Navigate symbols"; }
    { key = "<leader>ih";  mode = "n"; action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>"; desc = "Toggle inlay hints"; }

    # ── Diagnostics ───────────────────────────────────────────────────────
    { key = "<leader>xx"; mode = "n"; action = "<cmd>Trouble diagnostics toggle<cr>";                   desc = "Diagnostics panel"; }
    { key = "<leader>xb"; mode = "n"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";      desc = "Buffer diagnostics"; }
    { key = "]d";         mode = "n"; action = "<cmd>lua vim.diagnostic.goto_next()<cr>";               desc = "Next diagnostic"; }
    { key = "[d";         mode = "n"; action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";               desc = "Prev diagnostic"; }

    # ── Folds (nvim-ufo) ──────────────────────────────────────────────────
    { key = "zR"; mode = "n"; action = "<cmd>lua require('ufo').openAllFolds()<cr>";                    desc = "Open all folds"; }
    { key = "zM"; mode = "n"; action = "<cmd>lua require('ufo').closeAllFolds()<cr>";                   desc = "Close all folds"; }
    { key = "zp"; mode = "n"; action = "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<cr>";      desc = "Peek fold"; }

    # ── Refactoring ───────────────────────────────────────────────────────
    { key = "<leader>rf"; mode = "v"; action = "<cmd>lua require('refactoring').refactor('Extract Function')<cr>"; desc = "Extract function"; }
    { key = "<leader>rv"; mode = "v"; action = "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>"; desc = "Extract variable"; }
    { key = "<leader>ri"; mode = "n"; action = "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>";  desc = "Inline variable"; }

    # ── Git hunks ─────────────────────────────────────────────────────────
    { key = "]h";          mode = "n"; action = "<cmd>Gitsigns next_hunk<cr>";    desc = "Next hunk"; }
    { key = "[h";          mode = "n"; action = "<cmd>Gitsigns prev_hunk<cr>";    desc = "Prev hunk"; }
    { key = "<leader>gs";  mode = "n"; action = "<cmd>Gitsigns stage_hunk<cr>";   desc = "Stage hunk"; }
    { key = "<leader>gr";  mode = "n"; action = "<cmd>Gitsigns reset_hunk<cr>";   desc = "Reset hunk"; }
    { key = "<leader>gp";  mode = "n"; action = "<cmd>Gitsigns preview_hunk<cr>"; desc = "Preview hunk"; }
    { key = "<leader>gb";  mode = "n"; action = "<cmd>Gitsigns blame_line<cr>";   desc = "Blame line"; }

    # ── Buffers ───────────────────────────────────────────────────────────
    { key = "<leader>bd"; mode = "n"; action = "<cmd>bd<cr>";      desc = "Close buffer"; }
    { key = "<Tab>";      mode = "n"; action = "<cmd>bnext<cr>";   desc = "Next buffer"; }
    { key = "<S-Tab>";    mode = "n"; action = "<cmd>bprev<cr>";   desc = "Prev buffer"; }
  ];
}
