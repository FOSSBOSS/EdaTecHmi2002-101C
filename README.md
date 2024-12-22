# EdaTecHmi2002-101C
After looking at the driver for the EdaTec HMI 2002-101C I decided to change some things. There are a bunch of things I dont like about the way this package operates.

Some basic stuff, I only have the HMI 2002-101C so selecting from a list is pointless.


Synopsis:
The actual "driver" contains no firmware. Wayland Screen overlays are used. 

Irks:

I dont like explicitly trusting some thrid part repo nor do I like that a pseudo user account is created. 

The source code has a bunch of suspicious stuff in my opionion, but beyond that, I dont like how it isnt very portable, or distro agnostic.

installation of the OG source will make the screen run, but it will also break HDMI output, which is obnoxious.

The sofware is schiz, dependent on both wayland and x11, I'll fix that, and go with wayland or x11, or make that an option to pick usage of one or the other.

 

Dependencies: 
sudo apt install plymouth plymouth-themes lightdm xkb lxterminal labwc

(maybe more, ...)

Core changes:
No dial out.
No having to select a device.
No trusting a forgein repo
No downloading other sources.
No forced reboot

Todo:
remove or limit rootly power use.

Requests:
remove the edatec splash. or make the splash selectable.
