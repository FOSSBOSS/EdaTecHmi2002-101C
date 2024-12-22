#!/bin/bash
#set -xv
:'
Dependencies: 
sudo apt install plymouth plymouth-themes lightdm xcb lxterminal labwc

Core changes:
No dial out.
No having to select a device.
No trusting a forgein repo
No downloading other sources.
No forced reboot

## /home/${t_user}/.config/kanshi/config
## Profile is where touchscreen orientation can be changed manualy

per MGT request: delete loading splash

'

DEVICES="hmi2002_101c"

TARGET=DEVICES

function log_error(){
    echo "log_error function reached"
    read
    local msg=$1
    echo -e "\033[31m ${msg} \033[0m"
    echo "log error fucntion reached press ctrl+C to exit"
    read 
}

function log_info(){
   echo "log_info Fucntion Reached"
     read
    #local msg=$1
    local msg=DEVICES
    echo -e "\033[32m ${msg} \033[0m"
    echo "log info reached, press ctrl+C to exit or enter to continue"
    read
}

function load_json(){
    echo "Load Jason fucntion reached Press enter to continue"
    read
    
    case $# in
        2)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"'])"
            ;;
        3)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"']['"$3"'])"
            ;;
        4)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"']['"$3"']['"$4"'])"
            ;;   
        5)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"']['"$3"']['"$4"']['"$5"'])"
            ;;  
        6)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"']['"$3"']['"$4"']['"$5"']['"$6"'])"
            ;;  
        7)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"']['"$3"']['"$4"']['"$5"']['"$6"']['"$7"'])"
            ;;  
        8)
            echo $1 |  python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"$2"']['"$3"']['"$4"']['"$5"']['"$6"']['"$7"']['"$8"'])"
            ;;  
    esac
    # python3 -c "import sys, json; data=json.load(sys.stdin); print(data['test']['target'])
}

function is_in_json(){
   echo "is_in_jason reached" 
   read 
   local t_data=$1
    local t_key=$2
    echo $t_data | python3 -c "import sys, json; data=json.load(sys.stdin); print('"${t_key}"' in data)"
}

function load_json_len(){
echo "load_jason_len fucntion reached"
read
local t_data=$1
    local t_key=$2
    echo $t_data | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data['"${t_key}"']))"
}

function load_json_array(){
	echo "laod_jason_array reachd"
	read
    local t_data=$1
    local t_key=$2
    local t_index=$3
    echo $t_data | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['"${t_key}"']["${t_index}"])"
}


function run_cmd(){
echo "run_cmd reached"
read
#local cmd=$1
    local cmd=DEVICES
    #log_info "[DEBUG] ${cmd}"
    eval "$cmd"
}

