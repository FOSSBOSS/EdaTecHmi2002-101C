# EdaTecHmi2002-101C
Decided to modify the EDATEC HMI 2002-101C driver installation script, for giggles.

Dependencies: 
sudo apt install plymouth plymouth-themes lightdm libxkbcommon-dev lxterminal labwc openbox obconf

Core changes:
No dial out.
No having to select a device.
No trusting a forgein repo.
No forced reboot.
Changed code to not disable HDMI ports.
Changed onscreen keyboard to US english
Changed touch screen orientation to match screen.
Removed loading screen
Changed how the driver"" looks for OS boot files, making this package less about 
the OS version installed and more about which files are present.
This removes a bug that presents itself when you update raspbian, to a newer version.



Todo:
source files after writing.
testing.

Files created:

$HOME/.config/labwc/rc.xml
$HOME/.config/kanshi/config
$HOME/.config/wayfire.ini

Files Modified:
/boot/config.txt

OR

/boot/firmware/config.txt

depending on your installation.


