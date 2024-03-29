#!/bin/sh

wan_ip(){
  local tmp_file="${HOME}/.cache/tmux_wan_ip.txt"
  local wan_ip
  if [ -f "$tmp_file" ]; then
    last_update=$(stat -c '%Y'  ${tmp_file}) 
    time_now=$(date +%s)
    update_period=900
    up_to_date=$(echo "(${time_now}-${last_update}) < ${update_period}" | bc)

    if [ "$up_to_date" -eq 1 ]; then
      wan_ip=$(cat ${tmp_file})
    fi
  fi
  if [ -z "$wan_ip" ]; then
    wan_ip=$(curl --max-time 2 -s http://whatismyip.akamai.com/)

    if [ "$?" -eq "0" ]; then
      echo "${wan_ip}" > $tmp_file
    elif [ -f "${tmp_file}" ]; then
      wan_ip=$(cat "$tmp_file")
    fi
  fi

  if [ -n "$wan_ip" ]; then
    echo "ⓦ  ${wan_ip}"
  fi
}
wan_ip