function install_eda(){
  echo "install_eda fucntion reached"
  read
    #local tmp_dir="${TMP_PATH}/eda/"
    #mkdir -p $tmp_dir
    #wget "${BASE_URL}/splash.png" -O "${tmp_dir}splash.png"
    install -m 644 "splash.png" "/usr/share/plymouth/themes/pix/"
echo "gonna bet /usr/share/plymouth/themes/pix aint a thing on diet pi"
echo "maybe try /boot/grub/grub.cfg"
echo " GRUB_CMDLINE_LINUX_DEFAULT="""
echo "sudo update-grub"
echo "/boot/splash.png"


    local code_name=$(cat /etc/os-release | grep VERSION_CODENAME=)
    local cmd_file="/boot/firmware/cmdline.txt"
    code_name=${code_name#VERSION_CODENAME=}
    if [ "${code_name}" = "bookworm" ];then
        cmd_file="/boot/firmware/cmdline.txt"
echo "loading bookworm"
else
        cmd_file="/boot/cmdline.txt"
	echo "loading some other bullshit"
    fi

    grep -q "net.ifnames=0" ${cmd_file} || sed -i "1{s/$/ net.ifnames=0/}" ${cmd_file}
echo "loaded net interface names to the config file"
read
    #wget "https://apt.edatec.cn/pubkey.gpg" -O "${tmp_dir}edatec.gpg"
    #cat ${tmp_dir}edatec.gpg | gpg --dearmor > "/etc/apt/trusted.gpg.d/edatec-archive-stable.gpg"
    #echo "deb https://apt.edatec.cn/raspbian stable main" | sudo tee /etc/apt/sources.list.d/edatec.list
    #sudo apt update
}


function start(){
	echo "start fucntion reached"
	read
    #local data=$(curl ${BASE_URL}/devices/${TARGET}.json --connect-timeout ${TIMEOUT})
    local data="hmi2002_101c.json"
    if [ $? -ne 0 ];then
        echo "Load device info failed."
        exit 2
    fi
    echo "About to install eda"
    read
    install_eda
echo "about to install a bunch of jason"
echo "not loading state files so.. debs will fail"
read
    local b_state=$(is_in_json "${data}" "debs")
    echo "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    echo $b_state "  " $data
    read
    if [ "${b_state}" == "True" ];then
        local debs=$(load_json "${data}" "debs")
        #log_info "[DEBUG] apt install -y ${debs}"
        #sudo apt install -y ${debs}
         #not doing that anymore, use functions of postinst, and postrm
         echo $debs " DEBS LOL #############"
	 read
        if [ $? -ne 0 ];then
            #log_error "Failed to install package"
           # exit 1
	   echo "We're probably in error, but we're pressing on"
        read
	fi
    fi
    
    b_state=$(is_in_json "${data}" "cmd")
    if [ "${b_state}" == "True" ];then
        local t_len=$(load_json_len "${data}" "cmd")
        echo $t_len " t_len and i "$i
	read
	index=0
        for i in $(seq 0 $((${t_len} -1)));do
            t_cmd=$(load_json_array "${data}" "cmd" $i)
            run_cmd "${t_cmd}"
         done
    fi
    echo "reboot to make changes"
}

#function useage(){
    #log_info "curl -s ${BASE_URL}/ed-install.sh | sudo bash -s <device name>"
    #log_info "ed-install.sh"
    #log_info "Suport device:"
    #for d in ${DEVICES[@]}
    #do
    #    log_info "    ${d}"
    #done
    #echo "Usage: sudo ./ed-install.sh"
    #echo "The only reason we need root is to write a file to a folder that doesnt even exist on this system"
    #echo "write the splash sceen to /usr/share/....."
   # read
#}

if [ -z "${TARGET}" ]; then
    #log_error "Please specify the target."
 echo "TARGET is empty!"
#    useage
else
    if [ -n "${DEVICES}" ];then
        echo "${DEVICES}" | grep -q "${TARGET}"
        if [ $? -eq 0 ];then
            start $TARGET
        else
#            log_error "Unknown target."
            useage
        fi
    else
        start $TARGET
    fi
    
    # start $TARGET
fi

echo "################### Actual Damn Installation bits ##########################"

#set -x

CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME=)
CODENAME=${CODENAME#VERSION_CODENAME=}
CONFIG_FILE="/boot/firmware/config.txt"
echo "Codename " $CODENAME
echo "CONFIG File " $CONFIG_FILE
read
if [ "${CODENAME}" = "bookworm" ];then
    CONFIG_FILE="/boot/firmware/config.txt"
    if [ ! -f "$CONFIG_FILE" ];then
       echo "exited because config file not bookworm " $CONFIG_FILE	   
       #exit 0
        
    fi
else
    CONFIG_FILE="/boot/config.txt"
    if [ ! -f "$CONFIG_FILE" ];then
	echo "exited when config was not bullseye "    $CONFIG_FILE
	#exit 0
    fi
fi

auto_add(){
echo "leaving default prams for now"

    local value=$1
echo "Value == " $value
read
    grep -q "^${value}" $CONFIG_FILE
    if [ $? -ne 0 ];then
        sed -i '$a '"${value}" $CONFIG_FILE
    fi
}

write_ini(){
    #local t_user=$1  # this would have been hmi2002_101C
   # local t_user=$USER
    #mkdir -p /home/${t_user}/.config
    mkdir -p $HOME/.config
cat > /home/${t_user}/.config/wayfire.ini << EOF
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
    chown -R ${t_user}:${t_user} /home/${t_user}/.config
}

do_labwc(){
    local t_user=$USER
    mkdir -p /home/${t_user}/.config/
    mkdir -p /home/${t_user}/.config/labwc
    mkdir -p /home/${t_user}/.config/kanshi
echo "Fun fact: kanshi means to spy on in Chinese"
cat > /home/${t_user}/.config/kanshi/config << EOF
profile {
        output DSI-1 mode 800x1280 position 0,0 transform 90
}

EOF
cat > /home/${t_user}/.config/labwc/rc.xml << EOF
<?xml version='1.0' encoding='UTF-8'?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <touch deviceName="10-0014 Goodix Capacitive TouchScreen" mapToOutput="DSI-1" />
</openbox_config>
EOF
chown -R ${t_user}:${t_user} /home/${t_user}/.config
}

write_ini_auto(){
echo "write_ini function reached ... there is no way this got that far"
read
    	if [ -f "/usr/bin/labwc" ];then
        raspi-config nonint do_wayland W3
    fi

    for t_user in `ls /home/`
    do
        if [ -d "/home/${t_user}" ];then
            if [ -f "/usr/bin/labwc" ];then
                do_labwc ${t_user}
            fi
            write_ini "${t_user}"
        fi
    done
}

start(){
    auto_add "dtoverlay=vc4-kms-dsi-rzw-t101p136cq-rpi4-2lane,interrupt=2"
    auto_add "dtoverlay=imx219"
    echo "" >> $CONFIG_FILE

    if [ "${CODENAME}" = "bookworm" ];then
        write_ini_auto
    fi
}

start

#exit 0
echo "lets imageine we make it this far and dont crash"
echo "chack .config/ for stuff."
echo "look for /usr/bin/labwc"

