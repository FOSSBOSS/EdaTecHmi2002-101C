# EdaTecHmi2002-101C
<br>
Decided to modify the EDATEC HMI 2002-101C driver installation script, for giggles.
<br>
Dependencies:<br> 
sudo apt install plymouth plymouth-themes lightdm libxkbcommon-dev lxterminal labwc openbox obconf
<br>
Core changes:<br>
No dial out.<br>
No having to select a device.<br>
No trusting a forgein repo.<br>
No forced reboot.<br>
Changed code to not disable HDMI ports.<br>
Changed onscreen keyboard to US english<br>
Changed touch screen orientation to match screen.<br>
Removed loading screen<br>
Changed how the driver"" looks for OS boot files, making this package less about<br> 
the OS version installed and more about which files are present.<br>
This removes a bug that presents itself when you update raspbian, to a newer version.
<br>
<br>
<br>
Todo:
<br>
source files after writing.
<br>
testing.
<br>
Files created:
<br>
$HOME/.config/labwc/rc.xml
<br>
$HOME/.config/kanshi/config
<br>
$HOME/.config/wayfire.ini

Files Modified:
<br>
/boot/config.txt
<br>
OR
<br>
/boot/firmware/config.txt <br>

depending on your installation.


