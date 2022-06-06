echo off
rem コマンドプロンプトからmsbuildを実行して、ソリューションをビルドする
rem 注意：本ファイルのEncoding=Sjis

rem Vimでカレントディレクトリを挿入する方法 :r!pwd
rem Vimで自分のファイル名を貼り付け方法： "%p

rem ************************************************************************
rem * 概要：　テストデータの作成、ソリューションのビルド、Exeを実行するバッチ
rem * 実行方法：　autoRun_RDAステータス管理.bat --build --data
rem *
rem ************************************************************************

set CURRENT_DIR=%~dp0
set TEST_MODULE_DIR="C:\\Users\\T21A824\\00_work\\01_Source\\09_RDSステータス管理対応\\RDA_TEST_Stub"
set EXE_MODULE_DIR="C:\\ProgramData\\APLWORK\\基盤\\RDAステータス管理\\RegProcStatus"

echo ***************** BAT処理を開始しました *******************************

rem Debugモードで実行する場合は、ps1ファイルのパスを開発環境のものに変更する
if "%1" == "--build" (
  
  rem テストモジュールをビルドする
  echo -------- テストモジュールをビルドする -------------
  cd %TEST_MODULE_DIR%
  msbuild /t:build /p:configuration=debug /p:Plateform="x64"
  
  rem RDAステータス管理Exeモジュールをビルドする
  echo -------- RDAステータス管理Exeモジュールをビルドする -----------
  cd %EXE_MODULE_DIR%
  msbuild /t:build /p:configuration=debug /p:Plateform="x64"
  
) else if "%1" == "--data" (
  
  echo ------------- テスト用データを作成 -----------------
  cd %CURRENT_DIR%
  rem テスト用データ作成用バッチを呼び出す
  call makeTestData_RDAステータス管理.bat
  
) else if "%1" == "--data-only" (

  echo ---------------- テスト用データを作成 ------------------
  cd %CURRENT_DIR%
  call makeTestData_RDAステータス管理.bat
) 

if "%2" == "--data" (
  
  echo -------------- テスト用データを作成 --------------------
  cd %CURRENT_DIR%
  call makeTestData_RDAステータス管理.bat
)

echo 開始時刻 %date% %time%

if NOT "%1" == "--data-only" (
  rem RDAステータス管理バッチを呼び出す
  echo -------------- RDAステータス管理バッチを呼び出す ------------------
  cd C:\ProgramData\APLWORK\基盤\RDAステータス管理\BAT
  call RegProcStatus.bat
)

cd %CURRENT_DIR%
echo 終了時刻 %date% %time%
echo ***************** BAT処理が完了しました *******************************
