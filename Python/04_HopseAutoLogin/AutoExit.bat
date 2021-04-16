REM  タスクスケジューラからpythonを実行するためのバッチファイル

echo %~dp0
REM ドライブをEに変更
%~d0
REM バッチファイルがあるディレクトリをcurrent directoryに設定
cd %~dp0
python autoExit.py

exit /b