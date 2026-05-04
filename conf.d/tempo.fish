if status is-interactive
    set -l auto true
    set -q TEMPO_AUTO; and set auto $TEMPO_AUTO
    test "$auto" = "true"; and tempo
end
