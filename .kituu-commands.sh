# This file is sourced from my .zshrc and my .bashrc to ensure that I have the same env no matter what shell.
# https://github.com/xaccrocheur/kituu

# Path
PATH=~/scripts:~/bin:$PATH

# Vars
# PYTHONPATH=$PYTHONPATH:/usr/share/gst-python/0.10/examples/
# PATH=$PATH:~/scripts/beatnitpycker/:~/src/radium/bin/
# PATH=$PATH:/opt/nodejs/bin/

# DSSI_PATH=/usr/lib/calf/
# export DSSI_PATH=/usr/lib/dssi/:/usr/lib/calf/:/usr/local/lib/calf/
# export LADSPA_PATH=/usr/lib/ladspa/:/usr/local/lib/calf/
# export VST_PATH=/usr/local/lib/lxvst/

# Aliases
alias rm="rm -i"
alias cp="cp -i"

if [[ ! $HOSTNAME == "RM696" ]] ; then
    alias grep="grep -Is --color --exclude-dir='.git'"
    alias ls="ls --color --group-directories-first"
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
fi

alias ll="ls -lha"
alias la="ls -A"

alias k="cd ~/.kituu/"
alias m="cd ~/Documents/manyrecords"
alias t="cd ~/tmp"
alias s="cd ~/src"
alias S="cd ~/Dropbox/STUDIO/Qtractor/"

alias pss='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'
alias mss="sudo cat /var/log/syslog | grep $1"
alias uss="urpmq -Y --summary"
alias rss="rpm -qa|grep -i"
alias rssi="rpm -qil"
alias MSG="sudo tail -f -n 40 /var/log/syslog"
alias MSGh="sudo tail -f -n 40 /var/log/httpd/error_log"
alias U="urpmi"
alias Commit="git commit -am"
alias Push="git push origin"
alias Syncmail="offlineimap.py -o -u blinkenlights; reset"
alias a="sudo apt install"
alias aa="apt-cache search"
alias ap="apt-cache policy"
alias al="dpkg -L"
alias af="apt-file search"
alias ar="sudo apt remove --purge"
alias b="bundle"
alias l="locate -i"
alias v="gpicview"
alias bi="b install --path vendor"
alias bil="bi --local"
alias bu="b update"
alias be="b exec"
alias binit="bi && b package && echo 'vendor/ruby' >> .gitignore"
alias ffox="~/Downloads/firefox/firefox&"

alias orgsync="cd ~/.org && git-sync.sh "

alias gitlog="git log --pretty=format:'%Cred%h%Creset | %C(yellow)%ad%Creset | %C(bold blue)%an%Creset - %s - %C(yellow)%d%Creset'"

alias px-shell="gnome-terminal --command byobu --maximize --hide-menubar"

alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

# Commands

