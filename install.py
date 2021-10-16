#!/usr/bin/env python3
import subprocess
import platform
import sys


opsy_name = platform.system()
package_manager_command = ""


def initialize_package_manager_command():
    # This expects a path to an .apk file and root (sudo) privileges assuming rooted android device
    if subprocess.check_output(['uname', '-o']).strip() == 'Android':
        package_manager_command = "pm install "
        return package_manager_command
    else:
        if opsy_name == "Linux":
            print(opsy_name)
            pacman_names = ["apt-get install -y ", "customizer-install ", "flatpak install ", "snap install "]
            # This value might vary between flatpak, snapd, apt-get or Linux-Auto-Customizer
            # For the moment expects a valid app name and may need root (sudo) privileges
            package_manager_command = pacman_names[0]
        elif opsy_name == 'Windows ':
            print(opsy_name)
            package_manager_command = "winget install "
            winget_allowance_command = True
        elif opsy_name == "Darwin":
            print(opsy_name)
            package_manager_command = "brew install "
        #print(package_manager_command)
        return package_manager_command


if __name__ == "__main__":
    argument_list = sys.argv[1:]

    try:
        quer = initialize_package_manager_command()
        for arg in argument_list:
            quer += arg + " "
            
        subprocess.run(quer, shell=True)

    except:
        print("ERROR: Could not launch installation")
        exit(1)
    finally:
        exit(0)
