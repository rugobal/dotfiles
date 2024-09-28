return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- Disable auto-commenting on new lines
      pre_hook = function(ctx)
        -- Only do this for normal and visual mode
        if vim.api.nvim_get_mode().mode == 'i' then
          vim.opt.formatoptions:remove('o') -- This removes auto-commenting on new lines
        end
      end,
    },
    lazy = false,
  }
}
