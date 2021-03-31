@echo off
REM 
chcp 65001
CLS


if exist ".\build\default" (
	rmdir /s/q ".\build\default"
)

echo.
echo "已执行完毕(退出请按任意键或直接关闭窗体)-----------------------"
echo.

pause