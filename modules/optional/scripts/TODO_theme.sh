#!/usr/bin/env bash

# Directory
hypr_dir="/tmp/themes/hyprland"
rofi_dir="/tmp/themes/rofi"
kitty_dir="/tmp/themes/kitty"
vscodium_settings="$HOME/.config/VSCodium/User/settings.json"
nvim_settings="/tmp/themes/nvim/theme"


prompt="rofi -dmenu -theme ~/.config/rofi/launchers/theme.rasi"

# Theme
cancel="󰖭 Cancel"
theme1=" Nord"
theme2=" Everforest"
theme3=" Solarized"
theme4=" Catppuccin (Macchiato)"
theme5=" Gruvbox"
theme6=" Srcery"
theme7=" Cozy-Night"
theme8=" Rosé Pine"

# Variable to pass to dmenu or rofi
option="$cancel\n$theme1\n$theme2\n$theme3\n$theme4\n$theme5\n$theme6\n$theme7\n$theme8"


change_theme()
{
	cp ${hypr_dir}/$1.conf ${hypr_dir}/hypr_theme
	cp ${rofi_dir}/$1.rasi ${rofi_dir}/colors.rasi
	cp ${kitty_dir}/$1.conf ${kitty_dir}/kitty_theme
	sed -i 's/\(.*colorscheme\s*\)[^"]*/\1'"$1"'/' $nvim_settings #sed to switch color
	if [[ "$1" == "cozy-night" ]]; then
		# nvim
		sed -i 's/\(.*colorscheme\s*\)[^"]*/\1'"tokyonight-night"'/' $nvim_settings

	elif [[ "$1" == "catppuccin_macchiato" ]]; then
		# nvim
		sed -i 's/\(.*colorscheme\s*\)[^"]*/\1'"catppuccin"'/' $nvim_settings

	fi

	hyprctl reload # restart hyprland
	kill -USR1 $(pidof kitty) #restart kitty
	# pywalfox update #firefox pywal integration
}

gkt2gsetting(){ # apply gtk settings
	config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
	if [ ! -f "$config" ]; then exit 1; fi

	gnome_schema="org.gnome.desktop.interface"
	gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
	icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
	# cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
	font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
	gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
	gsettings set "$gnome_schema" icon-theme "$icon_theme"
	# gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
	gsettings set "$gnome_schema" font-name "$font_name"

}

change_gtk_theme()
{
	sed -e "s/^gtk-theme-name=.*/gtk-theme-name="$@"/" -i $HOME/.config/gtk-3.0/settings.ini
	sed -e "s/^gtk-theme-name=.*/gtk-theme-name=\""$@"\"/" -i $HOME/.gtkrc-2.0
	gkt2gsetting
}

update_wallpaper()
{
	pkill -kill swaybg #kill swaybg no duplicates
	swaybg -m fill -i $@ & #new wp
	wal -i $@ -n -s -t # update pywal theme
}

select="$(echo -e "$option" | $prompt -p "Choose a theme: " )"
case $select in
	$theme1)
		update_wallpaper $HOME/.config/wallpaper/minimal/ign_chomusuke.png
		change_theme nord
		change_gtk_theme Nordic
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Nord"/g' "$vscodium_settings" #vscodium theme
		;;
	$theme2)
		update_wallpaper $HOME/.config/wallpaper/detail/leaves-2.jpg
		change_theme everforest
		change_gtk_theme everforest
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Everforest Dark"/g' "$vscodium_settings"
		;;
	$theme3)
		update_wallpaper $HOME/.config/wallpaper/pixelart/sea1_solarized.png
		change_theme solarized
		change_gtk_theme NumixSolarizedDarkRed
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Better Solarized Dark"/g' "$vscodium_settings"

		;;
	$theme4)
		update_wallpaper $HOME/.config/wallpaper/abstract/cat-waves.png
		change_theme catppuccin_macchiato
		change_gtk_theme Catppuccin-Macchiato-Standard-Red-Dark
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Catppuccin Frappé"/g' "$vscodium_settings"

		;;
	$theme5)
		update_wallpaper $HOME/.config/wallpaper/paisages/mountain.jpeg
		change_theme gruvbox
		change_gtk_theme Gruvbox-Material-Dark
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Gruvbox Dark Medium"/g' "$vscodium_settings"

		;;
	$theme6)
		update_wallpaper $HOME/.config/wallpaper/detail/bush.jpg
		change_theme srcery
		change_gtk_theme oomox-srcery
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Srcery"/g' "$vscodium_settings"

		;;
	$theme7)
		update_wallpaper $HOME/.config/wallpaper/abstract/dark-cat.png
		change_theme cozy-night
		change_gtk_theme TokyoNight
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Tokyo Night"/g' "$vscodium_settings"

		;;
	$theme8)
		update_wallpaper $HOME/.config/wallpaper/anime/wondering.jpg
		change_theme rose-pine
		change_gtk_theme RosePine-Main-B
		sed -i -e 's/"workbench.colorTheme": ".*"/"workbench.colorTheme": "Rosé Pine Moon"/g' "$vscodium_settings"

		;;
esac

