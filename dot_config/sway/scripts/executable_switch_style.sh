#!/bin/bash

#Accepts managing parameter
case $1'' in
'last')
    mode="last"
    ;;

'next')
    mode="next"
    ;;

'sequence')
    mode="sequence"
    ;;

'random')
    mode="random"
    ;;
esac

function getpid_by_keyword(){
  # 如果为空，则报错，return 1 ?? exit 1??
  #### pid:1,ppid:1,args,cmd:1 
  # pid=$(ps --sort=pid -wweo "pid,ppid,cmd" | awk '{pid=$1;ppid=$2;for(i=3; i<NF; i++){printf "%s ",$i}; print $NF" "pid" "ppid}' | grep "^waybar" | head -n 1 | awk '{print $(NF-1)}') && echo $pid
  if test -z $1; then
    echo "Not found keyword!" >&2;
    return 1
  else
    keyword=$1
  fi
  pid=$(ps --sort=pid -wweo "pid,ppid,cmd" | awk '{
    pid=$1;
    ppid=$2;
    for(i=3; i<NF; i++){
      printf "%s ",$i
    };
    print $NF" "pid" "ppid
  }' | grep "${keyword}" | head -n 1 | awk '{
    printf "%s",$(NF-1)
  }')

  if test -z $pid; then
    echo "Not found pid for keyword: ${keyword}" >&2;
    return 2
  else
    echo $pid
    return 0
  fi
}

function findTheIndex(){
  current_theme=$1
  shift            # Shift all arguments to the left (original $1 gets lost)
  local themelist=("$@") # Rebuild the array with rest of arguments
  # mkdir xxx 2> /dev/null;
  themelist_len=${#themelist[@]}
  for((i=0;i<$themelist_len;i++));
  do
    if [[ "${themelist[$i]}" = "${current_theme}" ]]
    then
      echo "$i"
      return 0
    else 
      echo "$i" 1>&2
    fi
  done
}

function getTargetTheme(){
  local fallback_mode="sequence"
  local mode=${mode:-$fallback_mode}
  local current_theme_index=$1
  shift
  local themelist=("$@")
  local themelist_len=${#themelist[@]}
  case $mode'' in
  'sequence')
      target_theme_index=$((($current_theme_index + 1) % $themelist_len))
      ;;
  'random')
      target_theme_index=$(($RANDOM % $themelist_len))
      ;;
  'last')
      #  + $themelist_len 避免出现负数
      target_theme_index=$((($current_theme_index + $themelist_len - 1) % $themelist_len))
      ;;
  'next')
      # `expr $(findTheIndex) + 1`
      target_theme_index=$((($current_theme_index + 1) % $themelist_len))
      ;;
  esac
  echo $mode >& 2
  echo "xxxx"$target_theme_index >& 2
  echo ${themelist[$target_theme_index]}
}

function start(){
  SDIR="$HOME/.config/waybar"
  keyword="^waybar.*/.*.css"
  pid=$( getpid_by_keyword $keyword )
  current_theme="none"
  if test -z $pid; then echo "no pid" >&2;else current_theme=$(cat /proc/$pid/cmdline | sed 's/.*waybar\/\(.*\).css/\1/g'); fi
  
  # make sure you are enclosing $themelist in double quotes when you are using it: 
  themelist=($(find $SDIR/*.css -iname "*.css" -execdir basename {} .css ';' | grep -v style))
  themelist_len=${#themelist[@]}

  current_theme_index=$(findTheIndex "$current_theme" "${themelist[@]}")

  target_theme=$(mode="$mode" getTargetTheme "$current_theme_index" "${themelist[@]}")
  killall waybar
  waybar -l debug -c "$SDIR"/"$target_theme".jsonc -s "$SDIR"/"$target_theme".css > /tmp/waybar.log &
}

start
