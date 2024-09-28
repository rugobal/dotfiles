return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      -- {
      --   "isak102/telescope-git-file-history.nvim",
      --   dependencies = { "tpope/vim-fugitive" }
      -- },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
      {
        "stevearc/aerial.nvim", -- For aerial extension
      },
    },
    config = function()

      local focus_preview = function(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local actions = require('telescope.actions')
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt_win = picker.prompt_win
        local previewer = picker.previewer
        if previewer and previewer.state and vim.api.nvim_win_is_valid(previewer.state.winid) then
          local winid = previewer.state.winid
          local bufnr = previewer.state.bufnr

          -- Set C-l and C-h to toggle back to prompt window
          vim.keymap.set({ "n", "i" }, "<C-l>", function()
            vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
          end, { buffer = bufnr })

          vim.keymap.set({ "n", "i" }, "<C-h>", function()
            vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
          end, { buffer = bufnr })

          -- Map <Esc> to close Telescope from the preview window
          vim.keymap.set({ "n", "i" }, "<Esc>", function()
            actions.close(prompt_bufnr)
          end, { buffer = bufnr })

          -- Switch to preview window
          vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
        else
          vim.notify("Preview window not valid or not available", vim.log.levels.WARN)
        end
      end


      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local Path = require('plenary.path')
      local async = require('plenary.async')

      -- local function git_diff_selected_commits(prompt_bufnr)
      --   local picker = action_state.get_current_picker(prompt_bufnr)
      --   local multi_selection = picker:get_multi_selection()
      --
      --   if #multi_selection ~= 2 then
      --     print("Please select exactly two commits to compare")
      --     return
      --   end
      --
      --   actions.close(prompt_bufnr)
      --
      --   local sha1 = multi_selection[1].value
      --   local sha2 = multi_selection[2].value
      --
      --   -- Get commit dates
      --   local date_format = '%Y%m%d%H%M%S'
      --   local date_cmd = 'git show -s --format=%cd --date=format:' .. date_format .. ' '
      --
      --   local date1_output = vim.fn.systemlist(date_cmd .. sha1)
      --   local date2_output = vim.fn.systemlist(date_cmd .. sha2)
      --
      --   local date1 = tonumber(date1_output[1])
      --   local date2 = tonumber(date2_output[1])
      --
      --   if date1 == nil or date2 == nil then
      --     print("Unable to retrieve commit dates")
      --     return
      --   end
      --
      --   -- Determine which commit is older
      --   local sha_left, sha_right
      --   if date1 <= date2 then
      --     -- sha1 is older
      --     sha_left = sha2     -- newer commit
      --     sha_right = sha1    -- older commit
      --   else
      --     -- sha2 is older
      --     sha_left = sha1     -- newer commit
      --     sha_right = sha2    -- older commit
      --   end
      --
      --   -- Get the file path relative to the repository root
      --   local file = vim.fn.expand('%')
      --   local repo_path = vim.fn.systemlist('git rev-parse --show-toplevel')[1]:gsub('%s+', '')
      --   local rel_file_path = Path:new(file):make_relative(repo_path)
      --
      --   -- Open the newer commit (left pane) in the current window
      --   vim.cmd('Gedit ' .. sha_left .. ':' .. rel_file_path)
      --   local winid_left = vim.api.nvim_get_current_win()
      --
      --   -- Open a vertical split to the right
      --   vim.cmd('vsplit')
      --
      --   -- In the new window (right pane), open the older commit
      --   vim.cmd('Gedit ' .. sha_right .. ':' .. rel_file_path)
      --   local winid_right = vim.api.nvim_get_current_win()
      --
      --   -- Start diff mode between the two windows
      --   vim.cmd('diffthis')
      --   vim.api.nvim_set_current_win(winid_left)
      --   vim.cmd('diffthis')
      --
      --   -- Expand all folds after a delay
      --   vim.defer_fn(function()
      --     local ufo = require('ufo')
      --
      --     -- Expand folds in the right window
      --     vim.api.nvim_set_current_win(winid_right)
      --     ufo.openAllFolds()
      --
      --     -- Expand folds in the left window
      --     vim.api.nvim_set_current_win(winid_left)
      --     ufo.openAllFolds()
      --   end, 50)  -- Delay in milliseconds
      -- end



      -- local function git_diff_commit_with_parent(prompt_bufnr)
      --   local selection = action_state.get_selected_entry()
      --   actions.close(prompt_bufnr)
      --
      --   local sha = selection.value
      --
      --   -- Get the parent commit SHA
      --   local parent_sha_output = vim.fn.systemlist('git rev-parse ' .. sha .. '^')
      --   if vim.v.shell_error ~= 0 or #parent_sha_output == 0 then
      --     print("Unable to get parent commit")
      --     return
      --   end
      --
      --   local parent_sha = parent_sha_output[1]
      --
      --   -- Get the file path relative to the repository root
      --   local file = vim.fn.expand('%')
      --   local repo_path = vim.fn.systemlist('git rev-parse --show-toplevel')[1]:gsub('%s+', '')
      --   local rel_file_path = Path:new(file):make_relative(repo_path)
      --
      --   -- Open the selected commit version of the file in the current window
      --   vim.cmd('Gedit ' .. sha .. ':' .. rel_file_path)
      --   local winid_selected = vim.api.nvim_get_current_win()
      --
      --   -- Open a vertical split to the left
      --   vim.cmd('leftabove vsplit')
      --
      --   -- In the new window (left pane), open the parent commit version of the file
      --   vim.cmd('Gedit ' .. parent_sha .. ':' .. rel_file_path)
      --   local winid_parent = vim.api.nvim_get_current_win()
      --
      --   -- Expand all folds
      --   local ufo = require('ufo')
      --
      --   -- Start diff mode between the two windows
      --   vim.cmd('diffthis')
      --   vim.api.nvim_set_current_win(winid_selected)
      --   vim.cmd('diffthis')
      --
      --
      --   -- Expand all folds after a delay
      --   vim.defer_fn(function()
      --     local ufo = require('ufo')
      --
      --     -- Expand folds in the right window
      --     vim.api.nvim_set_current_win(winid_parent)
      --     ufo.openAllFolds()
      --
      --     -- Expand folds in the left window
      --     vim.api.nvim_set_current_win(winid_selected)
      --     ufo.openAllFolds()
      --   end, 50)  -- Delay in milliseconds
      --
      -- end


      local function git_diff_commits(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selection = picker:get_multi_selection()

        actions.close(prompt_bufnr)

        local num_selections = #multi_selection

        -- Get the file path relative to the repository root
        local file = vim.fn.expand('%')
        local repo_path = vim.fn.systemlist('git rev-parse --show-toplevel')[1]:gsub('%s+', '')
        local rel_file_path = Path:new(file):make_relative(repo_path)

        if num_selections == 2 then
          -- **Scenario 1**: Two commits selected
          local sha1 = multi_selection[1].value
          local sha2 = multi_selection[2].value

          -- Get commit dates
          local date_format = '%Y%m%d%H%M%S'
          local date_cmd = 'git show -s --format=%cd --date=format:' .. date_format .. ' '

          local date1_output = vim.fn.systemlist(date_cmd .. sha1)
          local date2_output = vim.fn.systemlist(date_cmd .. sha2)

          local date1 = tonumber(date1_output[1])
          local date2 = tonumber(date2_output[1])

          if date1 == nil or date2 == nil then
            print("Unable to retrieve commit dates")
            return
          end

          -- Determine which commit is older
          local sha_left, sha_right
          if date1 <= date2 then
            -- sha1 is older
            sha_left = sha2     -- newer commit
            sha_right = sha1    -- older commit
          else
            -- sha2 is older
            sha_left = sha1     -- newer commit
            sha_right = sha2    -- older commit
          end

          -- Open the newer commit (left pane) in the current window
          vim.cmd('Gedit ' .. sha_left .. ':' .. rel_file_path)
          local winid_left = vim.api.nvim_get_current_win()

          -- Open a vertical split to the right
          vim.cmd('vsplit')

          -- In the new window (right pane), open the older commit
          vim.cmd('Gedit ' .. sha_right .. ':' .. rel_file_path)
          local winid_right = vim.api.nvim_get_current_win()

          -- Start diff mode between the two windows
          vim.cmd('diffthis')
          vim.api.nvim_set_current_win(winid_left)
          vim.cmd('diffthis')

          -- Expand all folds asynchronously
          async.run(function()
            local ufo = require('ufo')

            -- Wait for folds in the left window
            vim.api.nvim_set_current_win(winid_left)
            ufo.attach()
            ufo.enableFold()
            ufo.openAllFolds()
            async.util.sleep(50)

            -- Wait for folds in the right window
            vim.api.nvim_set_current_win(winid_right)
            ufo.attach()
            ufo.enableFold()
            ufo.openAllFolds()
            async.util.sleep(50)

            -- Optionally, return focus to the desired window
            vim.api.nvim_set_current_win(winid_left)
          end)

        else
          local selection = action_state.get_selected_entry()
          local sha = selection.value

          -- Get the parent commit SHA
          local parent_sha_output = vim.fn.systemlist('git rev-parse ' .. sha .. '^')
          if vim.v.shell_error ~= 0 or #parent_sha_output == 0 then
            print("Unable to get parent commit")
            return
          end

          local parent_sha = parent_sha_output[1]

          -- Get the file path relative to the repository root
          file = vim.fn.expand('%')
          repo_path = vim.fn.systemlist('git rev-parse --show-toplevel')[1]:gsub('%s+', '')
          rel_file_path = Path:new(file):make_relative(repo_path)

          -- Open the selected commit version of the file in the current window
          vim.cmd('Gedit ' .. sha .. ':' .. rel_file_path)
          local winid_selected = vim.api.nvim_get_current_win()

          -- Open a vertical split to the left
          vim.cmd('leftabove vsplit')

          -- In the new window (left pane), open the parent commit version of the file
          vim.cmd('Gedit ' .. parent_sha .. ':' .. rel_file_path)
          local winid_parent = vim.api.nvim_get_current_win()


          -- Start diff mode between the two windows
          vim.cmd('diffthis')
          vim.api.nvim_set_current_win(winid_selected)
          vim.cmd('diffthis')

          -- Expand all folds asynchronously
          async.run(function()
            local ufo = require('ufo')

            -- Wait for folds in the local window
            vim.api.nvim_set_current_win(winid_parent)
            ufo.attach()
            ufo.enableFold()
            ufo.openAllFolds()
            async.util.sleep(50)

            -- Wait for folds in the commit window
            vim.api.nvim_set_current_win(winid_selected)
            ufo.attach()
            ufo.enableFold()
            ufo.openAllFolds()
            async.util.sleep(50)

            -- Optionally, return focus to the desired window
            vim.api.nvim_set_current_win(winid_selected)
          end)
        end
      end

      local function open_file_at_commit(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local value = selection.value

        actions.close(prompt_bufnr)

        -- Open the file at the selected commit using :Gedit
        local filename = vim.fn.expand("%")
        vim.cmd("Gedit " .. value .. ":" .. filename)



        -- -- Get the selected commit
        --   local selection = action_state.get_selected_entry()
        --   if not selection then return end
        --
        --   local commit_hash = selection.value
        --   local filename = vim.fn.expand("%")
        --
        --   if not commit_hash or not filename then
        --     vim.notify("Cannot open file at commit: Missing commit hash or filename", vim.log.levels.ERROR)
        --     return
        --   end
        --
        --   -- Close the Telescope prompt
        --   actions.close(prompt_bufnr)
        --
        --   -- Open the file at the selected commit using :Gedit
        --   vim.cmd("Gedit " .. commit_hash .. ":" .. filename)
      end


      require("telescope").setup({
        defaults = {
          mappings = {
            n = {
              ["<C-h>"] = function(prompt_bufnr)
                focus_preview(prompt_bufnr)
              end,
              ["<C-l>"] = function(prompt_bufnr)
                focus_preview(prompt_bufnr)
              end,
              -- ["<C-m>"] = git_diff_commit_with_parent,
              ["<C-o>"] = git_diff_commits,
              -- Remap <C-v> to <C-x> for vsplit
              ["<C-x>"] = require('telescope.actions').select_vertical,
              -- Use the extracted function for <Cr> in git_bcommits
              -- ["<Cr>"] = open_file_at_commit,
            },
            i = {
              ["<C-h>"] = function(prompt_bufnr)
                focus_preview(prompt_bufnr)
              end,
              ["<C-l>"] = function(prompt_bufnr)
                focus_preview(prompt_bufnr)
              end,
              -- ["<C-m>"] = git_diff_commit_with_parent,
              ["<C-o>"] = git_diff_commits,
              -- Remap <C-v> to <C-x> for vsplit
              ["<C-x>"] = require('telescope.actions').select_vertical,
            },
          },
        },
        pickers = {
          git_bcommits = {
            mappings = {
              i = {
                ["<Cr>"] = open_file_at_commit,
              },
              n = {
                ["<Cr>"] = open_file_at_commit,
              },
            }
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          fzf = {
            fuzzy = true, -- Enable fuzzy search
            override_generic_sorter = true, -- Use FZF sorter for generic sorting
            override_file_sorter = true, -- Use FZF sorter for file sorting
            case_mode = "smart_case", -- Case-sensitive only if the query contains uppercase
          },
          aerial = {
            -- How to format the symbols
            format_symbol = function(symbol_path, filetype)
              if filetype == "json" or filetype == "yaml" then
                return table.concat(symbol_path, ".")
              else
                return symbol_path[#symbol_path]
              end
            end,
            -- Available modes: symbols, lines, both
            show_columns = "both",
            -- NOT SURE IF THIS OPTION EXISTS. CHECK THE DOCS
            -- show_nesting = {
            --   ["_"] = false,
            --   json = true,
            --   yaml = true,
            -- },
          },
        },
      })

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "TelescopePreviewerLoaded",
        callback = function()
          local winid = vim.api.nvim_get_current_win() -- Get the current window ID
          vim.wo[winid].number = true
          vim.wo[winid].relativenumber = true
        end,
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      -- Add the autocmd for showing line numbers in the preview
      vim.keymap.set("n", "<leader>/", builtin.live_grep, {})

      require("telescope").load_extension("ui-select")

      -- require("telescope").load_extension("git_file_history")

      require("telescope").load_extension("fzf")

      require("telescope").load_extension("aerial")


      --vim.keymap.set("n", "<Leader>fh", ":Telescope git_file_history<CR>")
      vim.keymap.set("n", "fhh", ":Telescope git_bcommits<CR>")
      vim.keymap.set("n", "ffh", ":Telescope git_bcommits<CR>")
      vim.keymap.set("n", "ff", ":Telescope buffers<CR>")

      vim.keymap.set("n", "<Leader>r", ":Telescope lsp_references<CR>")
      -- vim.keymap.set("n", "<Leader>ic", ":Telescope lsp_incoming_calls<CR>") -- this seems not to work well. leaving the original in lsp_config.lua
      vim.keymap.set("n", "<Leader>ds", ":Telescope lsp_document_symbols<CR>")
      vim.keymap.set("n", "<Leader>s", ":Telescope lsp_dynamic_workspace_symbols<CR>")



    end,
  },
}
