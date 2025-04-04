#!/bin/sh -x

PIC="$(xdg-user-dir PICTURES)/screen_shots_luke"
VID="$(xdg-user-dir VIDEOS)"

get_options() {
  printf "
📷  Copy-pic Selected
📷  Copy-pic Full
📷  pic Selected
📷  pic Full
🛑  Stop Recording
📹+🎙️  vid Full + mic
📹  vid Selected
📹  vid Full
"
}

main() {
  choice=$( (get_options) | wofi -n  -d -i)

  case $choice in
  '📷  Copy-pic Selected') grim -g "$(slurp)" | wl-copy ;;
  '📷  Copy-pic Full') grim - | wl-copy ;;
  '📷  pic Selected') grim -g "$(slurp)" ${PIC}/$(date +'%s_grim.png') ;;
  '📷  pic Full') grim ${PIC}/$(date +'%s_grim.png') ;;
  '🛑  Stop Recording')
    pid=`pgrep wf-recorder`
    [ "$pid" ] && pkill --signal SIGINT wf-recorder
    ;;
  '📹  vid Selected') wf-recorder -g "$(slurp)"  --file=${VID}/$(date +'%s_vid_selected.mp4');;
  '📹  vid Full') wf-recorder -o DP-2 --file=${VID}/$(date +'%s_vid_full.mp4') ;;
  '📹+🎙️  vid Full + mic') wf-recorder -o DP-2 -a --file=${VID}/$(date +'%s_vid_full_mic.mp4') ;;
  esac
}

main &

exit 0
