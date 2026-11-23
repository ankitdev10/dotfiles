return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			mauve = "#cba6f7",
			green = "#a6e3a1",
			peach = "#fab387",
			yellow = "#f9e2af",
			red = "#f38ba8",
			text = "#cdd6f4",
			subtext = "#a6adc8",
			overlay = "#6c7086",
			mantle = "#181825",
			surface = "#313244",
			crust = "#11111b",
		}

		local function mode(accent)
			return {
				a = { bg = accent, fg = colors.crust, gui = "bold" },
				b = { bg = colors.surface, fg = colors.text },
				c = { bg = "NONE", fg = colors.subtext },
			}
		end

		local my_lualine_theme = {
			normal = mode(colors.mauve),
			insert = mode(colors.green),
			visual = mode(colors.peach),
			command = mode(colors.yellow),
			replace = mode(colors.red),
			inactive = {
				a = { bg = colors.mantle, fg = colors.overlay, gui = "bold" },
				b = { bg = colors.mantle, fg = colors.overlay },
				c = { bg = "NONE", fg = colors.overlay },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
				section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
				component_separators = "",
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "\u{e0b6}", right = "\u{e0b4}" } } },
				lualine_z = { { "location", separator = { left = "\u{e0b6}", right = "\u{e0b4}" } } },

				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = colors.peach },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
			inactive_session = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
