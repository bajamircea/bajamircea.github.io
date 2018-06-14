---
layout: post
title: 'Basic coding tools configs'
categories: coding tools
---

Basic coding tools configuration: git, vim, tmux (to hit the ground running on
a new system).

# ~/.gitconfig

Colors, use `vim`, better `git log`:

{% highlight conf %}
[color]
	ui = true
[user]
	name = John Doe
	email = john.doe@example.com
[core]
	editor = vim
[push]
	default = simple
[alias]
	graph = !"git log --graph --decorate --pretty=short --abbrev-commit --stat -m"
{% endhighlight %}

# ~/.vimrc

Use 2 spaces instead of tabs (the minimum number of spaces perceived as
indent), use UTF-8, no swap files, some auto indentation.

{% highlight conf %}
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent off      " load file type plugins + indentation
set autoindent
set noswapfile

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2 softtabstop=2 " a tab is two spaces
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Set chars for :set list
set listchars=tab:→\ ,eol:¬,trail:·
set list

" Save before running make
set autowrite

if &term == "linux"
  colorscheme peachpuff
endif

set tw=79
set timeoutlen=1000 ttimeoutlen=0

" e.g. type 'CTRL-K ia' for â
dig aA 258 " Ă
dig aa 259 " ă
dig iA 194 " Â
dig ia 226 " â
dig iI 206 " Î
dig ii 238 " î
dig sS 536 " Ș
dig ss 537 " ș
dig tT 538 " Ț
dig tt 539 " ț

{% endhighlight %}

# ~/.tmux.conf

Use `vim` key bindings in `tmux`.

{% highlight conf %}
set-window-option -g mode-keys vi
{% endhighlight %}


Also see [a starter makefile][starter-makefile].

[starter-makefile]:    {% post_url 2016-06-09-starter-cpp-program-makefile %}

