if exist ..\outputClient\ copy /y proto\*.lua ..\outputClient\
if exist ..\client\src\app\conf\ copy /y ..\outputClient\*.lua ..\client\src\app\conf\
if exist ..\client\src\app\conf\ del ..\client\src\app\conf\randomdb.lua
if exist ..\..\server\trunk\skygame\demo\config\game\ copy /y ..\outputClient\*.lua ..\..\server\trunk\skygame\demo\config\game\
if exist ..\..\server\trunk\skygame\demo\config\ copy /y ..\outputServer\*.lua ..\..\server\trunk\skygame\demo\config\