local nvim_lsp = require 'lspconfig'
local compe = require 'compe'
local saga = require 'lspsaga'
local telescope = require 'telescope'
local telescope_actions = require 'telescope.actions'
local treesitter_configs = require 'nvim-treesitter.configs'

local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end
vim.lsp.handlers["textDocument/formatting"] = format_async

local on_attach = function(client, bufnr)
    local buf_map = vim.api.nvim_buf_set_keymap

    buf_map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
    buf_map(bufnr, 'n', "ge", "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", { silent = true })
    buf_map(bufnr, 'n', "gt", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", { silent = true })
    buf_map(bufnr, 'n', "gr", "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", { silent = true })
    buf_map(bufnr, 'n', "gj", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", { silent = true })
    buf_map(bufnr, 'n', "gw", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", { silent = true })
    buf_map(bufnr, 'n', "gs", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", { silent = true })
    buf_map(bufnr, 'n', "K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", { silent = true })

    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
        vim.api.nvim_command [[augroup END]]
  end
end

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = telescope_actions.close
      },
    },
  }
}

treesitter_configs.setup {
  ensure_installed = "maintained",
  indent = {
    enable = false,
    disable = {},
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
}

compe.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;
  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}

nvim_lsp.rust_analyzer.setup { on_attach = on_attach }

nvim_lsp.svelte.setup { on_attach = on_attach }

nvim_lsp.pyright.setup { on_attach = on_attach }

nvim_lsp.tailwindcss.setup { on_attach = on_attach }

local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}

local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}

local formatters = {
    prettier = {
        command = 'node_modules/.bin/prettier',
        args = {  '--stdin-filepath', '%filepath' },
        rootPatterns = {"package.json"},
    }
}

local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}
