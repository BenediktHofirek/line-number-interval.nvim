# Line Number Interval for Neovim

Highlight line number by each XX lines.

[![Run tests](https://github.com/IMOKURI/line-number-interval.nvim/actions/workflows/tests.yaml/badge.svg)](https://github.com/IMOKURI/line-number-interval.nvim/actions/workflows/tests.yaml)
[![codecov](https://codecov.io/gh/IMOKURI/line-number-interval.nvim/branch/master/graph/badge.svg?token=hyQegcbxMB)](https://codecov.io/gh/IMOKURI/line-number-interval.nvim)

## Screenshots

### set number

![highlight-line-number](https://user-images.githubusercontent.com/1638500/66444757-6b181f80-ea7f-11e9-8d26-20768193934e.gif)

### set relativenumber

![highlight-line-relative-number](https://user-images.githubusercontent.com/1638500/66444779-79663b80-ea7f-11e9-8c97-8fbd0552c6ca.gif)

### set relativenumber with custom interval (fibonacci sequence)

![highlight-line-relative-number-custom](https://user-images.githubusercontent.com/1638500/66466246-565a7c80-eabd-11e9-9ca8-1db2b0160c0a.gif)

### set multiple colors with custom interval (1 to 5 and 10, 20, ...)

![multiple-colors](https://user-images.githubusercontent.com/1638500/147657256-5d4fb680-1daa-4934-a2cc-54c4ec018f89.gif)

## Requirements

- Neovim 0.3.2

## Configurations

``` vim
" Enable line number interval at startup. (default: 0(disable))
let g:line_number_interval_enable_at_startup = 1

" Set interval to highlight line number. (default: 10)
let g:line_number_interval = 5

" Set color to highlight and dim.
" (default: HighlightedLineNr use LineNr color,
"           DimLineNr use same as background color (it seems hide).)
highlight HighlightedLineNr guifg=White ctermfg=7
highlight DimLineNr guifg=Magenta ctermfg=5

" Enable to use custom interval. (default: 0(disable))
" This option is only for relativenumber.
let g:line_number_interval#use_custom = 1

" Set custom interval list.
" (default: fibonacci sequence ([1, 2, 3, 5, 8, 13, 21, 34, 55, ...]))
" This option is only for relativenumber.
let g:line_number_interval#custom_interval = [1,2,3,4,5,10,20,30,40,50,60,70,80,90]

" Additional highlight
" Use those colors for Nth (1st ~ 9th) element of custom interval.
highlight HighlightedLineNr1 guifg=Yellow ctermfg=3
highlight HighlightedLineNr2 guifg=Green ctermfg=2
highlight HighlightedLineNr3 guifg=Cyan ctermfg=6
highlight HighlightedLineNr4 guifg=Blue ctermfg=4
highlight HighlightedLineNr5 guifg=Magenta ctermfg=5
" highlight HighlightedLineNr6 guifg=White ctermfg=7
" highlight HighlightedLineNr7 guifg=White ctermfg=7
" highlight HighlightedLineNr8 guifg=White ctermfg=7
" highlight HighlightedLineNr9 guifg=White ctermfg=7
```

## Commands

- `LineNumberIntervalEnable`: Enable line number interval.
- `LineNumberIntervalDisable`: Disable line number interval.
- `LineNumberIntervalToggle`: Toggle line number interval.

## FAQ

Q. Can I hide folded line number?

A. Unfortunately, it's not possible.
The whole line belongs to the `Folded` highlight group.

Q. Can I use this plugin for Vim?

A. Unfortunately, no.
This plugin uses `numhl` highlight group of `sign` feature.
Vim has not this highlight group...
