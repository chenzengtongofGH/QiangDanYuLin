#!/bin/sh
rm -f ../../../parkout_server_res/$1/skygame/demo/config/game/*.lua

cp -f proto/*.lua ../outputClient/
cp -f ../outputClient/*.lua ../../../parkout_server_res/$1/skygame/demo/config/game/
cp -f ../outputServer/*.lua ../../../parkout_server_res/$1/skygame/demo/config/