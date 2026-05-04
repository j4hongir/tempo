function tempo -d "Time progress tracker"
    set -l w 40;    set -q TEMPO_WIDTH;  and set w $TEMPO_WIDTH
    set -l f '#';   set -q TEMPO_FILLED; and set f $TEMPO_FILLED
    set -l e '.';   set -q TEMPO_EMPTY;  and set e $TEMPO_EMPTY
    set -l c true;  set -q TEMPO_COLOR;  and set c $TEMPO_COLOR
    set -l ti "day week month year"; set -q TEMPO_ITEMS; and set ti $TEMPO_ITEMS

    if test (count $argv) -gt 0
        switch $argv[1]
            case -d --day;    set ti day
            case -w --week;   set ti week
            case -m --month;  set ti month
            case -y --year;   set ti year
            case -a --all;    set ti "day week month year"
            case -c --config
                echo "Tempo Configuration:"
                echo "  TEMPO_WIDTH  = $w"
                echo "  TEMPO_FILLED = $f"
                echo "  TEMPO_EMPTY  = $e"
                echo "  TEMPO_COLOR  = $c"
                echo "  TEMPO_ITEMS  = $ti"
                set -l auto true; set -q TEMPO_AUTO; and set auto $TEMPO_AUTO
                echo "  TEMPO_AUTO   = $auto"
                return
            case -h --help
                echo "Usage: tempo [OPTION]"
                echo "Options:"
                echo "  -d, --day      Day progress"
                echo "  -w, --week     Week progress"
                echo "  -m, --month    Month progress"
                echo "  -y, --year     Year progress"
                echo "  -a, --all      All progress bars"
                echo "  -c, --config   Show configuration"
                echo "  -h, --help     Show this help"
                return
            case '*'
                echo "tempo: unknown option '$argv[1]'"
                return 1
        end
    end

    date '+%H %M %S %u %d %j %Y %m' | awk \
        -v W="$w" -v F="$f" -v E="$e" -v C="$c" -v items="$ti" '
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
end
