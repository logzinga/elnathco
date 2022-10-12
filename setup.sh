#!/bin/bash

echo "Are you connected to the internet? [ y / n ]"
read INTERNETCONNECTION

if [ $INTERNETCONNECTION = n ]
    then
        echo "You must be connected to the internet to continue"
        sleep 2
        clear 
        exit
fi
