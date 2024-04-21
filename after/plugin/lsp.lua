local lsp = require("lsp-zero")

local ENSURE_INSTALLED_LANG_SERV = {
	"jsonls",
	"tsserver",
	"eslint",
	"cssls",
	"tailwindcss",
	"custom_elements_ls",
	"lua_ls",
}

local ENSURE_INSTALLED_MASON = {
	"jsonls",
	"tsserver",
	"eslint",
	"cssls",
	"tailwindcss",
	"custom_elements_ls",
	"lua_ls",
	"prettier",
}

lsp.preset("recommended")
lsp.ensure_installed(ENSURE_INSTALLED_LANG_SERV)
lsp.nvim_workspace()

local cmp = require("cmp")

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-k>"] = vim.schedule_wrap(function(fallback)
		if cmp.visible() and has_words_before() then
			cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
		else
			fallback()
		end
	end),
	["<C-j>"] = vim.schedule_wrap(function(fallback)
		if cmp.visible() and has_words_before() then
			cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
		else
			fallback()
		end
	end),
	["<Tab>"] = cmp.mapping.confirm({ select = true }),
	["<S-Tab>"] = cmp.mapping.complete(),
})

cmp_mappings["<Space>"] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.set_preferences({
	suggest_lsp_servers = true,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		["null-ls"] = { "javascript", "typescript", "typescriptreact", "lua", "tsserver", "rust", "python" },
	},
})

lsp.setup()

local lspkind = require("lspkind")

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = true,
	},
	sources = { { name = "copilot", group_index = 2 }, { name = "nvim_lsp" } },
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = lspkind.cmp_format({
			--mode = 'symbol', -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		}),
	},
})

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- Replace these with the tools you have installed
		-- make sure the source name is supported by null-ls
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
		null_ls.builtins.formatting.prettier.with({
			filetypes = {
				"javascript",
				"typescript",
				"css",
				"scss",
				"html",
				"json",
				"yaml",
				"markdown",
				"graphql",
				"md",
				"txt",
				"typescriptreact",
				"python",
			},
		}),
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.stylua,
	},
})

require("mason-null-ls").setup({
	ensure_installed = ENSURE_INSTALLED_MASON,
	automatic_installation = true,
})
