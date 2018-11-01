#   dceinstall.sh - Automated installation of dce 1.7 (ns3/linux)
#   Copyright (C) 2015 Wireless Information Networking Group (WiNG), NITK Surathkal, Mangalore, India.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License version 3 as published by
#   the Free Software Foundation.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#	/************************************************************************/
#	/*									*/							
#       /*                                                                      */
#	/*	Designed and Developed by :			  		*/
#	/*    	Vijayendra Reddy Gillella, Nishad Samant and Mohit P Tahiliani 	*/
#	/*   		Wireless Information Networking Group (WiNG)          		*/ 
#	/*    	National Ins&&tute of Technology Karnataka, Surathkal  		*/
#	/*    	Mangalore, Karnataka, INDIA.                           		*/
#	/*    	wing@nitk.ac.in , nitkwing@gmail.com                   		*/ 
#	/*    	http://wing.nitk.ac.in  					*/
#	/*                     							*/
#	/************************************************************************/
#
# OS: Ubuntu 14.04, 15.04 and 16.04
#!/bin/bash

set -e

# Run Update
# sudo apt -y update

# Install DCE on Desktop
cd ~/Desktop

if [ ! -d "dce" ]; then
mkdir dce
fi

cd dce
echo "-------------------------------------------------------------------------------------"
echo "Enter 'ns3' for installing dce-ns3-dev OR 'linux' for installing dce-linux-dev"
read var

if [ "$var" != "ns3" ] && [ "$var" != "linux" ]; then
    echo "Enter vaild component name to install ns-3-dce (Example ns3 or linux)"
    exit
fi

sudo apt -y install mercurial

if [ ! -d "bake" ]; then
hg clone http://code.nsnam.org/bake bake
fi

export BAKE_HOME=`pwd`/bake
export PATH=$PATH:$BAKE_HOME
export PYTHONPATH=$PYTHONPATH:$BAKE_HOME

#Installing necessary components as per 'bake.py check' command
sudo apt -y install cmake cvs git
sudo apt -y install bzr unrar
sudo apt -y install p7zip-full autoconf

type="dce-"$var"-dev"

# Check whether there exists a previously installed copy
if [ -d "$type" ]; then
echo "-------------------------------------------------------------------------------------"
echo "It seems there already exists a $type directory!"
echo "Rename the existing $type directory on your machine and run this script again"
echo "-------------------------------------------------------------------------------------"
exit
fi

mkdir $type
cd $type

#Installing components required for dce
sudo apt -y install build-essential bison
sudo apt -y install flex g++
sudo apt -y install libc6 libc6-amd64
sudo apt -y install libdb-dev libexpat1-dev
sudo apt -y install libpcap-dev libssl-dev
sudo apt -y install python-dev python-pygraphviz
sudo apt -y install python-pygoocanvas python-setuptools
sudo apt -y install qt4-dev-tools

bake.py configure -e $type
bake.py download
bake.py build -vvv
