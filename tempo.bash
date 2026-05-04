TEMPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TEMPO_DIR}/tempo.sh"

_tempo_bash_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "-d --day -w --week -m --month -y --year -a --all -c --config -h --help" -- "$cur") )
}
complete -F _tempo_bash_completion tempo

[[ -t 1 && $- == *i* ]] && [[ "${TEMPO_AUTO:-true}" = "true" ]] && tempo