function px-freemem () {

    item=$(egrep 'MemAvailable' /proc/meminfo | awk '{print $2;}')
    total=$(egrep 'MemTotal' /proc/meminfo | awk '{print $2;}')
    percent=$(awk "BEGIN { pc=100*${item}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

    echo "$percent%"
}

function px-qtractor-takes-cleanup () {

    [[ "${2:-}" == "--delete" ]] && COMMAND="rm -fv" || COMMAND="ls"

    echo "Usage: $0 qtr_session_file [--delete] \n"
    for file in *.wav* *.mid* ; do
        grep -q -F "$file" $1 || eval $COMMAND " $file"
    done

}

px-lastarg () {
    $1 $(history -1 | awk '{ print $3 }')
}

px-30fps () {
    ffmpeg -i $1 -r 30 $1-30fps.mkv
}

px-trimvideo () {
    # [[ $# -ne 3 ]] && echo "Usage: $0 file start end" ||
    ffmpeg -i $1 -ss $2 -c copy -to $3 $1-trimmed.mp4
    # ffmpeg -i $1 -ss 00:00:00 -c copy -t $3 $1-trimmed.mp4
}

px-30fps-no_sound () {
    ffmpeg -i $1 -r 30 -an $1.mkv
}

px-scast () {
    ffmpeg -f alsa -ac 2 -i pulse -f x11grab -r 30 -s 1882x1200 -i :0.0+38,0 -acodec pcm_s16le -vcodec libx264 -preset ultrafast -threads 0 $1.mkv
}

px-resize () {
ffmpeg \
    -i "$1" \
    -map 0 \
    -vf "scale=iw*sar*min($MAX_WIDTH/(iw*sar)\,$MAX_HEIGHT/ih):ih*min($MAX_WIDTH/(iw*sar)\,$MAX_HEIGHT/ih),pad=$MAX_WIDTH:$MAX_HEIGHT:(ow-iw)/2:(oh-ih)/2" \
    $1.mkv
}

px-bell () {
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    notify-send "Heads Up!"
}

function px-search-and-replace () {
    find ./ -type f -exec sed -i -e "s/$1/$2/g" {} \;
}

function px-install-ketacho-games () {
    sudo apt install A7Xpg Noiz2sa parsec47 tumiki-fighters rrootage
}

function px-install-audio-plugins () {
    sudo apt install samplv1-lv2 qmidiarp synthv1-lv2 artyfx swh-lv2 mda-lv2 rkrlv2 carla-lv2 cmt fluid-soundfont-gm dpf-plugins fomp xsynth-dssi distrho-plugin-ports-lv2 tal-plugins calf-plugins
}

function px-kx-repos-install () {
    # Install required dependencies if needed
    sudo apt-get install apt-transport-https software-properties-common wget

    # Download package file
    wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_9.4.1~kxstudio1_all.deb

    # Install it
    sudo dpkg -i kxstudio-repos_9.4.1~kxstudio1_all.deb
    # Install required dependencies if needed
    sudo apt-get install libglibmm-2.4-1v5

    # Download package file
    wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos-gcc5_9.4.1~kxstudio1_all.deb

    # Install it
    sudo dpkg -i kxstudio-repos-gcc5_9.4.1~kxstudio1_all.deb
}

function px-cleanup-filenames () {
    find -type f | rename -v 's/%20/_/g'
    find -type f | rename -v 's/ /_/g'
}

function px-reorder-filenames () {

    digits=%04d.%s

    mkdir -vp tmp
    rm -rf tmp/*

    X=1;
    for i in *; do
        newfile=$(printf ${digits} ${X%.*} ${i##*.})

        color="\e[32m"

        if [ -f "$i" ] ; then
            [[ "$i" != "$newfile" ]] && color="\e[31m"
            cp $i tmp/$(printf ${digits} ${X%.*} ${i##*.}) && echo "$color$i => $(printf %04d.%s ${X%.*} ${i##*.})\e[0m"
        fi

        let X="$X+1"
    done

    find . -maxdepth 1 -type f -exec rm -rf '{}' \; && cp tmp/* . && rm -rf tmp/ && echo "Processed $X files"
}

function ssh () {
    if [ $# -eq 1 ] ; then
        tmux rename-window `echo $1 | sed 's/.*@//g' | sed 's/.local//g'`
    fi
    command ssh $*
}

px-git-last-commit-to-clipboard () {
    git log | head -1 | cut -c 8-47 | xclip -selection clipboard
    echo "Last commit ($(git log | head -3 | cut -c 9-31 | tail -1) - $(git log | head -5 | cut -c 5-47 | tail -1)) copied to clipboard"
}

px-broadcast-mic () {
    arecord -f dat | ssh -C $1 aplay -f dat
}

px-ram-dump () {
    sudo cat /proc/kcore | strings | awk 'length > 20' | less
}

px-bandwidth-monitor () {
    [[ $# -eq 0 ]] && NIC="eth0" || NIC=$1
    while [ /bin/true ] ; do OLD=$NEW; NEW=`cat /proc/net/dev | grep $NIC | tr -s ' ' | cut -d' ' -f "3 11"`; echo $NEW $OLD | awk '{printf("\rin: % 9.2g\t\tout: % 9.2g", ($1-$3)/1024, ($2-$4)/1024)}'; sleep 1; done
}

px-flight_status() { if [[ $# -eq 3 ]];then offset=$3; else offset=0; fi; curl "http://mobile.flightview.com/TrackByRoute.aspx?view=detail&al="$1"&fn="$2"&dpdat=$(date +%Y%m%d -d ${offset}day)" 2>/dev/null |html2text | \grep ":"; }

px-guitar-tuner () {
    for N in E2 A2 D3 G3 B3 E4;do play -n synth 4 pluck $N repeat 2;done
}

px-what-is-this-program-doing-now () {
    diff <(lsof -p `pidof $1`) <(sleep 5; lsof -p `pidof $1`)
}

md () {
    mkdir -p $1
    cd $1
}

px-sshmount () {
    if [ ! $(grep "fuse.*$USER" /etc/group) ] ; then sudo gpasswd -a $USER fuse && echo "$0 : added $USER to group fuse" ; fi
    if [ "$#" -eq "1" ] ; then
        fusermount -u $1 && echo "$0 : Unmounted $1"
    else
        if  [ -w $2 ] ; then
            sshfs -o idmap=user $1 $2
        else
            echo "$0 : $2 is not writable"
        fi
    fi
}

px-vnc () {
    \ssh -f -L 5900:127.0.0.1:5900 $1 "x11vnc -scrollcopyrect -noxdamage -localhost -nopw -once -display :0" ; vinagre 127.0.0.1:5900
}

px-update-N900 () {
    rm .bashrc .kituu-commands.sh -f
    wget --no-check-certificate -nc https://github.com/xaccrocheur/kituu/raw/master/.kituu-commands.sh https://github.com/xaccrocheur/kituu/raw/master/.bashrc
    bash
}

px-lan-scan () {
    # nmap -sP 192.168.1.0/24
    LOCAL_MASK=$(ip -o -4 addr show | awk -F '[ /]+' '/global/ {print $4}' | cut -d. -f1,2,3)
    GATEWAY=$(route -n | \grep '^0.0.0.0' | awk '{print $2}')
    if [ $1 ] ; then range=$1 ; else range="10" ; fi

    for num in $(seq 1 ${range}) ; do
        IP=$LOCAL_MASK.$num
        if [[ $IP == $GATEWAY ]] ; then MACHINE="gateway" ; else MACHINE=$(avahi-resolve-address $IP 2>/dev/null | sed -e :a -e "s/$IP//g;s/\.[^>]*$//g;s/^[ \t]*//") ; fi
        ping -c 1 $IP>/dev/null
        if [ $? -eq 0 ] ; then
            echo -e "UP    $IP \t ($MACHINE)" ; else
            echo -e "DOWN  $IP"
        fi
    done
}

px-wake-up-trackpad () {
    sudo rmmod psmouse
    sudo modprobe psmouse
}

px-commit-alten-pjs () {
    cd ~/Documents/Alten/svn/Support\ AGRESSO/pieces_jointes/
    svn status | grep '^?' | sed -e 's/^? *//' | xargs --no-run-if-empty -d '\n' svn add
}

px-dirsizes () { for DIR in $1* ; do if [ -d $DIR ] ; then du -hsL $DIR ; fi ; done }

px-websearch () {
    firefox "https://duckduckgo.com/?q=$*"
}

function google () {
    u=`perl -MURI::Escape -wle 'print "http://google.com/search?q=". uri_escape(join " ",  @ARGV)' $@`
    links $u
}

px-find-this-and-do-that () {
    find . -name $1 -exec $2 '{}' \;
}

px-bkp () {
    cp -Rp $1 ${1%.*}.bkp-$(date +%y-%m-%d-%Hh%M).${1#*.}
}

px-ip () {
    echo -e "Local:   $(ip -o -4 addr show | awk -F '[ /]+' '/global/ {print $4}')"
    echo -e "distant: $(dig +short myip.opendns.com @resolver1.opendns.com)"
}

px-remind-me-this-in () {
    sleep $2
    zenity --info --text=$1
}

px-netstats () {
    if hash ss 2>/dev/null; then
        echo -e "      $(ss -p | cut -f2 -sd\" | sort | uniq | wc -l) processes : $(ss -p | cut -f2 -sd\" | sort | uniq | xargs) \n"
    fi
    lsof -P -i -n | uniq -c -w 10
    echo -e "
Distant connected IPs : \n $(netstat -an | grep ESTABLISHED | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | awk '{ printf("%s\t%s\t",$2,$1) ; for (i = 0; i < $1; i++) {printf("*")}; print "" }') \n"
    if [ $1 ] ; then
        netstat -luntp
        echo -e "
Connected hostnames"
        for IP in $(netstat -an | grep ESTABLISHED | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq); do host ${IP} | sed 's/\.in-addr.arpa domain name pointer/ \=\> /' ; done | grep -v '^;'
    else
        echo "use -a to see machine names (slow)"
    fi
}

px-notes () {
    if [ ! $1 ] ; then
echo -e "
################# NOTES
<<<<<<< HEAD
<<<<<<< HEAD
nabil.zakhbat@gmail.com
unison -fat -fastcheck true -batch ~/tmp/.pr0n /media/px/Nokia N9/tmp/.pr0n/
=======
>>>>>>> 4fb34eb0a527a22ea9417c56514b6e1c696e30ff
=======
Qtractor menu : Shift-F12
>>>>>>> 06bbe6bea2d89c606a1ffcec28ba975d6892a83f
/ssh:user@machine:
MAC Address: 48:A2:2D:E1:79:74 (Shenzhen Huaxuchang Telecom Technology Co.)
MAC Address: 48:A2:2D:E1:79:74 (Shenzhen Huaxuchang Telecom Technology Co.)
git reset --hard HEAD@{7}
ZSH : rm -rf ^survivorfile
BASH: rm -f !(survivor_file)
0608853025
find . -type f -printf '%TY-%Tm-%Td %TT %p
' | sort
last arg of last command : !$
zdump Africa/Morocco Europe/Paris
tar -tf <file.tar.gz> | xargs rm -r
gnome-terminal --command byobu --maximize --hide-menubar
ESC DOT pops the last argument of the last command
DNS1 212.217.1.1 DNS2 .12 p.nom PPPoE / LLC
grep . * to cat a bunch of (small) files
ssh machine -L127.0.0.1:3306:127.0.0.1:3306
middleman build --clean && git commit -a -m 'new local build OK' && git push origin master
a && middleman build --clean && Commit 'deployed' && Push master
if ('$term' == emacs) set term=dumb
sudo ln -s /usr/lib/i386-linux-gnu/libao.so.4 /usr/lib/libao.so.2
sshfs name@server:/path/to/folder /path/to/mount/point

# reset the index to the desired tree
git reset 56e05fced
# move the branch pointer back to the previous HEAD
git reset --soft HEAD@{1}
git commit -m 'Revert to 56e05fced'
# Update working copy to reflect the new commit
git reset --hard

## Use px-notes \"this is a new note\" to add a note
"
else
        sed -i '/^################# NOTES/a '$1'' ~/.kituu/.kituu-commands.sh && k && Commit "New note : $1" && Push master && cd -
fi
}

echo "kituu-commands loaded OK"
