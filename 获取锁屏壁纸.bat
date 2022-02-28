@echo off

::复制文件
cd C:\Users\%username%\Pictures\Saved Pictures
mkdir tmpPics
for %%i in (C:\Users\%username%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*) do (
 if %%~zi gtr 307200 copy %%i tmpPics
)

::重命名
for  %%i in (tmpPics\*) do (
 ren %%i *.jpg
 if ERRORLEVEL 1 del %%i
)

::保留1920*1080的照片
cd tmpPics
setlocal enabledelayedexpansion
set Pic=*.jpg,*.jpeg,*.png,*.bmp,*.gif

call :CreatVBS
(for /f "delims=" %%a in ('dir /a-d/s/b %Pic%') do (
    for /f "tokens=1-4 delims=x" %%b in ('cscript -nologo "%tmp%\GetImgInfo.vbs" "%%~sa"') do (
        if %%~b NEQ 1920 (del %%~nxa)
    )
))
pause
exit
  
:CreatVBS
(
echo On Error Resume Next
echo Dim Img
echo Set Img = CreateObject^("WIA.ImageFile"^)
echo Img.LoadFile WScript.Arguments^(0^)
echo Wscript.Echo Img.Width ^& "x" ^& Img.Height ^& "x" ^& Img.HorizontalResolution ^& "x" ^& Img.FileExtension)>"%tmp%\GetImgInfo.vbs"
goto :eof