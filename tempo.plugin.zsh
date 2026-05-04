0=${(%):-%N}
TEMPO_DIR="${0:A:h}"
source "${TEMPO_DIR}/tempo.sh"

if (( $+functions[compdef] )); then
    _tempo_completion() {
        local -a opts
        opts=(
            {-d,--day}'[Day progress]'
            {-w,--week}'[Week progress]'
            {-m,--month}'[Month progress]'
            {-y,--year}'[Year progress]'
            {-a,--all}'[All progress bars]'
            {-c,--config}'[Configuration]'
            {-h,--help}'[Help]'
        )
        _describe 'tempo' opts
    }
    compdef _tempo_completion tempo
fi

[[ -t 1 && -o interactive ]] && [[ "${TEMPO_AUTO:-true}" = "true" ]] && tempo
