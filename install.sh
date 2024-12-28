#!/bin/bash
# consider sourcing the files we create here to avoid needing a reboot 
# to init functionality. 
# General Dependencies:
# sudo apt install plymouth plymouth-themes lightdm libxkbcommon-dev lxterminal labwc openbox obconf
echo "This script requires rootly power for a minute"
# become root without altering who is running the script
sudo -v

#  Check for required files
if [ -e /boot/firmware/config.txt ]; then
    CONFIG_FILE="/boot/firmware/config.txt"  # for bookworm
elif [ -e /boot/config.txt ]; then
    CONFIG_FILE="/boot/config.txt"  # for other OSes
else
    echo "Required config.txt file not found!"
    exit 1
fi
     
# make the screen work:
    echo " " >> $CONFIG_FILE
    echo "dtoverlay=vc4-kms-dsi-rzw-t101p136cq-rpi4-2lane,interrupt=2" >> $CONFIG_FILE
    echo "dtoverlay=vc4-kms-v3d" >> $CONFIG_FILE # keeps HDMI ports functional
    echo "dtoverlay=imx219" >> $CONFIG_FILE

#Create the folders we think we need:
    mkdir -p $HOME/.config/labwc
    mkdir -p $HOME/.config/kanshi
    
# setup Touch-screen stuff    
cat > $HOME/.config/wayfire.ini << EOF
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
xkb_layout = us
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

# write the touch screen config
cat > $HOME/.config/kanshi/config << EOF
profile {
        output DSI-1 mode 800x1280 position 0,0 transform 0
}

EOF

# wayland config touch screen
cat > $HOME/.config/labwc/rc.xml << EOF
<?xml version='1.0' encoding='UTF-8'?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <touch deviceName="10-0014 Goodix Capacitive TouchScreen" mapToOutput="DSI-1" />
</openbox_config>
EOF
 
chown -R $USER:$USER $HOME/.config
:'
# Lets see... what files did we create?
$HOME/.config/labwc/rc.xml
$HOME/.config/kanshi/config
$HOME/.config/wayfire.ini
# then theres these:
/boot/config.txt
/boot/firmware/config.txt
# I cant think of a single issue of sourcing a file that might not exist. 
# though this might be the time and place to check OS version.
'
