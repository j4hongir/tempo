# tempo

> minimalist time progress tracker for your shell

```
Day    : [################..................................] 33%
Week   : [#########.........................................] 19%
```
  
## install

### zsh

<details>
<summary><strong>oh-my-zsh</strong></summary>

```bash
git clone https://github.com/j4hongir/tempo.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tempo
```

add `tempo` to your plugins in `.zshrc`:

```zsh
plugins=(... tempo)
```

</details>
<details>
<summary><strong>zinit</strong></summary>

```zsh
zinit light j4hongir/tempo
```

</details>
<details>
<summary><strong>manual</strong></summary>

```bash
git clone https://github.com/j4hongir/tempo.git ~/tempo 
echo 'source ~/tempo/tempo.plugin.zsh' >> ~/.zshrc
```

</details>

### bash
```bash
git clone https://github.com/j4hongir/tempo.git ~/tempo
echo 'source ~/tempo/tempo.bash' >> ~/.bashrc
```

### fish
<details>
<summary><strong>fisher</strong></summary>

```fish
fisher install j4hongir/tempo
```

</details>
<details>
<summary><strong>manual</strong></summary>

```bash
git clone https://github.com/j4hongir/tempo.git ~/tempo
ln -s ~/tempo/functions/tempo.fish ~/.config/fish/functions/tempo.fish
ln -s ~/tempo/completions/tempo.fish ~/.config/fish/completions/tempo.fish
ln -s ~/tempo/conf.d/tempo.fish ~/.config/fish/conf.d/tempo.fish
```

</details>

## usage

```
tempo # all progress bars
tempo -d # day only
tempo -w # week only
tempo -m # month only
tempo -y # year only
tempo -a # all (explicit)
tempo -c # show config
tempo -h # help
```

## config

set in `.bashrc` / `.zshrc` / `config.fish`:


| variable | default | description |
| :------------ | :------ | :---------- |
| `TEMPO_WIDTH` | `40` | bar width |
| `TEMPO_FILLED` | `#` | filled character |
| `TEMPO_EMPTY` | `.` | empty character |
| `TEMPO_COLOR` | `true` | color output |
| `TEMPO_ITEMS` | `day week month year` | items to show |
| `TEMPO_AUTO` | `true` | auto-show on startup |

**bash/zsh:**
```sh
export TEMPO_WIDTH=50
export TEMPO_ITEMS="day week"
source ~/tempo/tempo.plugin.zsh
```
**fish:**
```fish
set -g TEMPO_WIDTH 50
set -g TEMPO_ITEMS="day week"
```

## license
[MIT](LICENSE)
