#!/bin/sh
isServerExist=`ps -ef|grep -m 1 swaybg|grep -v "grep"|wc -l`
if [ "$isServerExist" = "0" ]; then
	echo "my_server not found"
elif [ "$isServerExist" = "1" ]; then
  killall swaybg
fi
# Automatically change wallpaper every 10 minutes
#image_path=~/.config/sway/wallpaper/.
swaybg -i $(find ~/.config/sway/wallpaper/. -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image' | shuf -n1 | cut -d: -f1) -m fill &
OLD_PID=$!
while true; do
    echo "waiting"
    sleep 10
    swaybg -i $(find ~/.config/sway/wallpaper/. -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image' | shuf -n1 | cut -d: -f1) -m fill &
    NEXT_PID=$!
    sleep 5
    kill $OLD_PID
    OLD_PID=$NEXT_PID
done
