set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
luafile ~/.config/nvim/lua/init.lua
