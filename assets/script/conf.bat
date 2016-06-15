@echo off

if not exist ..\outputClient mkdir ..\outputClient
if not exist ..\outputServer mkdir ..\outputServer
if not exist ..\outputAdminServer mkdir ..\outputAdminServer

del /f /s /q ..\outputClient\*.*
del /f /s /q ..\outputServer\*.*
del /f /s /q ..\outputAdminServer\*.*

echo "---common---"
cd common
python start.py %3
cd ..

echo "---role---"
cd role
python start.py %3
cd ..

echo "---map---"
cd map
python start.py %3
cd ..

echo "---skill---"
cd skill
python start.py %3
cd ..

echo "---equip---"
cd equip
python start.py %3
cd ..

echo "---item---"
cd item
python start.py %3
cd ..