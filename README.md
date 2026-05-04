# tempo

> A minimalist time progress tracker for your shell (zsh bash fish)

```
Day    : [################..................................] 33%                             
Week   : [##................................................] 4%
Month  : [#####.............................................] 10%
Year   : [################..................................] 33%
```

## installation

### zsh

<details>
<summary><strong>oh-my-zsh</strong></summary>

1. clone into your plugins directory:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tempo
   ```
2. add `tempo` to your `plugins` array in `.zshrc`:
   ```zsh
   plugins=(... tempo)
   ```
</details>

<details>
<summary><strong>manual</strong></summary>

1. clone the repo:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ~/tempo
   ```
2. add to your `.zshrc`:
   ```zsh
   source ~/tempo/tempo.plugin.zsh
   ```
</details>

---

### bash

<details>
<summary><strong>manual</strong></summary>

1. clone the repo:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ~/tempo
   ```
2. add to your `.bashrc`:
   ```bash
   source ~/tempo/tempo.bash
   ```
</details>

---

### fish

<details>
<summary><strong>fisher</strong></summary>

```fish
fisher install j4hongir/tempo
```
</details>

<details>
<summary><strong>manual</strong></summary>

1. clone the repo:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ~/tempo
   ```
2. symlink the Fish files:
   ```fish
   ln -s ~/tempo/functions/tempo.fish ~/.config/fish/functions/tempo.fish
   ln -s ~/tempo/completions/tempo.fish ~/.config/fish/completions/tempo.fish
   ln -s ~/tempo/conf.d/tempo.fish ~/.config/fish/conf.d/tempo.fish
   ```
</details>

## configuration

customize **tempo** by setting these variables in your shell config (`.zshrc`, `.bashrc`, or `config.fish`).

| variable | default | description |
| :--- | :--- | :--- |
| `TEMPO_AUTO_SHOW` | `true` | show progress bars on shell startup |
| `TEMPO_SHOW_ITEMS` | `day week month year` | list of items to display |
| `TEMPO_WIDTH` | `40` | total width of the progress bar |
| `TEMPO_FILLED_CHAR` | `█` | character for the filled portion |
| `TEMPO_EMPTY_CHAR` | `░` | character for the empty portion |
| `TEMPO_COLOR_STYLE` | `true` | enable progress-based coloring |

### example

**bash/zsh** (`.bashrc` / `.zshrc`):
```sh
TEMPO_WIDTH=50
TEMPO_SHOW_ITEMS="day week"
TEMPO_FILLED_CHAR="#"
TEMPO_EMPTY_CHAR="."
```

**fish** (`config.fish`):
```fish
set -g TEMPO_WIDTH 50
set -g TEMPO_SHOW_ITEMS "day week"
set -g TEMPO_FILLED_CHAR "#"
set -g TEMPO_EMPTY_CHAR "."
tempo
```

## usage

run the `tempo` command manually at any time:

```
tempo           # default items
tempo --day     # only today's progress
tempo --week    # only this week's progress
tempo --month   # only this month's progress
tempo --year    # only this year's progress
tempo --config  # View current settings
tempo --help    # Show all options
```

## license

[MIT](LICENSE)
