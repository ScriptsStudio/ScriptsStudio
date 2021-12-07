#!/usr/bin/env python3
import os
import install
import subprocess


#os.system("install.sh test")
hackage_manager = install.process_packagemanager(install.plat())

if install.plat() == "Linux":
	package_list = [" test", " test2"]
	tmp = ""
	os.system(hackage_manager + tmp.join(package_list))

elif install.plat() == "Windows":
    pass

elif install.plat() == "Darwin":
    pass

