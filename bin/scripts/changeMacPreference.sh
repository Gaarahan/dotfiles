# use defaults command to change MacOS preference
# https://support.apple.com/guide/terminal/edit-property-lists-apda49a1bb2-577e-4721-8f25-ffc0836f6997/mac
# After we change preference via defaults command, we should restart the process we changed; But now we can't find some process via Activity Monitor（eg. Dock）, consider use htop? Or just resart.

running "autohide dock"
defaults write com.apple.dock autohide -bool true
ok

running "Don't re-range work-spaces"
defaults write com.apple.dock mru-spaces -bool false
ok

running "Disable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
ok

bot "Config Success! Restart your Mac to see the changes."
