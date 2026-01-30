local lualine = require("lualine")

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = true,
	update_in_insert = false,
	always_visible = true,
	cond = function()
		return vim.bo.filetype ~= "markdown"
	end,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " },
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local branch = {
	"branch",
	icon = "",
}

local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "", "", "" } --adding more chars will still work
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index] .. " " .. math.floor(line_ratio * 100) .. "%%"
end

local lspComponent = {
	-- Lsp server name .
	function()
		local msg = "No Active Lsp"
		local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		local clients = vim.lsp.get_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = " LSP:",
	color = { fg = "#ffffff", gui = "bold" },
}

local fileComponent = {
	"filename",
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto", --auto allows for theme switching
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard" },
		always_divide_middle = true,
	},

	sections = {
		lualine_a = { mode },
		lualine_b = { fileComponent },
		lualine_c = { diagnostics, lspComponent },
		lualine_x = { diff, "fileformat", "filetype" },
		lualine_y = { "location" },
		lualine_z = { progress },
	},
	extensions = { "nvim-tree" },
})
