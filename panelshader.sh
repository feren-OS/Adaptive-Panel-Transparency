#!/bin/bash

#Minimum RGB for Panel to be shaded = (255/100) * 40 = 102
cd ~
homedir="$(pwd)"

sleep 0.5

currentcinnamontheme="$(/usr/bin/gsettings get org.cinnamon.theme name)"
currentcinnamontheme=${currentcinnamontheme#"'"}
currentcinnamontheme=${currentcinnamontheme%"'"}
currentcinnamontheme=$(echo $currentcinnamontheme | sed "s/%20/ /g")
if [ ! -d "$homedir/.themes/$currentcinnamontheme" ] && [ ! -d "$currentdir/.local/share/themes/$currentcinnamontheme" ] && [ ! -d "/usr/share/themes/$currentcinnamontheme" ]; then
    #No theme found
    exit -1
fi

if [ ! -f "$homedir/.themes/$currentcinnamontheme/transparent-panels-cinnamon" ] && [ ! -f "$homedir/.local/share/themes/$currentcinnamontheme/transparent-panels-cinnamon" ] && [ ! -f "/usr/share/themes/$currentcinnamontheme/transparent-panels-cinnamon" ]; then
    #No Feren Colouring Support found
    perl -i -p0e 's/Use this in case the panels transparency is icorrectly set.",
        "value": false/Use this in case the panels transparency is icorrectly set.",
        "value": true/s' "$homedir/.cinnamon/configs/transparent-panels@germanfr/transparent-panels@germanfr.json"
    exit -1
fi

wallpaperlocat="$(/usr/bin/gsettings get org.cinnamon.desktop.background picture-uri)"
wallpaperlocat=$(echo $wallpaperlocat | sed "s%file://%%g")
wallpaperlocat=$(echo $wallpaperlocat | sed "s/%20/ /g")
wallpaperlocat=${wallpaperlocat#"'"}
wallpaperlocat=${wallpaperlocat%"'"}
wallpaperlocat=$(readlink -f "$wallpaperlocat")

wallpaperinfo=$(convert "$wallpaperlocat" -resize 1x1 txt:-)
wallpaperinfo=$(echo $wallpaperinfo | sed "s%.* srgb(%%g")
wallpaperinfo=$(echo $wallpaperinfo | sed "s%)%%g")
wallpaperinfo=$(echo $wallpaperinfo | sed "s%,% %g")

read r g b <<< $(echo "$wallpaperinfo")

if [ "$r" -lt "102" ] && [ "$g" -lt "102" ] && [ "$b" -lt "102" ]; then
    perl -i -p0e 's/Use this in case the panels transparency is icorrectly set.",
        "value": true/Use this in case the panels transparency is icorrectly set.",
        "value": false/s' "$homedir/.cinnamon/configs/transparent-panels@germanfr/transparent-panels@germanfr.json"
else
    perl -i -p0e 's/Use this in case the panels transparency is icorrectly set.",
        "value": false/Use this in case the panels transparency is icorrectly set.",
        "value": true/s' "$homedir/.cinnamon/configs/transparent-panels@germanfr/transparent-panels@germanfr.json"
fi

convert "$wallpaperlocat" -resize 1x1 txt:-
if [ ! $? -eq 0 ]; then
    perl -i -p0e 's/Use this in case the panels transparency is icorrectly set.",
        "value": false/Use this in case the panels transparency is icorrectly set.",
        "value": true/s' "$homedir/.cinnamon/configs/transparent-panels@germanfr/transparent-panels@germanfr.json"
fi

exit 0
