# EdaTecHmi2002-101C
After looking at the driver for the EdaTec HMI 2002-101C I decided to change some things. There are a bunch of things I dont like about the way this package operates.

Dependencies: 
sudo apt install plymouth plymouth-themes lightdm libxkbcommon lxterminal labwc

(maybe more, ... or less.. when I make this pure wayland)

Core changes:
No dial out.
No having to select a device.
No trusting a forgein repo
No need for root
No forced reboot
Changed code to not disable HDMI ports

Todo:

There is a bug in the language settings.

there is a bug in the touch screen transformation settings


Requests:
remove the edatec splash. or make the splash selectable.
