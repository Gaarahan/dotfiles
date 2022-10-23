> Source: http://zsh.sourceforge.net/Guide/zshguide04.html#l93

# Chapter 4: The Z-Shell Line Editor

zle(zsh行编辑器，zsh line editor)
可能是你开始在shell中输入命令时，使用的第一部分功能。甚至大多数像sh这样的基础shell，也提供了一些编辑的能力，虽然这些能力可能只是系统自身做的事---输入字符，删除最后一个字符，删除整行。现在你用到的大多数shell都做的比这更多。而在zsh下你甚至可以使用shell函数扩展编辑器命令集。

## 关于zle

zsh行编辑器通常缩写为`zle`. 通常情况下,在任何交互式的shell中它都会自启动,除非你需要修改它的行为,否则的话你不需要做任何特殊的事.如果一切正常,并且你对zle的启动方式不感兴趣的话,你可以跳转到下一个子部分.

如今,zle存在在它自己的可加载模块(zsh/zle)
中,节省了非交互shell中使用编辑器的开销.然而,你通常不需要担心它,shell会知道你在何时需要zle并且会自动的提供给你,我们将在[第七章](http://zsh.sourceforge.net/Guide/zshguide07.html#ragbag)深入讨论模块.通常zle模块位于类似`/usr/local/lib/zsh/4.0.4/zsh/zle.so`的目录中(`4.0.4`为版本号,与`$ZSH_VERSION`的值相同),去除后面的后缀`.so`就是模块的名字了.后缀名也有可能是`.sl`(HP-UX)
或 `.dll`(Cygwin),`.so`是最通用的格式.这些不同是因为zsh需要对动态可加载库(在unix中称为`共享对象`)保持与操作系统相同的约定.

如果shell安装的有问题,你有时会看到一些报错信息,或者`bindkey`之类的命令不能被加载.这意味着shell不能在模块加载路径($module_path,数组)中找到`zsh/zle`
.如果你刚刚编译好zsh就发现了这个问题,那是因为你还得在运行shell之前安装模块.你可以使用`make install.module`来进行安装,在你安装完之后,zsh就会从模块所在地运行它.

zle与bash的行编辑器`readline`不同,`readline`是一个独立的库,而zle是shell的一部分.因此,你可以通过在`.zshrc`中添加命令来配置它.因为它只对交互式shell有用,所以只有`/etc/zshrc`
与`.zshrc`对达成配置目的有效.

  

