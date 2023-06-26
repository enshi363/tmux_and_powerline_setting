#!/bin/sh

weather_info(){
  local tmp_file="${HOME}/.cache/tmux_weather.txt"
  local weather 
  if [ "$TMUX_WEATHER_LOCATION" = "" ]; then
    TMUX_WEATHER_LOCATION="Shanghai"
  fi
  if [ "$TMUX_WEATHER_LANG" = "" ]; then
    TMUX_WEATHER_LANG="zh-cn"
  fi
  if [ -f "$tmp_file" ]; then
    last_update=$(stat -c '%Y'  ${tmp_file}) 
    time_now=$(date +%s)
    update_period=900
    up_to_date=$(echo "(${time_now}-${last_update}) < ${update_period}" | bc)

    if [ "$up_to_date" -eq 1 ]; then
      weather=$(cat ${tmp_file})
    fi
  fi
  if [ -z "$weather" ]; then
    curl  -s "https://wttr.in/${TMUX_WEATHER_LOCATION}?format=%c%C+%t&period=60&lang=${TMUX_WEATHER_LANG}" > $tmp_file

    weather=$(cat "$tmp_file")
  fi

  if [ -n "$weather" ]; then
    echo "${weather}"
  fi
}
weather_info
