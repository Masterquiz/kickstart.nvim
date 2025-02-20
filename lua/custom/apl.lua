local apl_win
local apl_buf

local function on_apl_save()
  vim.cmd 'silent! write' -- Save current file

  -- If the window is not open or is invalid, open a new window.
  if apl_win == nil or not vim.api.nvim_win_is_valid(apl_win) then
    apl_win = vim.api.nvim_open_win(apl_buf, false, { split = 'right' })
  end

  -- Execute the script and capture its output.
  local output = {
    result = {},
    error = {},
  }

  vim
    .system({ 'bash', '-c', vim.fn.expand '%:p' }, {
      stdout = function(_, data)
        if data then
          table.insert(output.result, vim.split(data, '\r'))
        end
      end,

      stderr = function(_, data)
        if data then
          table.insert(output.error, vim.split(data, '\n'))
        end
      end,
    })
    :wait()

  output.result = vim.iter(output.result):flatten():totable()
  output.error = vim.iter(output.error):flatten():totable()

  -- Make apl_buf momentarily modifiable to update its content
  --   and display error messages and output of the script.
  vim.api.nvim_set_option_value('modifiable', true, { buf = apl_buf })

  if #output.error > 0 then
    vim.api.nvim_buf_set_lines(apl_buf, 0, -1, false, output.error)
  end

  if #output.result > 0 then
    vim.api.nvim_buf_set_lines(apl_buf, #output.error, -1, false, output.result)
  end

  vim.api.nvim_set_option_value('modifiable', false, { buf = apl_buf })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'apl',
  callback = function()
    vim.bo.commentstring = '⍝ %s'

    -- Make file executable
    if vim.fn.executable(vim.fn.expand '%:p') == 0 then
      vim.fn.system { 'chmod', '+x', vim.fn.expand '%:p' }
    end

    -- Add shebang line and useful utilities
    if vim.fn.getline(1) == '' then
      vim.fn.append(0, { '#!/usr/bin/dyalogscript', '', ')load dfns', '' })
    end

    if apl_buf == nil or not vim.api.nvim_buf_is_valid(apl_buf) then
      apl_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_option_value('modifiable', false, { buf = apl_buf })

      apl_win = vim.api.nvim_open_win(apl_buf, false, { split = 'right' })
    end

    vim.keymap.set('n', '<C-s>', on_apl_save, { buffer = true, desc = 'Execute current APL file' })
    vim.keymap.set('i', '<C-s>', on_apl_save, { buffer = true, desc = 'Execute current APL file' })

    vim.api.nvim_buf_set_keymap(0, 'i', '<C-p>', '⎕← disp ', { noremap = true, silent = true })
  end,
})
