#!/bin/bash

echo "This script will update the installer with the latest version avaliable on GitHub."
pause 2
cd /
git clone https://github.com/logzinga/elnathco
cd elnathco
./setup.sh 