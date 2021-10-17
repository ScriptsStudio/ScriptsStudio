#!/usr/bin/env python3
import subprocess
import platform
import sys


def main():
    argument_list = sys.argv[1:]
    opsy_name = platform.system()
    package_manager_command = ""
    final_query = ""

    # This expects a path to an .apk file and root (sudo) privileges assuming rooted android device
    if subprocess.check_output(['uname', '-o']).strip() == 'Android':
        package_manager_command = "pm install "
        return package_manager_command
    else:
        if opsy_name == "Linux":
            pacman_names = ["apt-get install -y ", "customizer-install ", "flatpak install ", "snap install "]
            # This value might vary between flatpak, snapd, apt-get or Linux-Auto-Customizer
            # For the moment expects a valid app name and may need root (sudo) privileges
            package_manager_command = pacman_names[1]
        elif opsy_name == 'Windows ':
            package_manager_command = "winget install "
            winget_allowance_command = True
        elif opsy_name == "Darwin":
            package_manager_command = "brew install "
    
    for i in range(len(argument_list)):
        final_query += " " + argument_list[i]

    quer = package_manager_command + final_query
    subprocess.run(quer, shell=True)


if __name__ == "__main__":
    main()
