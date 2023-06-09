#!/usr/bin/env zsh

set -e

if [ -d "./Poppy.app" ] 
then
    echo "SUCCESS:Directory Poppy.app exists!" 
else
    echo "ERROR: Directory Poppy.app missing!" 
    exit 1
fi
