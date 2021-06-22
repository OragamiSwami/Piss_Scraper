#!/bin/bash
#title      :pull_piss_links.sh
#author     :OragamiSwami
#date       :20210605
#version    :0.1
#notes      :Install curl and unrealircd (https://www.unrealircd.org/download)
#usage      :pull_piss_links.sh

cd "$(dirname "$0")"
log="pull.log"
tmp=".frampad.tmp"
file="frampad.conf"
unreal_dir="/home/ircd/unrealircd/"
my_server="your.server.tld"
list="https://wiki.letspiss.net/index.php?title=Server_link_blocks&action=raw" #obtain URL from #oper topic
banlist="https://wiki.letspiss.net/index.php?title=Ban_Blocks&action=raw"

echo "Start @ `date`" &>> $log
curl -sk "$list" -o $tmp.orig
curl -sk "$banlist" >> $tmp.orig
c=`grep -c host $tmp.orig`
cat $tmp.orig | tr -cd '[:alnum:]._\-;#":,\{\}\(\)\/\!\?\*+=@ \n\t'"'" | sed 's/^ [^ ]//;s/\t/    /g;s/autoconnect\s*;//' > $tmp
awk '/^(link|ban) /,/^}/' $tmp > $file
d=`grep -c hostname $file`
if [ $d -ne $c ] && [ $d -ne `expr $c - 1` ] && [ $d -le 50 ] ; then echo "Simple count check failed.. Exiting" &>> $log ;cp $file .$file.bad; cp .$file.lng $file; exit; fi
$unreal_dir/unrealircd configtest &>>$log && ( cp $file .$file.lng && $unreal_dir/unrealircd rehash &>>$log ) || cp $file .$file.bad; cp .$file.lng $file
echo -e "End @ `date`\n\n" &>> $log
