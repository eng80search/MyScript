@echo off
rem *文字コード設定sjis*
chcp 932
setlocal enabledelayedexpansion

rem ******************************************************************************
rem * バッチ名
rem * 処理概要 #RDAリードレプリカ反映チェックテスト用データを作成
rem * 必須項目：エビデンス　ログ出力ファイル　Exe実行画面　ステータス登録結果
rem ******************************************************************************

echo ******************************************************************************
echo ******* Case4_Error: 異常系
echo ４．前提ジョブが1件の場合、リードレプリカ反映チェックのDB更新時が過去の日付である
echo ******************************************************************************

rem ========================= メッセージ定義 ========================
set START_MSG=********* 処理を開始しました。 *****************
set END_OK_MSG=********* 処理が正常に終了しました。 *****************
set END_NG_MSG=********* 処理が異常に終了しました。 *****************

set TEST_INDEX=4

set EXE_LOG_PATH=C:\ProgramData\APLWORK\基盤\RDAステータス管理\RegProcStatus\RegProcStatus\log\
set EXE_LOG_FILE=RegProcStatus_%date:/=%.log
set CURRENT_DIR=%~dp0
set SQL_FILE=Case%TEST_INDEX%_Error.sql
set LOG_FILE=実行ログ.log
set SERVER_DB_NAME="(localdb)\MSSQLLocalDB"

rem ログ出力結果空ファイルを作成
copy /y nul %LOG_FILE% > nul
echo %date% %time% 処理対象SERVER: %SERVER_DB_NAME% >> %LOG_FILE%

echo %date% %time%  %START_MSG%

rem テスト用データを作成
rem -b オプションはsqlcmdがエラーが発生したときに、sqlcmdを終了し、DOS ERRORLEVEL値を返す。
rem SQL Serverのエラーメッセージの重大度が10よりも高い場合、DOS ERRORLEVEL変数に返される値は1
rem それ以外は0が返される

rem 既存のログファイルを削除する
echo "EXE_LOG_PATH%%EXE_LOG_FILE%"
del "EXE_LOG_PATH%%EXE_LOG_FILE%"

echo "前提ジョブの終了時刻を確認、スクリーンショットを保存すべき"
clear
'Jp1 コマンドを実行する
call ajsshow /TEST_RDA/PREJOB1/

PAUSE
clear

for /L %%A IN (1,1,1) DO (

  cd %CURRENT_DIR%
  
  echo "テスト用データ作成開始"
  
  sqlcmd /E /S %SERVER_DB_NAME% /b /i %SQL_FILE% /v Param1="before%%A"^
         /o %LOG_FILE%
         
  echo "以下のDBのスクリーンショットを取得した後に、Enterキーを押下"
  echo "この後、バッチが実行されます"
  echo "[TRN_990_JOBSTATUS][一回目のみ][MST_990_RELATION_JOB]"
  type %LOG_FILE%
  PAUSE
  
  rem プログラムを実行する
  cd C:\ProgramData\APLWORK\基盤\RDAステータス管理\BAT
  clear
  call RegProcStatus.bat
  rem echo "BAT実行結果を取得した後に、Enterキーを押下"
  PAUSE
  
)

cd %CURRENT_DIR%

rem ログを出力
If not Exist UTソース\log\No.%TEST_INDEX% mkdir UTソース\log\No.%TEST_INDEX%
cp "%EXE_LOG_PATH%%EXE_LOG_FILE%" UTソース\log\No.%TEST_INDEX%\

sqlcmd /E /S %SERVER_DB_NAME% /b /i %SQL_FILE% /v Param1="testFinish"^
       /o %LOG_FILE%
       
type %LOG_FILE%

echo "エビデンスを作成"

rem 実行結果を確認
IF NOT %ERRORLEVEL% == 0 (
  GOTO ERROR
) ELSE (
  GOTO NORMAL
)

:ERROR
echo %date% %time%  %END_NG_MSG%
EXIT

:NORMAL
echo %date% %time%  %END_OK_MSG%
