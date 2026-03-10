local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local mappings = {
	builtins = {
		-- Builtins: Buffer
		["n|<leader>bn"] = map_cu("enew"):with_noremap():with_silent():with_desc("缓冲区: 新建"),
		["n|<leader>ne"] = map_cr("b#"):with_noremap():with_silent():with_desc("缓冲区: 跳转到上一个编辑的文件"),

		-- Builtins: Terminal
		["t|<C-w>h"] = map_cmd("<Cmd>wincmd h<CR>"):with_silent():with_noremap():with_desc("窗口: 聚焦左侧"),
		["t|<C-w>l"] = map_cmd("<Cmd>wincmd l<CR>"):with_silent():with_noremap():with_desc("窗口: 聚焦右侧"),
		["t|<C-w>j"] = map_cmd("<Cmd>wincmd j<CR>"):with_silent():with_noremap():with_desc("窗口: 聚焦下方"),
		["t|<C-w>k"] = map_cmd("<Cmd>wincmd k<CR>"):with_silent():with_noremap():with_desc("窗口: 聚焦上方"),

		-- Builtins: Tabpage
		["n|tn"] = map_cr("tabnew"):with_noremap():with_silent():with_desc("标签页: 创建新标签"),
		["n|tk"] = map_cr("tabnext"):with_noremap():with_silent():with_desc("标签页: 下一个标签"),
		["n|tj"] = map_cr("tabprevious"):with_noremap():with_silent():with_desc("标签页: 上一个标签"),
		["n|to"] = map_cr("tabonly"):with_noremap():with_silent():with_desc("标签页: 仅保留当前标签"),
	},
	plugins = {
		-- Plugin: nvim-bufdel
		["n|<A-q>"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("缓冲区: 关闭当前"),

		-- Plugin: bufferline.nvim
		["n|<A-i>"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent():with_desc("缓冲区: 切换到下一个"),
		["n|<A-o>"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent():with_desc("缓冲区: 切换到上一个"),
		["n|<A-S-i>"] = map_cr("BufferLineMoveNext")
			:with_noremap()
			:with_silent()
			:with_desc("缓冲区: 将当前移至下一个"),
		["n|<A-S-o>"] = map_cr("BufferLineMovePrev")
			:with_noremap()
			:with_silent()
			:with_desc("缓冲区: 将当前移至上一个"),
		["n|<leader>be"] = map_cr("BufferLineSortByExtension"):with_noremap():with_desc("缓冲区: 按扩展名排序"),
		["n|<leader>bd"] = map_cr("BufferLineSortByDirectory"):with_noremap():with_desc("缓冲区: 按目录排序"),
		["n|<A-1>"] = map_cr("BufferLineGoToBuffer 1"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 1"),
		["n|<A-2>"] = map_cr("BufferLineGoToBuffer 2"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 2"),
		["n|<A-3>"] = map_cr("BufferLineGoToBuffer 3"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 3"),
		["n|<A-4>"] = map_cr("BufferLineGoToBuffer 4"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 4"),
		["n|<A-5>"] = map_cr("BufferLineGoToBuffer 5"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 5"),
		["n|<A-6>"] = map_cr("BufferLineGoToBuffer 6"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 6"),
		["n|<A-7>"] = map_cr("BufferLineGoToBuffer 7"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 7"),
		["n|<A-8>"] = map_cr("BufferLineGoToBuffer 8"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 8"),
		["n|<A-9>"] = map_cr("BufferLineGoToBuffer 9"):with_noremap():with_silent():with_desc("缓冲区: 跳转到缓冲区 9"),

		-- Plugin: smart-splits.nvim
		["n|<A-h>"] = map_cu("SmartResizeLeft")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 水平调整大小 -3"),
		["n|<A-j>"] = map_cu("SmartResizeDown"):with_silent():with_noremap():with_desc("窗口: 垂直调整大小 -3"),
		["n|<A-k>"] = map_cu("SmartResizeUp"):with_silent():with_noremap():with_desc("窗口: 垂直调整大小 +3"),
		["n|<A-l>"] = map_cu("SmartResizeRight")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 水平调整大小 +3"),
		["n|<C-h>"] = map_cu("SmartCursorMoveLeft"):with_silent():with_noremap():with_desc("窗口: 聚焦左侧"),
		["n|<C-j>"] = map_cu("SmartCursorMoveDown"):with_silent():with_noremap():with_desc("窗口: 聚焦下方"),
		["n|<C-k>"] = map_cu("SmartCursorMoveUp"):with_silent():with_noremap():with_desc("窗口: 聚焦上方"),
		["n|<C-l>"] = map_cu("SmartCursorMoveRight"):with_silent():with_noremap():with_desc("窗口: 聚焦右侧"),
		["n|<leader>Wh"] = map_cu("SmartSwapLeft")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 向左移动窗口"),
		["n|<leader>Wj"] = map_cu("SmartSwapDown")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 向下移动窗口"),
		["n|<leader>Wk"] = map_cu("SmartSwapUp"):with_silent():with_noremap():with_desc("窗口: 向上移动窗口"),
		["n|<leader>Wl"] = map_cu("SmartSwapRight")
			:with_silent()
			:with_noremap()
			:with_desc("窗口: 向右移动窗口"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)

--- The following code enables this file to be exported ---
---  for use with gitsigns lazy-loaded keymap bindings  ---

local M = {}

function M.gitsigns(bufnr)
	local gitsigns = require("gitsigns")
	local map = {
		["n|]g"] = map_callback(function()
				if vim.wo.diff then
					return "]g"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("next")
				end)
				return "<Ignore>"
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_expr()
			:with_desc("Git: 跳转到下一个修改块"),
		["n|[g"] = map_callback(function()
				if vim.wo.diff then
					return "[g"
				end
				vim.schedule(function()
					gitsigns.nav_hunk("prev")
				end)
				return "<Ignore>"
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_expr()
			:with_desc("Git: 跳转到上一个修改块"),
		["n|<leader>gs"] = map_callback(function()
				gitsigns.stage_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 切换修改块暂存状态"),
		["v|<leader>gs"] = map_callback(function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 切换选中修改块暂存状态"),
		["n|<leader>gr"] = map_callback(function()
				gitsigns.reset_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 重置修改块"),
		["v|<leader>gr"] = map_callback(function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 重置修改块"),
		["n|<leader>gR"] = map_callback(function()
				gitsigns.reset_buffer()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 重置缓冲区"),
		["n|<leader>gp"] = map_callback(function()
				gitsigns.preview_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 预览修改块"),
		["n|<leader>gb"] = map_callback(function()
				gitsigns.blame_line({ full = true })
			end)
			:with_buffer(bufnr)
			:with_noremap()
			:with_desc("Git: 查看行 blame"),
		-- Text objects
		["ox|ih"] = map_callback(function()
				gitsigns.select_hunk()
			end)
			:with_buffer(bufnr)
			:with_noremap(),
	}
	bind.nvim_load_mapping(map)
end

return M
