# dda.vim

> Dark deno-powered AI plugin for neovim/Vim8

If you don't want to configure plugins, you don't have to use the plugin. It
does not work with zero configuration. You can use other plugins.

[![Doc](https://img.shields.io/badge/doc-%3Ah%20dda-orange.svg)](doc/dda.txt)

Please read [help](doc/dda.txt) for details.

Dda is the abbreviation of "dark deno-powered AI". It provides an
extensible and asynchronous AI features for neovim/Vim8.

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
- [Install](#install)
  - [Requirements](#requirements)
- [Configuration](#configuration)
- [Screenshots](#screenshots)

<!-- vim-markdown-toc -->

## Introduction

I have chosen denops.vim framework to create new plugin. Because denops.vim is
better than neovim Python interface.

- Easy to setup
- Minimal dependency
- Stability
- neovim/Vim8 compatibility
- Speed
- Library
- Easy to hack

## Install

**Note:** Dda.vim requires Neovim (0.8.0+ and of course, **latest** is
recommended) or Vim 8.2.0662. See [requirements](#requirements) if you aren't
sure whether you have this.

For vim-plug

```vim
call plug#begin()

Plug 'Shougo/dda.vim'
Plug 'vim-denops/denops.vim'

call plug#end()
```

For dein.vim

```vim
call dein#begin()

call dein#add('Shougo/dda.vim')
call dein#add('vim-denops/denops.vim')

call dein#end()
```

### Requirements

Dda.vim requires both Deno and denops.vim.

- <https://deno.land/>
- <https://github.com/vim-denops/denops.vim>

## Configuration

```vim
```

See `:help dda-options` for a complete list of options.

## Screenshots

## Plans
