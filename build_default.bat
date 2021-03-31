@echo off
REM 
chcp 65001
CLS

tree src /F 
echo.

mkdir "./build/default/proj"
cd "./src"

cmake -S "." -B "../build/default/proj"
cmake --build "../build/default/proj" --target Demo --config Release
echo.
echo "已执行完毕(退出请按任意键或直接关闭窗体)-----------------------"
echo.

pause