# Overview
ExcelLikeVim provides vim-like interface for Excel.  
ExcelLikeVim aims to provide
* Vim-like key mapping which has mode notion and is customizable(in ~/vimx/user_configure.bas).
* Extensible plugin system. By default, some plugins are mimicked and included from popular vim plugin like unite.

# Installation
Download *the latest vimx.xlam* file from the link below.
Then register vimx.xlam as Excel addin.

That's it.
Now you can use Excel like vim!

Also you may download the full project to modify some code.
```bash
git clone https://github.com/kojinho10/ExcelLikeVim.git
```

# Features
* In normal-mode 'hjkl' to move around cells and some other operations.
* To edit values in a cell, enter insert mode by typing 'i' in normal-mode
* You can execute function with a string in command-mode entered by typing ':'in normal-mode
* You can select cells in visual mode entered by 'v' in normal-mode
Please see the section Default Key bindings for more detailed list you can do.

# Default Keybindings
| Mode       | Keystroke | Function name                   |
| ---------- | :-------  | :------------------------------ |
| Normal     | `h`       | move_left
| Normal     | `j`         | move_down
| Normal     | `k`         | move_up
| Normal     | `l`         | move_right
| Normal     | `gg`        | gg
| Normal     | `G`         | G
| Normal     | `w`         | vim_w
| Normal     | `b`         | vim_b
| Normal     | `<c-u>`     | scroll_up
| Normal     | `<c-d>`     | scroll_down
| Normal     | `^`         | move_head
| Normal     | `$`         | move_tail
|
| Normal     | `i`         | insert_mode
| Normal     | `a`         | insert_mode
| Normal     | `v`         | n_v
| Normal     | `V`         | n_v_
| Normal     | `:`         | command_vim
| Normal     | `*`         | unite command
|
| Normal     | `/`         | find
| Normal     | `n`         | findNext
| Normal     | `N`         | findPrevious
|
| Normal     | `o`         | insertRowDown
| Normal     | `O`         | insertRowUp
| Normal     | `dd`        | n_dd
| Normal     | `dc`        | n_dc
| Normal     | `yy`        | n_yy
| Normal     | `yv`        | yank_value
| Normal     | `p`         | n_p
| Normal     | `u`         | n_u
| Normal     | `<ESC>`     | n_ESC
|
| Visual     | `<ESC>`     | v_ESC
|
| Visual     | `j`         | v_j
| Visual     | `k`         | v_k
| Visual     | `h`         | v_h
| Visual     | `l`         | v_l
| Visual     | `gg`        | v_gg
| Visual     | `G`         | v_G
| Visual     | `w`         | v_w
| Visual     | `b`         | v_b
| Visual     | `<c-u>`     | v_scroll_up
| Visual     | `<c-d>`     | v_scroll_down
| Visual     | `^`         | v_move_head
| Visual     | `$`         | v_move_tail
| Visual     | `a`         | v_a
| Visual     | `<HOME>`    | v_move_head
| Visual     | `<END>`     | v_move_tail
|
| Visual     | `:`         | command_vim
| Visual     | `y`         | v_y
| Visual     | `d`         | v_d
| Visual     | `D`         | v_D_
| Visual     | `x`         | v_x
|
| LineVisual | `j`         | v_j
| LineVisual | `k`         | v_k
| LineVisual | `gg`        | v_gg
| LineVisual | `G`         | v_G
| LineVisual | `<ESC>`     | v_ESC
| LineVisual | `y`         | v_y
| LineVisual | `d`         | lv_d
| LineVisual | `x`         | lv_d

# You can customize the keymapping by ~/vimx/user_configure.bas
you can customize mapping and behaviror of some function through setting option.
### Example configuration of user_configure.bas
```vb
Attribute VB_Name = "user_configure"

Public Sub init()
	Application.Cursor = xlNorthwestArrow
	Call SetAppEvent
	Call keystrokeAsseser.init
	call vimize.main
	call mykeymap
	application.onkey "{F3}", "coreloader.reload"
End Sub 

private sub mykeymap()
	Call nmap("<HOME>", "move_head")
	Call nmap("<END>", "move_tail")
	Call nmap("t", "insertColumnRight")
	Call nmap("T", "insertColumnLeft")
	Call nmap(";n", "InteriorColor(0)")
	Call nmap(";r", "InteriorColor(3)")
	Call nmap(";b", "InteriorColor(5)")
	Call nmap(";y", "InteriorColor(6)")
	Call nmap(";d", "InteriorColor(15)")
	Call nmap("m", "merge")
	Call nmap("M", "unmerge")
	Call nmap(">", "biggerFonts")
	Call nmap("<", "smallerFonts")
	Call nmap("z", "SetRuledLines")
	Call nmap("Z", "UnsetRuledLines")
	Call nmap("F9", "toggleVimKeybinde")
	Call nmap("F10", "-a updatemodules(ActiveWorkbook.Name)")
	Call nmap("<c-r>", "update")
	Call nmap("+", "ZoomInWindow")
	Call nmap("-", "ZoomOutWindow")
	Call nmap("gs", "SortCurrentColumn")
	Call nmap("gF", "focusFromScratch")
	Call nmap("gf", "focus")
	Call nmap("g-", "exclude")
	Call nmap("gc", "filterOff")
	Call nmap("H", "ex_left")
	Call nmap("J", "ex_below")
	Call nmap("K", "ex_up")
	Call nmap("L", "ex_right")
	Call nmap(",m", "unite mru")
	Call nmap(",s", "unite sheet")
	Call nmap(",b", "unite book")
	Call nmap(",p", "unite project")
	Call nmap(",f", "unite filter")
	Call nmap("tl", "ActivateLeftSheet")
	Call nmap("th", "ActivateRightSheet")
	Call nmap("tL", "ActivateLastSheet")
	Call nmap("tH", "ActivateFirstSheet")
	Call vmap("<HOME>", "v_move_head")
	Call vmap("<END>", "v_move_tail")
	Call vmap(";n", "visual_operation InteriorColor(0)")
	Call vmap(";r", "visual_operation InteriorColor(3)")
	Call vmap(";b", "visual_operation InteriorColor(5)")
	Call vmap(";y", "visual_operation InteriorColor(6)")
	Call vmap(";d", "visual_operation InteriorColor(15)")
	Call vmap("m", "visual_operation merge")
	Call vmap("M", "visual_operation unmerge")
	Call vmap(">", "visual_operation biggerFonts")
	Call vmap("<", "visual_operation smallerFonts")
	Call vmap("z", "visual_operation SetRuledLines")
	Call vmap("Z", "visual_operation UnsetRuledLines")
	Call lvmap(";n", "visual_operation InteriorColor(0)")
	Call lvmap(";r", "visual_operation InteriorColor(3)")
	Call lvmap(";b", "visual_operation InteriorColor(5)")
	Call lvmap(";y", "visual_operation InteriorColor(6)")
	Call lvmap(";d", "visual_operation InteriorColor(15)")
	Call lvmap("m", "visual_operation merge")
	Call lvmap("M", "visual_operation unmerge")
	Call lvmap(">", "visual_operation biggerFonts")
	Call lvmap("<", "visual_operation smallerFonts")
	Call lvmap("z", "visual_operation SetRuledLines")
	Call lvmap("Z", "visual_operation UnsetRuledLines")
end sub
```

# Contributing
Nice that you want to spend some time improving this Addin.
Solving issues is always appreciated.
If you're going to add a feature, it would be best to [submit an issue](https://github.com/kojinho10/ExcelLikeVim/issues).
