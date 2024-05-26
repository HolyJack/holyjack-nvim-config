local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_mappings = cmp.mapping.preset.insert({
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

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
  },
  mapping = cmp_mappings,
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  })
})
