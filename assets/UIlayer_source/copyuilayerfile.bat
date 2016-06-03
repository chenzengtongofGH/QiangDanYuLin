@echo off
echo 拷贝到对应目录下
xcopy /q /y /s cocosstudio\res\csb\ui ..\pic\res\csb\ui
xcopy /q /y /s res\*.csb ..\pic\res\csb\ui
echo 拷贝完成
rem echo 修改为拷贝资源目录.png和发布目录.csb到目标目录 0408 by zl