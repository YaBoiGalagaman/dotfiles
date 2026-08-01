#!/bin/bash

# --- Rofi helper with breadcrumb support ---
rofi_menu() {
    local breadcrumb="$1"
    shift
    printf '%s\n' "$@" | rofi -dmenu -i -p "Rofi" \
        -theme-str "entry { placeholder: \"Search $breadcrumb\"; }"
}



# --- Main Loop ---
while true; do
    choice=$(rofi_menu "Rofi" "Apps" "Calculator" "Games" "Miscellaneous" "Websites" "Exit")
    case "$choice" in
    	"Calculator") /usr/bin/rofi -show calc; exit 0;;
        "Apps")
            app=$(rofi_menu "Rofi > Apps" "ChatGPT App" "Steam" "VirtualBox" "Web Browsers" "Back")
            case "$app" in\
                "ChatGPT App") brave --enable-features=UseOzonePlatform --ozone-platform=x11 --app=https://chat.openai.com/ ; exit 0 ;;
                "VirtualBox") virtualbox ; exit 0 ;;
                "Steam") steam ; exit 0 ;;

                "Web Browsers")
                    web=$(rofi_menu "Rofi > Apps > Web Browsers" "Brave" "Firefox" "Back")
                    case "$web" in
                        "Brave") brave --enable-features=UseOzonePlatform --ozone-platform=x11 ; exit 0 ;;
                        "Firefox") firefox ; exit 0 ;;
                    esac ;;
            esac ;;

        "Games")
            game=$(rofi_menu "Rofi > Games" "Minecraft" "Miscellaneous" "Steam Games" "Tarkov" "Back")
            case "$game" in
                "Minecraft")
                    mc=$(rofi_menu "Rofi > Games > Minecraft" "Curseforge" "TechnicLauncher" "Back")
                    case "$mc" in
                        "Curseforge") curseforge ; exit 0 ;;
                        "TechnicLauncher") java -jar ~/Documents/TechnicLauncher.jar ; exit 0 ;;
                    esac ;;

                "Miscellaneous")
                    misc=$(rofi_menu "Rofi > Games > Miscellaneous" "Cemu" "Dolphin" "Back")
                    case "$misc" in
                        "Cemu") cemu ; exit 0 ;;
                        "Dolphin") org.DolphinEmu.dolphin-emu ; exit 0 ;;
                    esac ;;

                "Steam Games")
                    sg=$(rofi_menu "Rofi > Games > Steam Games" "CKAN" "Factorio" "Marvel Rivals" "The Finals" "CoD: Black Ops 3" "Doom Eternal" "Back")
                    case "$sg" in
                        "CKAN") ckan ; exit 0 ;;
                        "Factorio") steam steam://rungameid/427520 ; exit 0 ;;
                        "Marvel Rivals") steam steam://rungameid/2767030 ; exit 0 ;;
                        "The Finals") steam steam://rungameid/2073850 ; exit 0 ;;
                        "CoD: Black Ops 3") steam steam://rungameid/311210 ; exit 0 ;;
                        "Doom Eternal") steam steam://rungameid/782330 ; exit 0 ;;
                    esac ;;

                "Tarkov")
                    tark=$(rofi_menu "Rofi > Games > Tarkov" "MPT" "SPT" "Back")
                    case "$tark" in
                        "MPT")
                            mpt=$(rofi_menu "Rofi > Games > Tarkov > MPT" "MPT 3.8.0 Launcher" "MPT 3.9.8 Launcher" "Back")
                            case "$mpt" in
                                "MPT 3.8.0 Launcher") net.lutris.Lutris lutris:rungame/mpt-380-launcher ; exit 0 ;;
                                "MPT 3.9.8 Launcher") net.lutris.Lutris lutris:rungame/mpt-390-launcher ; exit 0 ;;
                            esac ;;
                        "SPT")
                            spt=$(rofi_menu "Rofi > Games > Tarkov > SPT" "Launcher" "Server" "Back")
                            case "$spt" in
                                "Launcher") net.lutris.Lutris lutris:rungame/spt-launcher ; exit 0 ;;
                                "Server") net.lutris.Lutris lutris:rungame/spt-server ; exit 0 ;;
                            esac ;;
                    esac ;;
            esac ;;

        

        "Miscellaneous")
            m=$(rofi_menu "Rofi > Miscellaneous" "Back" "Waybar")
            case "$m" in
                "Waybar") waybar ; exit 0 ;;
            esac ;;

        "Websites")
            declare -A sites=(
                ["AuAccess"]="https://auaccess.auburn.edu/"
                ["ChatGPT"]="https://chatgpt.com/"
                ["Gmail"]="https://mail.google.com/mail/u/0/#inbox"
                ["MyAnimeList"]="https://myanimelist.net/"
                ["TailScale"]="https://login.tailscale.com/admin/machines"
                ["Synology Drive"]="$(<"$HOME/.config/rofi/scripts/bristol_nas_url")"
            )

            w=$(printf '%s\n' "${!sites[@]}" "Back" | rofi -dmenu -i -p "Rofi" -theme-str 'entry { placeholder: "Search Rofi > Websites"; }')
            [[ "$w" == "Back" || -z "$w" ]] && continue

            firefox "${sites[$w]}" & disown
            exit 0 ;;
        
        "Exit"|"") exit 0 ;;
    esac
done
