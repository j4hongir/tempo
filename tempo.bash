TEMPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TEMPO_DIR}/tempo.sh"

_tempo_bash_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "-d --day -w --week -m --month -y --year -c --config -h --help" -- "$cur") )
}
complete -F _tempo_bash_completion tempo

_tempo_bash_init() {
    if [ "$(_tempo_get_config TEMPO_AUTO_SHOW true)" = "true" ]; then
        tempo
    fi
    PROMPT_COMMAND="${PROMPT_COMMAND//_tempo_bash_init;/}"
    PROMPT_COMMAND="${PROMPT_COMMAND//_tempo_bash_init/}"
}

if [ -t 1 ]; then
    if [ -n "$PROMPT_COMMAND" ]; then
        PROMPT_COMMAND="_tempo_bash_init;${PROMPT_COMMAND}"
    else
        PROMPT_COMMAND="_tempo_bash_init"
    fi
fi
