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

curl -sk "$list" -o $tmp.orig
c=`grep -c host $tmp.orig`
cat $tmp.orig | tr -cd '[:alnum:]._\-;#":,\{\}\(\)\/\!\?\*+=@ \n'"'" | sed 's/^\*//' > $tmp
awk '/^link/,/^}$/' $tmp > $file
d=`grep -c hostname $file`
if [ $d -ne $c ] && [ $d -ne `expr $c - 1` ]; then echo "Simple count check failed.. Exiting";cp $file .$file.bad; cp .$file.lng $file; exit; fi

$unreal_dir/unrealircd configtest && cp $file .$file.lng || ( cp $file .$file.bad; cp .$file.lng $file )
