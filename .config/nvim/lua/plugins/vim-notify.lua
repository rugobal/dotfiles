-- Usage
-- Simply call the module with a message!
-- require("notify")("My super important message")
-- 
-- Other plugins can use the notification windows by setting it as your default notify function
-- vim.notify = require("notify")
--
-- You can supply a level to change the border highlighting
-- vim.notify("This is an error message", "error")
return {
  "rcarriga/nvim-notify",
}
