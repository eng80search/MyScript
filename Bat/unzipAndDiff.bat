@echo off
chcp 932
setlocal enabledelayedexpansion

@echo 開始時刻 %date% %time%
rem --------------------------------------------------------------------------------
rem zipファイルを解凍し、さらに解凍したファイルをWinmergeでdiffを作成
rem --------------------------------------------------------------------------------

rem 設定
set UNZIP_SOURCE_PATH=C:\Users\T21A824\00_work\77_Temp\
set REPORT_TITLE=.\diff.htm
echo "UNZIP_SOURCE_PATH:"%UNZIP_SOURCE_PATH%

rem diffタイトルが指定された場合はそれに設定する
if NOT "%1" == "" (
  set REPORT_TITLE=.\%1.htm
) else (
  set REPORT_TITLE=.\diff.htm
)

rem 解凍先ディレクトリへ移動
cd %UNZIP_SOURCE_PATH%

rem Windows PowerShellコマンドでzipファイルを解凍
echo "-------------------- zipファイルを解凍　開始 --------------------"
PowerShell -ExecutionPolicy RemoteSigned -command "Expand-Archive -Force 変更前.zip"
PowerShell -ExecutionPolicy RemoteSigned -command "Expand-Archive -Force 変更後.zip"
echo "-------------------- zipファイルを解凍　終了 --------------------"

echo "-------------------- Winmergeでレポート作成　開始 --------------------"
rem Winmergeでdiffレポートを作成
WinMergeU 変更後 変更前 -minmize -noninteractive -cfg Settings/DirViewExpandSubdirs=1^
                        -cfg ReportFiles/ReportType=2 -cfg ReportFiles/IncludeFileCmpReport=1 -r -u -or %REPORT_TITLE%
echo "-------------------- Winmergeでレポート作成　終了 --------------------"

rem 変更前.zipを削除する　変更後.zipを削除する
rem del 変更前.zip
rem del 変更後.zip


rem 自分自身のディレクトリへ戻る
cd %~dp0
@echo 終了時刻 %date% %time%
