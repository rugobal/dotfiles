return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- "leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
		"rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
	},
	config = function()
		require("dapui").setup()
		-- require("dap-go").setup()
		require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

		local dap, dapui = require("dap"), require("dapui")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		dap.listeners.after.event_initialized["store_last_debugged"] = function(session)
			-- Store the last debugged file path in a global variable
			_G.last_debugged_file = session.config.program
			_G.last_debugged_type = session.config.type
			_G.last_debugged_args = session.config.args
			_G.last_debugged_cwd = session.config.cwd
			_G.last_debugged_env = session.config.env
		end

		-- Creating a Custom Command to Debug the Last File
		vim.api.nvim_create_user_command("DebugLast", function()
			if _G.last_debugged_file then
				-- Setup your debug configuration based on the last debugged file
				local debug_config = {
					type = _G.last_debugged_type, -- e.g., 'cppdbg', 'python', etc.
					request = "launch",
					name = "Debug Last",
					program = _G.last_debugged_file,
					-- Add any other necessary configuration fields
					args = _G.last_debugged_args,
					cwd = _G.last_debugged_cwd,
					env = _G.last_debugged_env,
					console = "integratedTerminal",
				}

				-- Start the debug session
				dap.run(debug_config)
			else
				print("No previously debugged file found.")
			end
		end, {})


		-- debug by name function
		-- function StartDebugByName()
		-- 	local configName = vim.fn.input("Config name: ")
		-- 	for _, config in ipairs(dap.configurations.python) do -- Assuming 'python'. Adjust if necessary.
		-- 		if config.name == configName then
		-- 			dap.run(config)
		-- 			return
		-- 		end
		-- 	end
		-- 	print("Debug configuration not found: " .. configName)
		-- end

    function StartDebugByName()
      -- Check if a debug session is active and continue if so
      if dap.session() then
        dap.continue()
        return
      end

      local allConfigs = {}
      local names = {}

      -- Collect all configurations across debuggers
      for debugger, configs in pairs(dap.configurations) do
        for _, config in ipairs(configs) do
          if config.name then
            local displayName = string.format("[%s] %s", debugger, config.name)
            table.insert(names, displayName)
            table.insert(allConfigs, config)
          end
        end
      end

      -- Callback function to run the selected configuration
      local on_select = function(item)
        if not item then
          print("No configuration selected")
          return
        end
        -- Extract debugger name from item and find corresponding config
        local debugger, configName = item:match("%[(.-)%] (.+)")
        for _, config in ipairs(allConfigs) do
          if config.name == configName then
            dap.run(config)
            return
          end
        end
      end

      -- Show selection UI
      if #names == 0 then
        print("No debug configurations found")
      else
        vim.ui.select(names, {prompt = 'Select a configuration:'}, on_select)
      end
    end

    vim.api.nvim_create_user_command("Debug", function()
      StartDebugByName()
    end, {})


    -- Define a function to set a conditional breakpoint
    local function set_conditional_breakpoint()
      local dap = require('dap')
      vim.ui.input({ prompt = 'Condition: ' }, function(input)
        if input then
          dap.set_breakpoint(input)
          print('. Breakpoint set with condition: ' .. input)
        end
      end)
    end

    vim.api.nvim_create_user_command("DapConditionalBreakpoint", function()
      set_conditional_breakpoint()
    end, {})

    -- Create a custom command to toggle the DAP UI
    vim.api.nvim_create_user_command("DapToggleUI", function()
      require("dapui").toggle()
    end, {})


		vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>")
		vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
		vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR><bar>:DebugLast<CR>")
		vim.keymap.set("n", "<F10>", ":DapStepOver<CR>")
		vim.keymap.set("n", "<F9>", ":DapStepInto<CR>")
		vim.keymap.set("n", "<F12>", ":DapStepOut<CR>")


		vim.keymap.set("n", "<F4>", ":DapTerminate<CR>")
		vim.keymap.set("n", "<F5>", ":Debug<CR>")

    -- Map the function to a keybinding, for example, <leader>cb
    vim.api.nvim_set_keymap('n', '<leader>cb', ':DapConditionalBreakpoint<CR>', { noremap = true, silent = true })

    -- Map <leader>du to toggle the DAP UI
    vim.keymap.set('n', '<leader>du', ":DapToggleUI<CR>", { noremap = true, silent = true })

	end,

}
