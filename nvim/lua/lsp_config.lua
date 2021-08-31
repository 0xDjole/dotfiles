local nvim_lsp = require 'lspconfig'
local coq = require 'coq'
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
    buf_map(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { silent = true })

    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_exec([[
         augroup LspAutocommands
             autocmd! * <buffer>
             autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting() 
         augroup END
         ]], true)
    end
end

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
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
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
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
}

nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}

nvim_lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))

nvim_lsp.svelte.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))

nvim_lsp.pyright.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))

nvim_lsp.tailwindcss.setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))

