#!/usr/bin/env python3
import os
import install

#os.system("install.sh test")
hackage_manager = install.process_packagemanager(install.plat())

def process_packages(platf):
    if platf == "Linux":
        return [" test", " test2"]

    elif platf == "Windows":
        return ["Python3.Python3"]

    elif platf == "Darwin":
        pass

tmp = ""
package_list = process_packages(install.plat())

os.system(hackage_manager + tmp.join(package_list))
