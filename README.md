<!-- markdownlint-disable MD013 MD033-->
# DOTFILES

## My dotfile config for terminal and desktop

- Desktop preview ( i3, wallpaper, polybar ) :
    [![screen shortcut](https://s1.ax1x.com/2018/10/10/iYxZkR.md.png)](https://imgchr.com/i/iYxZkR)

- Terminal Preview ( nvim tmux zsh ) :
    [Click here](https://drive.google.com/file/d/1M6_sfxfztqIchVFZFh9LQTVj-Qond7QA/view?usp=sharing) to view how this work.

### vim

`use neovim, config write as vimrc`

![image](https://user-images.githubusercontent.com/34125917/117580734-01b13480-b12c-11eb-9077-66e9c3bde13c.png)

#### My Vim Cheet Sheet (Synchronize with my vim configuration)

<table style="border-collapse: collapse;">
<colgroup>
<col width="238" />
<col width="351" />
<col width="366" />
<col width="164" />
</colgroup>
<tr height="21"><th class="cell1">Plugins</th><th class="cell1">Desc of plugin</th><th class="cell1">Func</th><th class="cell1">Key/Command</th></tr>
<tr height="21"><td class="cell2">mhinz/vim-startify</td><td class="cell2">Provide the startup page</td><td class="cell2">Open the startup page</td><td class="cell2">:Startify</td></tr>
<tr height="21"><td class="cell2">itchyny/lightline.vim
mengelbrecht/lightline-bufferline</td><td class="cell2">Show info of vim or other plugins</td><td class="cell2">Go to buffer</td><td class="cell2">&lt;leader&gt;[number]</td></tr>
<tr height="21"><td rowspan="18" class="cell2">neoclide/coc.nvim</td><td rowspan="18" class="cell2">Smart code completion, powered by <a href="https://microsoft.github.io/language-server-protocol/">LSP</a></td><td class="cell2">Open code action window</td><td class="cell2">&lt;leader&gt;ac</td></tr>
<tr height="21"><td class="cell2">Quick fix in current line</td><td class="cell2">&lt;leader&gt;qf</td></tr>
<tr height="21"><td class="cell2">Organize import</td><td class="cell2">:OR</td></tr>
<tr height="21"><td class="cell2">Go to next/previous problem</td><td class="cell2">[g / ]g</td></tr>
<tr height="21"><td class="cell2">Go to declaration</td><td class="cell2">gd</td></tr>
<tr height="21"><td class="cell2">Go to type-definition</td><td class="cell2">gy</td></tr>
<tr height="21"><td class="cell3">Go to references</td><td class="cell2">gr</td></tr>
<tr height="21"><td class="cell3">Go to implementation</td><td class="cell2">gi</td></tr>
<tr height="21"><td class="cell2">Show document in window</td><td class="cell2">K</td></tr>
<tr height="21"><td class="cell2">Select range</td><td class="cell4">&lt;C-i&gt;</td></tr>
<tr height="21"><td class="cell2">Rename symbol</td><td class="cell2">&lt;leader&gt;rn</td></tr>
<tr height="21"><td class="cell2">Format current document</td><td class="cell4">:Format</td></tr>
<tr height="21"><td class="cell2">Show all problem of current document</td><td class="cell2">&lt;leader&gt;a</td></tr>
<tr height="21"><td class="cell2">Manage extensions</td><td class="cell2">&lt;leader&gt;de</td></tr>
<tr height="21"><td class="cell2">Show helpful commands list</td><td class="cell2">&lt;leader&gt;dc</td></tr>
<tr height="21"><td class="cell2">Search symbol in current document</td><td class="cell2">&lt;leader&gt;do</td></tr>
<tr height="21"><td class="cell2">Search symbols in workspace</td><td class="cell2">&lt;leader&gt;ds</td></tr>
<tr height="21"><td class="cell2">Do default action for next/previous item.</td><td class="cell2">&lt;leader&gt;dj / &lt;leader&gt;dk</td></tr>
<tr height="26"><td rowspan="4" class="cell2">voldikss/vim-translator</td><td rowspan="4" class="cell2">Translate tool</td><td class="cell2">Translate in status bar</td><td class="cell2">:'&lt;,'&gt;Translate</td></tr>
<tr height="26"><td class="cell2">Translate and replace</td><td class="cell2">:'&lt;,'&gt;TranslateR</td></tr>
<tr height="26"><td class="cell2">Translate in window</td><td class="cell2">:'&lt;,'&gt;TranslateW</td></tr>
<tr height="26"><td class="cell2">Translate text in clipboard, show in status bar</td><td class="cell2">:'&lt;,'&gt;TranslateX</td></tr>
<tr height="21"><td rowspan="4" class="cell2">junegunn/vim-easy-align</td><td rowspan="4" class="cell2">Text alignment tool</td><td class="cell2">Align in range around the char, eg:'='.</td><td class="cell2">[Select Range] ga=</td></tr>
<tr height="21"><td class="cell2">Align around the (n)th '='</td><td class="cell2">[Select Range] ga2=</td></tr>
<tr height="21"><td class="cell2">Align around all '=' occurrences</td><td class="cell2">[Select Range] ga*=</td></tr>
<tr height="21"><td class="cell2">Align markdown table</td><td class="cell2">[Select Range] ga*|</td></tr>
<tr height="21"><td rowspan="3" class="cell2">easymotion/vim-easymotion</td><td rowspan="3" class="cell2">Fast moving in the document</td><td class="cell2">Move via Char / Word</td><td class="cell2">&lt;leader&gt;f / &lt;leader&gt; w</td></tr>
<tr height="21"><td class="cell2">Move to line</td><td class="cell2">&lt;leader&gt;L</td></tr>
<tr height="21"><td class="cell2">Move to char*2</td><td class="cell2">s{char}{char}</td></tr>
</table>

### i3

`my personal configuration for i3-gaps+polybar`

#### current plugin apps

1. polybar     - a third party status bar to replace i3-wm default status bar
2. rofi        - apps menu to replace dmenu
3. scrot       - binding with shortcut keys to take screen shortcut
4. terminology - a Sci-fi style terminal
5. feh         - watch pic in term and set wllpaper
6. i3lock      - fancy - screen lock tool
7. compton     - got transparent feature running
8. ranger      - term tool to watch local file

