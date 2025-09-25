local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end,
    -- Ensure nvim-treesitter-textobjects is loaded after nvim-treesitter
    'nvim-treesitter/nvim-treesitter-textobjects'
  }
  use {"ThePrimeagen/vim-be-good"}
  use {"szymonwilczek/vim-be-better"}
  use {"neovim/nvim-lspconfig"}
  use {"RedsXDD/neopywal.nvim", as = "neopywal"}

  use { 
      "lervag/vimtex",
      config = function()
          vim.g.vimtex_view_method = 'zathura'
          vim.g.vimtex_compiler_method = 'latexmk'
      end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
