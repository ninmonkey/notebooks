


## Misc Dump of Git Commands

```sh
git config --global alias.ignore \
'!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi'
```

```sh
echo "function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/\$@ ;}" >> \
~/.bashrc && source ~/.bashrc

echo "function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/\$@ ;}" >> \
~/.zshrc && source ~/.zshrc

printf "function gi\n\tcurl -sL https://www.toptal.com/developers/gitignore/api/\$argv\nend\n" > \
~/.config/fish/functions/gi.fish
```