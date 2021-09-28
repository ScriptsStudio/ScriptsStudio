- LINUX SPEC IDEAS
	- Bulk rename function
	- Change Ubuntu user's bar position (enhanced for user) `gsettings set org.gnome.shell.extensions.dash-to-dock dock-position RIGHT` (Left to revert to original)
	- Change Ubuntu to dark theme (enhanced for user) `gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"` (Consider to change it back to the previous in uninstall)
	- Change Ubuntu top tray/taskbar 
		- `gsettings set org.gnome.desktop.interface clock-show-weekday true`
		- `gsettings set org.gnome.desktop.interface clock-show-date false`
	- Change Ubuntu default icon theme
		- `gsettings set org.gnome.desktop.interface icon-theme Yaru`
	- Change Ubuntu window's control to left `gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'`
	- Add/Remove Crontab function
	- Add/Remove repository function
	- Install/Remove dependencies
	- Update & program installation using default package manager of device after repository has been added if needed or perform manual installations/uninstallations

	- If installation is not set, try to use default package manager, if code 1 error is returned (default package manager failed) just keep trying related package managers. FALLBACK

- TECHNICAL MULTIPLATFORM IDEAS
	- use pm to install / uninstall within phone (care about root permissions) *adb

	- use netcat (nc) to pipe commands via port to devices using ssh connection.

	- Analyze network hosts to know IP's and ports from devices and secure its ssh connections bestly as possible

	- update to last version of stable releases of applications automatically and have the latest url available from the features from its official page if possible.



