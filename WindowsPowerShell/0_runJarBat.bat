@echo off
echo %date% %time% 
echo �A���o�b�`���s�������J�n���܂��B�B�B

call D:\work\appconfig\DetailImport\1_DetailImport.bat
call D:\work\appconfig\DetailImport\2_DetailImport_gaiyo.bat
call D:\work\appconfig\DetailImport\3_DetailImport_meisai.bat
REM  call D:\work\appconfig\DetailImport\4_DetailImport_Result.bat
REM  call D:\work\appconfig\DetailImport\5_DetailImport_Property.bat

echo �A���o�b�`���s�������������܂����B
REM  echo %date% %time%
REM  pause > nul
REM  exit
