# Tempo

> A minimalist time progress tracker for your shell — supports **Zsh**, **Bash**, and **Fish**.

```
Day    : [################..................................] 33%                             
Week   : [##................................................] 4%
Month  : [#####.............................................] 10%
Year   : [################..................................] 33%
```

## Installation

### Zsh

<details>
<summary><strong>Oh My Zsh</strong></summary>

1. Clone into your plugins directory:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tempo
   ```
2. Add `tempo` to your `plugins` array in `.zshrc`:
   ```zsh
   plugins=(... tempo)
   ```
</details>

<details>
<summary><strong>Manual (Zsh)</strong></summary>

1. Clone the repo:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ~/tempo
   ```
2. Add to your `.zshrc`:
   ```zsh
   source ~/tempo/tempo.plugin.zsh
   ```
</details>

---

### Bash

<details>
<summary><strong>Manual (Bash)</strong></summary>

1. Clone the repo:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ~/tempo
   ```
2. Add to your `.bashrc`:
   ```bash
   source ~/tempo/tempo.bash
   ```
</details>

---

### Fish

<details>
<summary><strong>Fisher</strong></summary>

```fish
fisher install j4hongir/tempo
```
</details>

<details>
<summary><strong>Manual (Fish)</strong></summary>

1. Clone the repo:
   ```bash
   git clone https://github.com/j4hongir/tempo.git ~/tempo
   ```
2. Symlink the Fish files:
   ```fish
   ln -s ~/tempo/functions/tempo.fish ~/.config/fish/functions/tempo.fish
   ln -s ~/tempo/completions/tempo.fish ~/.config/fish/completions/tempo.fish
   ln -s ~/tempo/conf.d/tempo.fish ~/.config/fish/conf.d/tempo.fish
   ```
</details>

## Configuration

Customize Tempo by setting these variables in your shell config (`.zshrc`, `.bashrc`, or `config.fish`).

| Variable | Default | Description |
| :--- | :--- | :--- |
| `TEMPO_AUTO_SHOW` | `true` | Show progress bars on shell startup |
| `TEMPO_SHOW_ITEMS` | `day week month year` | List of items to display |
| `TEMPO_WIDTH` | `40` | Total width of the progress bar |
| `TEMPO_FILLED_CHAR` | `█` | Character for the filled portion |
| `TEMPO_EMPTY_CHAR` | `░` | Character for the empty portion |
| `TEMPO_COLOR_STYLE` | `true` | Enable progress-based coloring |

### Example

**Bash / Zsh** (`.bashrc` / `.zshrc`):
```sh
TEMPO_WIDTH=50
TEMPO_SHOW_ITEMS="day week"
TEMPO_FILLED_CHAR="#"
TEMPO_EMPTY_CHAR="."
```

**Fish** (`config.fish`):
```fish
set -g TEMPO_WIDTH 50
set -g TEMPO_SHOW_ITEMS "day week"
set -g TEMPO_FILLED_CHAR "#"
set -g TEMPO_EMPTY_CHAR "."
```

## Usage

Run the `tempo` command manually at any time:

```
tempo           # Show default items
tempo --day     # Show only today's progress
tempo --week    # Show only this week's progress
tempo --month   # Show only this month's progress
tempo --year    # Show only this year's progress
tempo --config  # View current settings
tempo --help    # Show all options
```

## License

[MIT](LICENSE)
