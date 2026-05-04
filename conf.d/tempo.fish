if status is-interactive
    function _tempo_greeting --on-event fish_greeting
        if test (_tempo_get_config TEMPO_AUTO_SHOW true) = "true"
            tempo
        end
    end
end
