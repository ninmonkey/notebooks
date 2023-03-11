### Git Topics

git commands

| command        | description                                                          |
| -------------- | -------------------------------------------------------------------- |
| `git add`      | Add file contents to the index                                       |
| `git add -p`   | Interactively add hunks of patch between the index and the work tree |
| `git checkout` | Switch branches or restore working tree files                        |
| <!--           | `git clone --depth 1 --filter=blob:none --no-checkout`  -->          |

| `git reflog 
# partial git clone of a repository using folder Cat


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