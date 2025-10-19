-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/patitomora/.cache/nvim/packer_hererocks/2.1.1753364724/share/lua/5.1/?.lua;/home/patitomora/.cache/nvim/packer_hererocks/2.1.1753364724/share/lua/5.1/?/init.lua;/home/patitomora/.cache/nvim/packer_hererocks/2.1.1753364724/lib/luarocks/rocks-5.1/?.lua;/home/patitomora/.cache/nvim/packer_hererocks/2.1.1753364724/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/patitomora/.cache/nvim/packer_hererocks/2.1.1753364724/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  neopywal = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/neopywal",
    url = "https://github.com/RedsXDD/neopywal.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n-\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\1¿\tbody\15lsp_expand∫\4\1\0\f\0\31\00066\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\a\0005\5\5\0003\6\4\0=\6\6\5=\5\b\0049\5\t\0009\5\n\0059\5\v\0055\a\r\0009\b\t\0009\b\f\bB\b\1\2=\b\14\a9\b\t\0009\b\15\bB\b\1\2=\b\16\a9\b\t\0009\b\17\b5\n\20\0009\v\18\0009\v\19\v=\v\21\nB\b\2\2=\b\22\a9\b\t\0009\b\23\bB\b\1\2=\b\24\aB\5\2\2=\5\t\0049\5\25\0009\5\26\0054\a\5\0005\b\27\0>\b\1\a5\b\28\0>\b\2\a5\b\29\0>\b\3\a5\b\30\0>\b\4\aB\5\2\2=\5\26\4B\2\2\0012\0\0ÄK\0\1\0\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\fsources\vconfig\14<C-Space>\rcomplete\t<CR>\rbehavior\1\0\2\vselect\2\rbehavior\0\fReplace\20ConfirmBehavior\fconfirm\n<C-n>\21select_next_item\n<C-p>\1\0\4\14<C-Space>\0\t<CR>\0\n<C-n>\0\n<C-p>\0\21select_prev_item\vinsert\vpreset\fmapping\fsnippet\1\0\3\fsnippet\0\fmapping\0\fsources\0\vexpand\1\0\1\vexpand\0\0\nsetup\fluasnip\bcmp\frequire\0" },
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n^\0\3\n\1\5\0\v6\3\0\0009\3\1\0039\3\2\3\18\5\0\0\18\6\1\0\18\a\2\0005\b\3\0-\t\0\0=\t\4\bB\3\5\1K\0\1\0\1¿\vbuffer\1\0\2\vsilent\2\vbuffer\0\bset\vkeymap\bvimè\3\1\2\b\0\14\0!3\2\0\0\18\3\2\0'\5\1\0'\6\2\0'\a\3\0B\3\4\1\18\3\2\0'\5\1\0'\6\4\0'\a\5\0B\3\4\1\18\3\2\0'\5\1\0'\6\6\0'\a\a\0B\3\4\1\18\3\2\0'\5\1\0'\6\b\0'\a\t\0B\3\4\1\18\3\2\0'\5\1\0'\6\n\0'\a\v\0B\3\4\1\18\3\2\0'\5\1\0'\6\f\0'\a\r\0B\3\4\0012\0\0ÄK\0\1\0&<cmd>lua vim.lsp.buf.rename()<CR>\15<leader>rn+<cmd>lua vim.lsp.buf.code_action()<CR>\15<leader>ca*<cmd>lua vim.lsp.buf.references()<CR>\agr.<cmd>lua vim.lsp.buf.implementation()<CR>\agi*<cmd>lua vim.lsp.buf.definition()<CR>\agd%<cmd>lua vim.lsp.buf.hover()<CR>\6K\6n\0Ü\1\0\1\5\2\6\0\f6\1\0\0'\3\1\0B\1\2\0028\1\0\0019\1\2\0015\3\3\0-\4\0\0=\4\4\3-\4\1\0=\4\5\3B\1\2\1K\0\1\0\0\0\1\0\17capabilities\14on_attach\1\0\2\17capabilities\0\14on_attach\0\nsetup\14lspconfig\frequireW\1\0\4\2\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\3\0003\3\3\0>\3\1\2B\0\2\1K\0\1\0\0¿\1¿\0\19setup_handlers\20mason-lspconfig\frequire—\2\1\0\6\0\16\0\"6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\4\0'\2\5\0B\0\2\0029\0\6\0B\0\1\0016\0\4\0'\2\a\0B\0\2\0029\0\6\0005\2\t\0005\3\b\0=\3\n\2B\0\2\0013\0\v\0006\1\4\0'\3\f\0B\1\2\0029\1\r\1B\1\1\0026\2\0\0009\2\14\0023\4\15\0)\5d\0B\2\3\0012\0\0ÄK\0\1\0\0\rdefer_fn\25default_capabilities\17cmp_nvim_lsp\0\21ensure_installed\1\0\1\21ensure_installed\0\1\3\0\0\vlua_ls\fpyright\20mason-lspconfig\nsetup\nmason\frequire!packadd mason-lspconfig.nvim\23packadd mason.nvim\bcmd\bvim\0" },
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["vim-be-better"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/vim-be-better",
    url = "https://github.com/szymonwilczek/vim-be-better"
  },
  ["vim-be-good"] = {
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/vim-be-good",
    url = "https://github.com/ThePrimeagen/vim-be-good"
  },
  vimtex = {
    config = { "\27LJ\2\nk\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\flatexmk\27vimtex_compiler_method\fzathura\23vimtex_view_method\6g\bvim\0" },
    loaded = true,
    path = "/home/patitomora/.local/share/nvim/site/pack/packer/start/vimtex",
    url = "https://github.com/lervag/vimtex"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n-\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\1¿\tbody\15lsp_expand∫\4\1\0\f\0\31\00066\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\a\0005\5\5\0003\6\4\0=\6\6\5=\5\b\0049\5\t\0009\5\n\0059\5\v\0055\a\r\0009\b\t\0009\b\f\bB\b\1\2=\b\14\a9\b\t\0009\b\15\bB\b\1\2=\b\16\a9\b\t\0009\b\17\b5\n\20\0009\v\18\0009\v\19\v=\v\21\nB\b\2\2=\b\22\a9\b\t\0009\b\23\bB\b\1\2=\b\24\aB\5\2\2=\5\t\0049\5\25\0009\5\26\0054\a\5\0005\b\27\0>\b\1\a5\b\28\0>\b\2\a5\b\29\0>\b\3\a5\b\30\0>\b\4\aB\5\2\2=\5\26\4B\2\2\0012\0\0ÄK\0\1\0\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\fsources\vconfig\14<C-Space>\rcomplete\t<CR>\rbehavior\1\0\2\vselect\2\rbehavior\0\fReplace\20ConfirmBehavior\fconfirm\n<C-n>\21select_next_item\n<C-p>\1\0\4\14<C-Space>\0\t<CR>\0\n<C-n>\0\n<C-p>\0\21select_prev_item\vinsert\vpreset\fmapping\fsnippet\1\0\3\fsnippet\0\fmapping\0\fsources\0\vexpand\1\0\1\vexpand\0\0\nsetup\fluasnip\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: vimtex
time([[Config for vimtex]], true)
try_loadstring("\27LJ\2\nk\0\0\2\0\6\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0K\0\1\0\flatexmk\27vimtex_compiler_method\fzathura\23vimtex_view_method\6g\bvim\0", "config", "vimtex")
time([[Config for vimtex]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n^\0\3\n\1\5\0\v6\3\0\0009\3\1\0039\3\2\3\18\5\0\0\18\6\1\0\18\a\2\0005\b\3\0-\t\0\0=\t\4\bB\3\5\1K\0\1\0\1¿\vbuffer\1\0\2\vsilent\2\vbuffer\0\bset\vkeymap\bvimè\3\1\2\b\0\14\0!3\2\0\0\18\3\2\0'\5\1\0'\6\2\0'\a\3\0B\3\4\1\18\3\2\0'\5\1\0'\6\4\0'\a\5\0B\3\4\1\18\3\2\0'\5\1\0'\6\6\0'\a\a\0B\3\4\1\18\3\2\0'\5\1\0'\6\b\0'\a\t\0B\3\4\1\18\3\2\0'\5\1\0'\6\n\0'\a\v\0B\3\4\1\18\3\2\0'\5\1\0'\6\f\0'\a\r\0B\3\4\0012\0\0ÄK\0\1\0&<cmd>lua vim.lsp.buf.rename()<CR>\15<leader>rn+<cmd>lua vim.lsp.buf.code_action()<CR>\15<leader>ca*<cmd>lua vim.lsp.buf.references()<CR>\agr.<cmd>lua vim.lsp.buf.implementation()<CR>\agi*<cmd>lua vim.lsp.buf.definition()<CR>\agd%<cmd>lua vim.lsp.buf.hover()<CR>\6K\6n\0Ü\1\0\1\5\2\6\0\f6\1\0\0'\3\1\0B\1\2\0028\1\0\0019\1\2\0015\3\3\0-\4\0\0=\4\4\3-\4\1\0=\4\5\3B\1\2\1K\0\1\0\0\0\1\0\17capabilities\14on_attach\1\0\2\17capabilities\0\14on_attach\0\nsetup\14lspconfig\frequireW\1\0\4\2\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\3\0003\3\3\0>\3\1\2B\0\2\1K\0\1\0\0¿\1¿\0\19setup_handlers\20mason-lspconfig\frequire—\2\1\0\6\0\16\0\"6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\4\0'\2\5\0B\0\2\0029\0\6\0B\0\1\0016\0\4\0'\2\a\0B\0\2\0029\0\6\0005\2\t\0005\3\b\0=\3\n\2B\0\2\0013\0\v\0006\1\4\0'\3\f\0B\1\2\0029\1\r\1B\1\1\0026\2\0\0009\2\14\0023\4\15\0)\5d\0B\2\3\0012\0\0ÄK\0\1\0\0\rdefer_fn\25default_capabilities\17cmp_nvim_lsp\0\21ensure_installed\1\0\1\21ensure_installed\0\1\3\0\0\vlua_ls\fpyright\20mason-lspconfig\nsetup\nmason\frequire!packadd mason-lspconfig.nvim\23packadd mason.nvim\bcmd\bvim\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
