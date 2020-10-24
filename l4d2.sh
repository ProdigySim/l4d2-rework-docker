#!/bin/sh
cd $HOME/hlserver
l4d2/srcds_run -game left4dead2 -tickrate 100 -autoupdate -steam_dir ~/hlserver -steamcmd_script ~/hlserver/l4d2_ds.txt $@
