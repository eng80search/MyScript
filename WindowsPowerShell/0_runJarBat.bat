@echo off
echo %date% %time% 
echo 連続バッチ実行処理を開始します。。。

call D:\work\appconfig\DetailImport\1_DetailImport.bat
call D:\work\appconfig\DetailImport\2_DetailImport_gaiyo.bat
call D:\work\appconfig\DetailImport\3_DetailImport_meisai.bat
REM  call D:\work\appconfig\DetailImport\4_DetailImport_Result.bat
REM  call D:\work\appconfig\DetailImport\5_DetailImport_Property.bat

echo 連続バッチ実行処理が完了しました。
REM  echo %date% %time%
REM  pause > nul
REM  exit
