function _tempo_get_config
    set -l var_name $argv[1]
    set -l default_val $argv[2]
    set -l legacy_name (string replace 'TEMPO_' 'TBT_' $var_name)

    if set -q $var_name; and test -n "$$var_name"
        echo $$var_name
    else if set -q $legacy_name; and test -n "$$legacy_name"
        echo $$legacy_name
    else
        echo $default_val
    end
end

function _tempo_draw
    set -l val $argv[1]
    set -l max $argv[2]
    set -l label $argv[3]

    set -l width (_tempo_get_config TEMPO_WIDTH 40)
    set -l char_filled (_tempo_get_config TEMPO_FILLED_CHAR "█")
    set -l char_empty (_tempo_get_config TEMPO_EMPTY_CHAR "░")
    set -l use_color (_tempo_get_config TEMPO_COLOR_STYLE "true")

    set -l percent (math "$val * 100 / $max")
    test $percent -gt 100; and set percent 100

    set -l filled (math "$width * $percent / 100")
    set -l empty (math "$width - $filled")

    set -l bar_filled ""
    set -l bar_empty ""
    for i in (seq $filled)
        set bar_filled "$bar_filled$char_filled"
    end
    for i in (seq $empty)
        set bar_empty "$bar_empty$char_empty"
    end

    set -l pad_size (math "7 - "(string length $label))
    set -l padding ""
    for i in (seq $pad_size)
        set padding "$padding "
    end

    set -l color ""
    set -l reset ""
    if test "$use_color" = "true"
        set reset '\033[0m'
        if test $percent -ge 90
            set color '\033[31m'
        else if test $percent -ge 70
            set color '\033[33m'
        else
            set color '\033[34m'
        end
    end

    printf '%s%s: [%b%s%b%s] %d%%\n' $label $padding $color $bar_filled $reset $bar_empty $percent
end

function _tempo_seconds_today
    set -l h (date +%H | string replace -r '^0' '')
    set -l m (date +%M | string replace -r '^0' '')
    set -l s (date +%S | string replace -r '^0' '')
    test -z "$h"; and set h 0
    test -z "$m"; and set m 0
    test -z "$s"; and set s 0
    math "$h * 3600 + $m * 60 + $s"
end

function _tempo_days_in_month
    set -l ym (date +%Y-%m-01)
    set -l dim (date -d "$ym +1 month -1 day" +%d 2>/dev/null; or gdate -d "$ym +1 month -1 day" +%d 2>/dev/null; or echo 30)
    echo $dim | string replace -r '^0' ''
end

function _tempo_is_leap_year
    set -l yr (date +%Y)
    if test (math "$yr % 4") -eq 0; and begin; test (math "$yr % 100") -ne 0; or test (math "$yr % 400") -eq 0; end
        echo 366
    else
        echo 365
    end
end

function _tempo_calc_day
    set -l curr (_tempo_seconds_today)
    _tempo_draw $curr 86400 "Day"
end

function _tempo_calc_week
    set -l dow (date +%u)
    set -l curr (math "($dow - 1) * 86400 + "(_tempo_seconds_today))
    _tempo_draw $curr 604800 "Week"
end

function _tempo_calc_month
    set -l day (date +%d | string replace -r '^0' '')
    test -z "$day"; and set day 0
    set -l dim (_tempo_days_in_month)
    set -l curr (math "($day - 1) * 86400 + "(_tempo_seconds_today))
    _tempo_draw $curr (math "$dim * 86400") "Month"
end

function _tempo_calc_year
    set -l doy (date +%j | string replace -r '^0+' '')
    test -z "$doy"; and set doy 0
    set -l diy (_tempo_is_leap_year)
    set -l curr (math "($doy - 1) * 86400 + "(_tempo_seconds_today))
    _tempo_draw $curr (math "$diy * 86400") "Year"
end

function tempo -d "Minimalist time progress tracker"
    set -l items (string split ' ' (_tempo_get_config TEMPO_SHOW_ITEMS "day week month year"))

    if test (count $argv) -eq 0
        for item in $items
            switch $item
                case day daily;     _tempo_calc_day
                case week weekly;   _tempo_calc_week
                case month monthly; _tempo_calc_month
                case year yearly;   _tempo_calc_year
            end
        end
        return
    end

    switch $argv[1]
        case -d --day;    _tempo_calc_day
        case -w --week;   _tempo_calc_week
        case -m --month;  _tempo_calc_month
        case -y --year;   _tempo_calc_year
        case -c --config
            echo "Tempo Configuration:"
            echo "  TEMPO_AUTO_SHOW   = "(_tempo_get_config TEMPO_AUTO_SHOW true)
            echo "  TEMPO_WIDTH       = "(_tempo_get_config TEMPO_WIDTH 40)
            echo "  TEMPO_SHOW_ITEMS  = "(_tempo_get_config TEMPO_SHOW_ITEMS 'day week month year')
            echo "  TEMPO_FILLED_CHAR = "(_tempo_get_config TEMPO_FILLED_CHAR '█')
            echo "  TEMPO_EMPTY_CHAR  = "(_tempo_get_config TEMPO_EMPTY_CHAR '░')
            echo "  TEMPO_COLOR_STYLE = "(_tempo_get_config TEMPO_COLOR_STYLE true)
        case -h --help
            echo "Usage: tempo [OPTION]"
            echo "Display time progress bars"
            echo ""
            echo "Options:"
            echo "  -d, --day      Show day progress"
            echo "  -w, --week     Show week progress"
            echo "  -m, --month    Show month progress"
            echo "  -y, --year     Show year progress"
            echo "  -c, --config   Show current configuration"
            echo "  -h, --help     Show this help message"
        case '*'
            echo "Unknown option: $argv[1]. Try 'tempo --help'."
            return 1
    end
end
