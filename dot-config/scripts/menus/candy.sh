
actions="neofetch
cava
cbonsai
scrcpy"

action=$(echo "$actions" | wofi --show dmenu)

case $action in
	neofetch)
		kitty --class candy_neofetch -o window_padding_width=20 neofetch --gap 2 --special
		;;
	cava)
		kitty --class candy_cava -o window_padding_width=20 cava
		;;
	cbonsai)
		kitty --class candy_cbonsai -o window_padding_width=20 cbonsai -l -b 2 -L 40 -t 0.06
		;;
	scrcpy)
		# Verifica si el dispositivo ADB está conectado y ejecuta scrcpy
		if adb devices | grep -q "device$"; then
			scrcpy
		else
			notify-send "No device detected" "Please connect an Android device."
		fi
		;;
esac
