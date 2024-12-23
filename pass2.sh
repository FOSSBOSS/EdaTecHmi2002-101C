#!/bin/bash
 set -x
# dependencies:plymouth plymouth-themes lightdm libxkbcommon lxterminal labwc
# sudo apt install plymouth plymouth-themes lightdm xcb libxkbcommon lxterminal labwc
# yes the ugly x11/wayland dependencies still exist

# found some bugs, keymapings will always set to gb Great Britian 
# I think the touch screen transformation should be 180, or 0, not 90

#[window-rules]
#rule-1 = on created if title is "LXTerminal" then maximize
# see if we can make this maximize without the need for a specific terminal emulator

#DEVICES="hmi2002_101c"
#TARGET=$DEVICES
    #install -m 644 "${tmp_dir}splash.png" "/usr/share/plymouth/themes/pix/"
# i just realized the entire startup part of the script is just doing network stuf I dont even want

#POSINST

echo " #### postinstal reached #######"
read
#why is code name redefined?
CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME=)
echo $CODENAME
CODENAME=${CODENAME#VERSION_CODENAME=}
echo $CODENAME
#CONFIG_FILE="/boot/firmware/config.txt"
CONFIG_FILE="/home/h/Desktop/eta/config.txt"
echo $CONFIG_FILE
read

#if [ "${CODENAME}" = "bookworm" ];then
if [ "${CODENAME}" = "noble" ];then
    #CONFIG_FILE="/boot/firmware/config.txt"
    CONFIG_FILE="/home/h/Desktop/eta/config.txt"
    if [ ! -f "$CONFIG_FILE" ];then
       echo "Exited" && read
        #exit 0
    fi
else
    #CONFIG_FILE="/boot/config.txt"
    CONFIG_FILE="/home/h/Desktop/eta/config.txt"
    if [ ! -f "$CONFIG_FILE" ];then
    echo "config not found Exited" && read
        #exit 0
    fi
fi

auto_add() {
	
	#$1 in context is either the device or the program name
    local value=$1
    grep "^${value}" $CONFIG_FILE
   # grep -q "^${value}" $CONFIG_FILE
    if [ $? -ne 0 ]; then
        sed -i '$a '"${value}" $CONFIG_FILE
    fi
}


write_ini(){
    local t_user=$1
    #echo  "  " && read
    echo $t_user " T_USER #############" && read
    # user is $USER scirpt doesnt rerun, so if you add a user the ""driver will break lol
    #mkdir -p /home/${t_user}/.config
    #mkdir -p /home/$USER/.config
    mkdir -p /home/h/Desktop/eta/config
#cat > /home/${t_user}/.config/wayfire.ini << EOF
cat > /home/h/Desktop/eta/config/wayfire.ini << EOF
[command]
repeatable_binding_volume_up = KEY_VOLUMEUP
command_volume_up = wfpanelctl volumepulse volu
repeatable_binding_volume_down = KEY_VOLUMEDOWN
command_volume_down = wfpanelctl volumepulse vold
binding_mute = KEY_MUTE
command_mute = wfpanelctl volumepulse mute
binding_menu = <super>
command_menu = wfpanelctl smenu menu
binding_terminal = <ctrl> <alt> KEY_T
command_terminal = lxterminal
binding_bluetooth = <ctrl> <alt> KEY_B
command_bluetooth = wfpanelctl bluetooth menu
binding_netman = <ctrl> <alt> KEY_W
command_netman = wfpanelctl netman menu
binding_grim = KEY_SYSRQ
command_grim = grim
binding_orca = <ctrl> <alt> KEY_SPACE
command_orca = gui-pkinst orca reboot
binding_quit = <ctrl> <alt> KEY_DELETE
command_quit = lxde-pi-shutdown-helper
binding_power = KEY_POWER
command_power = pwrkey

[input-device:generic ft5x06 (79)]
output = DSI-1

[input-device:generic ft5x06 (80)]
output = DSI-1

[input-device:FT5406 memory based driver]
output = DSI-1

[input]
xkb_model = pc105
xkb_layout = gb
xkb_variant =

[output:DSI-1]
mode = 800x1280@40000
position = 0,0
transform = 90

[input-device:Goodix Capacitive TouchScreen]
output = DSI-1

[input-device:10-0014 Goodix Capacitive TouchScreen]
output = DSI-1

[window-rules]
rule-1 = on created if title is "LXTerminal" then maximize
EOF
#    chown -R ${t_user}:${t_user} /home/${t_user}/.config
}

do_labwc(){
    local t_user=$1
    echo  $t_user" t user from do_labwc Function " && read
    #mkdir -p /home/${t_user}/.config/
    #mkdir -p /home/${t_user}/.config/labwc
    #mkdir -p /home/${t_user}/.config/kanshi
    mkdir -p /home/h/Desktop/eta/config/
    mkdir -p /home/h/Desktop/eta/config/labwc
    mkdir -p /home/h/Desktop/eta/config/kanashi

    # FUN Fact kanshi is to spy on in Chinese
    
#cat > /home/${t_user}/.config/kanshi/config << EOF
cat > /home/h/Desktop/eta/config/kanashi/config << EOF
profile {
        output DSI-1 mode 800x1280 position 0,0 transform 90
}

EOF
echo  $t_user" t user  " && read
#cat > /home/${t_user}/.config/labwc/rc.xml << EOF
cat > /home/h/Desktop/eta/config/labwc/rc.xml << EOF
<?xml version='1.0' encoding='UTF-8'?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <touch deviceName="10-0014 Goodix Capacitive TouchScreen" mapToOutput="DSI-1" />
</openbox_config>
EOF
#chown -R ${t_user}:${t_user} /home/${t_user}/.config
}

write_ini_auto(){
    if [ -f "/usr/bin/labwc" ];then
       # raspi-config nonint do_wayland W3
       echo "configured wayland"
       echo  $t_user" t user  " && read
    fi
# for every user in /home at the time the script is run, do:
    for t_user in `ls /home/`
    do
        if [ -d "/home/${t_user}" ];then
            if [ -f "/usr/bin/labwc" ];then
                do_labwc ${t_user}
            fi
            write_ini "${t_user}"
            #whayt?
            echo  $t_user" t user  " && read
        fi
    done
}

start() {
    
    auto_add "dtoverlay=vc4-kms-dsi-rzw-t101p136cq-rpi4-2lane,interrupt=2"
    auto_add "dtoverlay=vc4-kms-v3d"  # Ensures HDMI is retained
    auto_add "dtoverlay=imx219"
    echo "" >> $CONFIG_FILE
    #:'
    #auto_add "dtoverlay=vc4-kms-dsi-rzw-t101p136cq-rpi4-2lane,interrupt=2"
    #auto_add "dtoverlay=imx219"
    #echo "" >> $CONFIG_FILE
    #'
#JKJJK do it anyway uncomnent the condition later
write_ini_auto
 #   if [ "${CODENAME}" = "bookworm" ];then
 #       write_ini_auto
 #   fi
}

start
