0=${(%):-%N}
TEMPO_DIR="${0:A:h}"
source "${TEMPO_DIR}/tempo.sh"

if (( $+functions[compdef] )); then
    _tempo_completion() {
        local -a options
        options=(
            '(-d --day)'{-d,--day}'[Show day progress]'
            '(-w --week)'{-w,--week}'[Show week progress]'
            '(-m --month)'{-m,--month}'[Show month progress]'
            '(-y --year)'{-y,--year}'[Show year progress]'
            '(-c --config)'{-c,--config}'[Show current configuration]'
            '(-h --help)'{-h,--help}'[Show help message]'
        )
        _describe 'tempo' options
    }
    compdef _tempo_completion tempo
fi

autoload -Uz add-zsh-hook

_tempo_init() {
    if [ "$(_tempo_get_config TEMPO_AUTO_SHOW true)" = "true" ]; then
        tempo
    fi
    add-zsh-hook -d precmd _tempo_init
}

if [[ -t 1 ]]; then
    add-zsh-hook precmd _tempo_init
fi
