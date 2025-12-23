local options = {
	delay = 0.6,
	message = "Time to rest!",
}
local timer_running = false
local function check_time()
	if not timer_running then
		return
	end
	vim.notify(options.message, vim.log.levels.WARN)
	vim.defer_fn(check_time, options.delay * 60 * 1000)
end
local M = {}

function M.setup(opts)
	vim.api.nvim_create_user_command("RestEnable", M.start, { desc = "启动休息提醒" })
	vim.api.nvim_create_user_command("RestStop", function()
		M.stop()
		vim.notify("rest time stopped", vim.log.levels.INFO)
	end, { desc = "停止休息提醒" })
	opts = opts or {}
	options = vim.tbl_deep_extend("force", options, opts)
	M.start()
end

function M.start()
	M.stop()
	timer_running = true
	vim.notify("rest time loaded", vim.log.levels.INFO)
	if type(options.delay) ~= "number" then
		vim.notify("请输入数字", vim.log.levels.WARN)
	else
		vim.defer_fn(check_time, options.delay * 60 * 1000)
	end
end

function M.stop()
	timer_running = false
end

return M
