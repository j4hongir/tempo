#!/bin/sh
tempo() {
    _tw=${TEMPO_WIDTH:-40}
    _tf=${TEMPO_FILLED:-#}
    _te=${TEMPO_EMPTY:-.}
    _tc=${TEMPO_COLOR:-true}
    _ti=${TEMPO_ITEMS:-"day week month year"}

    case "${1:-}" in
        -d|--day)    _ti=day ;;
        -w|--week)   _ti=week ;;
        -m|--month)  _ti=month ;;
        -y|--year)   _ti=year ;;
        -a|--all)    _ti="day week month year" ;;
        -c|--config)
            echo "Tempo Configuration:"
            echo "  TEMPO_WIDTH  = $_tw"
            echo "  TEMPO_FILLED = $_tf"
            echo "  TEMPO_EMPTY  = $_te"
            echo "  TEMPO_COLOR  = $_tc"
            echo "  TEMPO_ITEMS  = $_ti"
            echo "  TEMPO_AUTO   = ${TEMPO_AUTO:-true}"
            return ;;
        -h|--help)
            echo "Usage: tempo [OPTION]"
            echo "Options:"
            echo "  -d, --day      Day progress"
            echo "  -w, --week     Week progress"
            echo "  -m, --month    Month progress"
            echo "  -y, --year     Year progress"
            echo "  -a, --all      All progress bars"
            echo "  -c, --config   Show configuration"
            echo "  -h, --help     Show this help"
            return ;;
        "") ;;
        *) echo "tempo: unknown option '$1'"; return 1 ;;
    esac

    date '+%H %M %S %u %d %j %Y %m' | awk \
        -v W="$_tw" -v F="$_tf" -v E="$_te" -v C="$_tc" -v items="$_ti" '
    function bar(v,mx,lb,  p,nf,ne,bf,be,pd,c,r,i) {
        p=int(v*100/mx); if(p>100)p=100; if(p<0)p=0
        nf=int(W*p/100); ne=W-nf
        bf=""; for(i=0;i<nf;i++) bf=bf F
        be=""; for(i=0;i<ne;i++) be=be E
        pd=""; for(i=0;i<7-length(lb);i++) pd=pd " "
        c=""; r=""
        if(C=="true") {
            r="\033[0m"
            if(p>=90) c="\033[31m"; else if(p>=70) c="\033[33m"; else c="\033[34m"
        }
        printf "%s%s: [%s%s%s%s] %d%%\n", lb, pd, c, bf, r, be, p
    }
    function dim(m,y,  a) {
        split("31,28,31,30,31,30,31,31,30,31,30,31",a,",")
        return (m==2 && y%4==0 && (y%100!=0||y%400==0)) ? 29 : a[m]+0
    }
    {
        s=($1+0)*3600+($2+0)*60+($3+0)
        dw=$4+0; dm=$5+0; dy=$6+0; Y=$7+0; mo=$8+0
        diy=(Y%4==0 && (Y%100!=0||Y%400==0)) ? 366 : 365
        n=split(items,it," ")
        for(i=1;i<=n;i++) {
            if(it[i]=="day")   bar(s, 86400, "Day")
            if(it[i]=="week")  bar((dw-1)*86400+s, 604800, "Week")
            if(it[i]=="month") bar((dm-1)*86400+s, dim(mo,Y)*86400, "Month")
            if(it[i]=="year")  bar((dy-1)*86400+s, diy*86400, "Year")
        }
    }'
}
