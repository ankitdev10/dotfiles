return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local palette = { "#cba6f7", "#cdd6f4", "#fab387", "#6c7086", "#a6e3a1", "#f5e0dc", "#9399b2", "#89b4fa", "#45475a" }
    for i, color in ipairs(palette) do
      vim.api.nvim_set_hl(0, "AlphaArt" .. i, { fg = color })
    end

    local function load_art(path)
      local f = io.open(vim.fn.expand(path), "r")
      if not f then
        return nil
      end
      local lines, hls = {}, {}
      for raw in f:lines() do
        local text, ranges, group, pos = "", {}, "AlphaArt2", 1
        while pos <= #raw do
          local s, e, n = raw:find("%$(%d)", pos)
          local chunk = raw:sub(pos, s and s - 1 or #raw)
          if #chunk > 0 then
            table.insert(ranges, { group, #text, #text + #chunk })
            text = text .. chunk
          end
          if not s then
            break
          end
          group = "AlphaArt" .. n
          pos = e + 1
        end
        table.insert(lines, text)
        table.insert(hls, #ranges > 0 and ranges or { { "AlphaArt2", 0, 0 } })
      end
      f:close()
      local width = 0
      for _, l in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(l))
      end
      for i, l in ipairs(lines) do
        lines[i] = l .. string.rep(" ", width - vim.fn.strdisplaywidth(l))
      end
      table.insert(lines, 1, "")
      table.insert(hls, 1, { { "AlphaArt2", 0, 0 } })
      table.insert(lines, "")
      table.insert(hls, { { "AlphaArt2", 0, 0 } })
      return lines, hls
    end

    local art = vim.o.columns >= 70 and "~/.config/fastfetch/logo.txt" or "~/.config/fastfetch/logo-small.txt"
    local lines, hls = load_art(art)
    if lines then
      dashboard.section.header.val = lines
      dashboard.section.header.opts.hl = hls
    end

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

    -- Show dashboard when opening a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(ev)
        if vim.fn.isdirectory(ev.file) == 1 then
          require("alpha").start()
        end
      end,
    })
  end,
}

