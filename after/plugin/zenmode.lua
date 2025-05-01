local zen = require("zen-mode")

vim.keymap.set("n", "<leader>zz", function()
	zen.toggle()
	zen.setup({
		window = {
			width = 80,
			backdrop = 0.5,
			options = {},
		},
	})
	vim.wo.wrap = false
	vim.wo.number = true
	vim.wo.rnu = true
	vim.opt.colorcolumn = "0"
	ColorMyPencils()
end)

vim.keymap.set("n", "<leader>zZ", function()
	zen.toggle()
	vim.wo.wrap = false
	vim.wo.number = false
	vim.wo.rnu = false
	vim.opt.colorcolumn = "0"
	ColorMyPencils()
end)
