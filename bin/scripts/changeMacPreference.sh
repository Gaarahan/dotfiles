# use defaults command to change MacOS preference
# https://support.apple.com/guide/terminal/edit-property-lists-apda49a1bb2-577e-4721-8f25-ffc0836f6997/mac
# After we change preference via defaults command, we should do logout and login

running "autohide dock"
defaults write com.apple.dock autohide -bool true
ok

running "Don't re-range work-spaces"
defaults write com.apple.dock mru-spaces -bool false
ok

running "Disable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
ok

running "Always show hidden file in finder"
defaults write com.apple.finder AppleShowAllFiles -bool true 
ok


running "Enable tap to click"
defaults write com.apple.mouse.tapBehavior -int 0
ok

bot "Config Success! Restart your Mac to see the changes."
