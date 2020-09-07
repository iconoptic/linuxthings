#! /bin/bash
cd ~/.fallout/drive_c/INTRAPLAY/FALLOUT
Xephyr :1 -ac -screen 800x600x8&
DISPLAY=:1 WINEPREFIX=~/.fallout/ xterm
