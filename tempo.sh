#!/bin/sh

_tempo_get_config() {
    _var_name=$1
    _default_val=$2
    _legacy_name=$(printf '%s' "$_var_name" | sed 's/TEMPO_/TBT_/')

    eval "_val=\"\${$_var_name}\""
    if [ -z "$_val" ]; then
        eval "_val=\"\${$_legacy_name}\""
    fi

    printf '%s' "${_val:-$_default_val}"
}

_tempo_draw() {
    _val=$1
    _max=$2
    _label=$3

    _width=$(_tempo_get_config TEMPO_WIDTH 40)
    _char_filled=$(_tempo_get_config TEMPO_FILLED_CHAR "█")
    _char_empty=$(_tempo_get_config TEMPO_EMPTY_CHAR "░")
    _use_color=$(_tempo_get_config TEMPO_COLOR_STYLE "true")

    _percent=$((_val * 100 / _max))
    [ "$_percent" -gt 100 ] && _percent=100

    _filled=$((_width * _percent / 100))
    _empty=$((_width - _filled))

    _bar_filled=""
    _bar_empty=""
    _i=0
    while [ "$_i" -lt "$_filled" ]; do
        _bar_filled="${_bar_filled}${_char_filled}"
        _i=$((_i + 1))
    done
    _i=0
    while [ "$_i" -lt "$_empty" ]; do
        _bar_empty="${_bar_empty}${_char_empty}"
        _i=$((_i + 1))
    done

    _pad_size=$((7 - ${#_label}))
    _padding=""
    _i=0
    while [ "$_i" -lt "$_pad_size" ]; do
        _padding="${_padding} "
        _i=$((_i + 1))
    done

    _color=""
    _reset=""
    if [ "$_use_color" = "true" ]; then
        _reset='\033[0m'
        if [ "$_percent" -ge 90 ]; then
            _color='\033[31m'  
        elif [ "$_percent" -ge 70 ]; then
            _color='\033[33m'  
        else
            _color='\033[34m'  
        fi
    fi

    printf '%s%s: [%b%s%b%s] %d%%\n' \
        "$_label" "$_padding" "$_color" "$_bar_filled" "$_reset" "$_bar_empty" "$_percent"
}


_tempo_seconds_today() {
    _h=$(date +%H | sed 's/^0//')
    _m=$(date +%M | sed 's/^0//')
    _s=$(date +%S | sed 's/^0//')
    : "${_h:=0}" "${_m:=0}" "${_s:=0}"
    echo $((_h * 3600 + _m * 60 + _s))
}

_tempo_days_in_month() {
    _ym=$(date +%Y-%m-01)
    _dim=$(date -d "$_ym +1 month -1 day" +%d 2>/dev/null) || \
    _dim=$(gdate -d "$_ym +1 month -1 day" +%d 2>/dev/null) || \
    _dim=30
    echo "$_dim" | sed 's/^0//'
}

_tempo_is_leap_year() {
    _yr=$(date +%Y)
    if [ $((_yr % 4)) -eq 0 ] && { [ $((_yr % 100)) -ne 0 ] || [ $((_yr % 400)) -eq 0 ]; }; then
        echo 366
    else
        echo 365
    fi
}

_tempo_calc_day() {
    _curr=$(_tempo_seconds_today)
    _tempo_draw "$_curr" 86400 "Day"
}

_tempo_calc_week() {
    _dow=$(date +%u)
    _curr=$(( (_dow - 1) * 86400 + $(_tempo_seconds_today) ))
    _tempo_draw "$_curr" 604800 "Week"
}

_tempo_calc_month() {
    _day=$(date +%d | sed 's/^0//')
    : "${_day:=0}"
    _dim=$(_tempo_days_in_month)
    _curr=$(( (_day - 1) * 86400 + $(_tempo_seconds_today) ))
    _tempo_draw "$_curr" $((_dim * 86400)) "Month"
}

_tempo_calc_year() {
    _doy=$(date +%j | sed 's/^0*//')
    : "${_doy:=0}"
    _diy=$(_tempo_is_leap_year)
    _curr=$(( (_doy - 1) * 86400 + $(_tempo_seconds_today) ))
    _tempo_draw "$_curr" $((_diy * 86400)) "Year"
}

tempo() {
    _items=$(_tempo_get_config TEMPO_SHOW_ITEMS "day week month year")

    if [ $# -eq 0 ]; then
        for _item in $_items; do
            case $_item in
                day|daily)     _tempo_calc_day   ;;
                week|weekly)   _tempo_calc_week  ;;
                month|monthly) _tempo_calc_month ;;
                year|yearly)   _tempo_calc_year  ;;
            esac
        done
        return
    fi

    case "$1" in
        -d|--day)    _tempo_calc_day   ;;
        -w|--week)   _tempo_calc_week  ;;
        -m|--month)  _tempo_calc_month ;;
        -y|--year)   _tempo_calc_year  ;;
        -c|--config)
            echo "Tempo Configuration:"
            echo "  TEMPO_AUTO_SHOW   = $(_tempo_get_config TEMPO_AUTO_SHOW true)"
            echo "  TEMPO_WIDTH       = $(_tempo_get_config TEMPO_WIDTH 40)"
            echo "  TEMPO_SHOW_ITEMS  = $(_tempo_get_config TEMPO_SHOW_ITEMS 'day week month year')"
            echo "  TEMPO_FILLED_CHAR = $(_tempo_get_config TEMPO_FILLED_CHAR '█')"
            echo "  TEMPO_EMPTY_CHAR  = $(_tempo_get_config TEMPO_EMPTY_CHAR '░')"
            echo "  TEMPO_COLOR_STYLE = $(_tempo_get_config TEMPO_COLOR_STYLE true)"
            ;;
        -h|--help)
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
            ;;
        *)
            echo "Unknown option: $1. Try 'tempo --help'."
            return 1
            ;;
    esac
}
