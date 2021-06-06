#!/bin/bash
#title      :pull_piss_links.sh
#author     :OragamiSwami
#date       :20210605
#version    :0.1
#notes      :Install curl and unrealircd (https://www.unrealircd.org/download)
#usage      :pull_piss_links.sh

tmp=".frampad.tmp"
file="frampad.conf"
unreal_dir="/home/ircd/unrealircd/"
my_server="your.server.tld"
list="https://mensuel.framapad.org/p/********/export/txt" #obtain URL from #oper topic

curl -sk "$list" -o $tmp
c=`grep -c host $tmp.orig`
sed -i.orig "s/$(echo -ne '\u200b')//g;s/$(echo -ne '\u202e')//g"';s/^\*//;/^\/\//d;s|/\*|\n&|g;s|*/|&\n|gi;/\/\*/,/*\//d' $tmp
awk "/^}$/ {f=0} /^link $my_server/ {f=1} /^set {/ {f=1} /^(DNS|dns) rotation/ {f=1} !f;" $tmp | sed ':a;N;$!ba;s/\n\n}\n\n/\n/g;s/\n\n\n*/\n\n/g'  > $file
d=`grep -c hostname $file`
if [ $d -ne $c ] && [ $d -ne `expr $c - 1` ]; then echo "Simple count check failed.. Exiting";cp $file .$file.bad; cp .$file.lng $file; exit; fi # Ensure that we don't attempt to check/rehash a tamperd with pull

$unreal_dir/unrealircd configtest && cp $file .$file.lng || ( cp $file .$file.bad; cp .$file.lng $file ) # Last Known Good - Removing auto-rehash due to ..people.. $unreal_dir/unrealircd rehash
