#!/bin/bash
#title      :pull_piss_links.sh
#author     :OragamiSwami
#date       :20210605
#version    :0.1
#notes      :Install curl and unrealircd (https://www.unrealircd.org/download)
#usage      :pull_piss_links.sh

tmp="frampad.tmp"
file="frampad.conf"
unreal_dir="/home/ircd/unrealircd/"
my_server="your.server.tld"
list="https://mensuel.framapad.org/p/********/export/txt" #obtain URL from #oper topic

curl -sk "$list" -o $tmp
sed -i.orig 's/^\*//;/^\/\//d;s|/\*|\n&|g;s|*/|&\n|gi;/\/\*/,/*\//d' $tmp
awk "/^}$/ {f=0} /^link $my_server/ {f=1} /^set {/ {f=1} /^DNS rotation/ {f=1} !f;" $tmp | sed ':a;N;$!ba;s/\n\n}\n\n/\n/g;s/\n\n\n*/\n\n/g'  > $file

$unreal_dir/unrealircd configtest && $unreal_dir/unrealircd rehash
