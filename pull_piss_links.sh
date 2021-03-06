#author     :OragamiSwami
#date       :20210605
#version    :0.1
#notes      :Install curl and unrealircd (https://www.unrealircd.org/download)
#usage      :pull_piss_links.sh

cd "$(dirname "$0")"
log="pull.log"
hubfile="hubs.conf"
linkfile="links.conf"
unreal_dir="/home/ircd/unrealircd/"


echo "Start @ `date`" &>> $log

function pull {
    name=$1
    link=$2
    file=$3
    mincount=$4

    echo "Pulling $name" &>> $log
    curl -sk "$link" -o .$file.orig
    c=`grep -c host .$file.orig`
    cat .$file.orig | tr -cd '[:alnum:]._\-;#":,\{\}\(\)\/\!\?\*+=@ \n\t'"'" | sed 's/^ [^ ]//;s/\t/    /g;s/autoconnect\s*;//' > .$file.tmp
    awk '/^(link|ban) /,/^}/' .$file.tmp > $file
    d=`grep -c hostname $file`
    echo "Got $d links for $name" &>> $log
    if [ $d -ne $c ] && [ $d -ne `expr $c - 1` ] && [ $d -le $mincount ] ; then
        echo "$name count check failed.. Restoring LNG" &>> $log
        cp $file .$file.bad
        cp .$file.lng $file || ( echo "Failed to restore LNG" &>> $log; return -1)
    fi
    $unreal_dir/unrealircd configtest &>> $log && cp $file .$file.lng || ( cp $file .$file.bad; cp .$file.lng $file )
    echo "End $name" &>> $log
}



pull "Hubs" "https://api.shitposting.space/link/hubs" $hubfile 10
pull "Americas" "https://api.shitposting.space/link/leaves/America" $linkfile 20
#pull "Europe" "https://api.shitposting.space/link/leaves/Europe" $linkfile 20
#pull "APAC" "https://api.shitposting.space/link/leaves/APAC" $linkfile 11
#pull "Africa" "https://api.shitposting.space/link/leaves/Africa" $linkfile 1

sed -i 's/class servers;/class hubs;/' $hubfile

$unreal_dir/unrealircd configtest &>>$log && $unreal_dir/unrealircd rehash &>>$log

echo -e "End @ `date`\n\n" &>> $log
