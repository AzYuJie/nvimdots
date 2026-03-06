local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

local ts_to_select = require("nvim-treesitter-textobjects.select")
local ts_to_swap = require("nvim-treesitter-textobjects.swap")
local ts_to_move = require("nvim-treesitter-textobjects.move")
local ts_to_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

-- Smart quit with confirmation for unsaved buffers
local function smart_quit()
	local modified_buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name == "" then
				name = "[No Name]"
			else
				name = vim.fn.fnamemodify(name, ":t")
			end
			table.insert(modified_buffers, name)
		end
	end

	if #modified_buffers > 0 then
		local msg = "存在未保存的文件:\n  - " .. table.concat(modified_buffers, "\n  - ")
		msg = msg .. "\n\n是否强制退出？"
		local confirm = vim.fn.confirm(msg, "&Yes\n&No", 2, "Question")
		if confirm == 1 then
			vim.cmd("qa!")
		end
	else
		vim.cmd("qa")
	end
end

local mappings = {
	builtins = {
		-- Builtins: Save & Quit
		["n|<C-s>"] = map_cu("write"):with_noremap():with_silent():with_desc("编辑: 保存文件"),
		["n|<C-q>"] = map_cr("wq"):with_desc("编辑: 保存并退出"),
		["n|<A-S-q>"] = map_cr("q!"):with_desc("编辑: 强制退出"),
		["n|<leader>qq"] = map_callback(smart_quit):with_silent():with_desc("编辑: 智能退出"),

		-- Builtins: Insert mode
		["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("编辑: 删除前一个块"),
		["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("编辑: 光标左移"),
		["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("编辑: 光标移至行首"),
		["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("编辑: 保存文件"),
		["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("编辑: 保存并退出"),

		-- Builtins: Command mode
		["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("编辑: 左移"),
		["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("编辑: 右移"),
		["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("编辑: 行首"),
		["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("编辑: 行尾"),
		["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("编辑: 删除"),
		["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("编辑: 退格"),
		["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
			:with_noremap()
			:with_desc("编辑: 补全当前文件路径"),

		-- Builtins: Visual mode
		["v|J"] = map_cmd(":m '>+1<CR>gv=gv"):with_desc("编辑: 下移当前行"),
		["v|K"] = map_cmd(":m '<-2<CR>gv=gv"):with_desc("编辑: 上移当前行"),
		["v|<"] = map_cmd("<gv"):with_desc("编辑: 减少缩进"),
		["v|>"] = map_cmd(">gv"):with_desc("编辑: 增加缩进"),

		-- Builtins: "Suckless" - named after r/suckless
		["n|Y"] = map_cmd("y$"):with_desc("编辑: 复制到行尾"),
		["n|D"] = map_cmd("d$"):with_desc("编辑: 删除到行尾"),
		["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("编辑: 下一个搜索结果"),
		["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("编辑: 上一个搜索结果"),
		["n|J"] = map_cmd("mzJ`z"):with_noremap():with_desc("编辑: 合并下一行"),
		["n|<S-Tab>"] = map_cr("normal za"):with_noremap():with_silent():with_desc("编辑: 切换代码折叠"),
		["n|<Esc>"] = map_callback(function()
				_flash_esc_or_noh()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("编辑: 清除搜索高亮"),
		["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("编辑: 切换拼写检查"),
	},
	plugins = {
		-- Plugin: persisted.nvim
		["n|<leader>ss"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("会话: 保存"),
		["n|<leader>sl"] = map_cu("SessionLoad"):with_noremap():with_silent():with_desc("会话: 加载当前"),
		["n|<leader>sd"] = map_cu("SessionDelete"):with_noremap():with_silent():with_desc("会话: 删除"),

		-- Plugin: comment.nvim
		["n|gcc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
					or et("<Plug>(comment_toggle_linewise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("编辑: 切换行注释"),
		["n|gbc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
					or et("<Plug>(comment_toggle_blockwise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("编辑: 切换块注释"),
		["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 使用操作符切换行注释"),
		["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 使用操作符切换块注释"),
		["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选区切换行注释"),
		["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选区切换块注释"),

		-- Plugin: diffview.nvim
		["n|<leader>gd"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("Git: 显示差异"),
		["n|<leader>gD"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("Git: 关闭差异"),

		-- Plugin: hop.nvim
		["nv|<leader>w"] = map_cmd("<Cmd>HopWordMW<CR>"):with_noremap():with_desc("跳转: 跳转到单词"),
		["nv|<leader>j"] = map_cmd("<Cmd>HopLineMW<CR>"):with_noremap():with_desc("跳转: 跳转到行"),
		["nv|<leader>k"] = map_cmd("<Cmd>HopLineMW<CR>"):with_noremap():with_desc("跳转: 跳转到行"),
		["nv|<leader>c"] = map_cmd("<Cmd>HopChar1MW<CR>"):with_noremap():with_desc("跳转: 跳转到单字符"),
		["nv|<leader>C"] = map_cmd("<Cmd>HopChar2MW<CR>"):with_noremap():with_desc("跳转: 跳转到双字符"),

		-- Plugin: grug-far
		["n|<leader>Ss"] = map_callback(function()
				require("grug-far").open()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 切换搜索替换面板"),
		["n|<leader>Sp"] = map_callback(function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 搜索替换当前单词 (项目)"),
		["v|<leader>Sp"] = map_callback(function()
				require("grug-far").with_visual_selection()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 搜索替换当前单词 (项目)"),
		["n|<leader>Sf"] = map_callback(function()
				require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 搜索替换当前单词 (文件)"),

		-- Plugin: nvim-treehopper
		["o|m"] = map_cu("lua require('tsht').nodes()"):with_silent():with_desc("跳转: 跨语法树操作"),

		-- Plugin: suda.vim
		["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("编辑: 使用 sudo 保存文件"),

		-- Plugin: nvim-treesitter-textobjects
		-- Text objects: select
		["xo|af"] = map_callback(function()
				ts_to_select.select_textobject("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择函数外部"),
		["xo|if"] = map_callback(function()
				ts_to_select.select_textobject("@function.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择函数内部"),
		["xo|ac"] = map_callback(function()
				ts_to_select.select_textobject("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择类外部"),
		["xo|ic"] = map_callback(function()
				ts_to_select.select_textobject("@class.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 选择类内部"),
		-- Text objects: swap
		["n|<leader>a"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.inner")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 交换内部参数"),
		["n|<leader>A"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.outer")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 交换外部参数"),
		-- Text objects: move
		["nxo|]["] = map_callback(function()
				ts_to_move.goto_next_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到下一个函数开始"),
		["nxo|]m"] = map_callback(function()
				ts_to_move.goto_next_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到下一个类开始"),
		["nxo|]]"] = map_callback(function()
				ts_to_move.goto_next_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到下一个函数结束"),
		["nxo|]M"] = map_callback(function()
				ts_to_move.goto_next_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到下一个类结束"),
		["nxo|[["] = map_callback(function()
				ts_to_move.goto_previous_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到上一个函数开始"),
		["nxo|[m"] = map_callback(function()
				ts_to_move.goto_previous_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到上一个类开始"),
		["nxo|[]"] = map_callback(function()
				ts_to_move.goto_previous_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到上一个函数结束"),
		["nxo|[M"] = map_callback(function()
				ts_to_move.goto_previous_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 移动到上一个类结束"),
		-- movements repeat
		["nxo|;"] = map_callback(function()
				ts_to_repeat_move.repeat_last_move_next()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑: 重复上次移动"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)
