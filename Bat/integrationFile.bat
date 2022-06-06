@echo off
rem ＊文字コード設定SJIS*
chcp 932
setlocal enabledelayedexpansion

rem ********************************************************************
rem * 概要：　すべてのサブフォルダ直下で対象となる同じ名前のファイルを探して
rem *         親フォルダに一つのファイルにまとめる
rem * 実行方法：
rem *         CMDでこのバッチを実行する
rem ********************************************************************

set CURRENT_DIR=%~dp0
set TARGET_FILE=delObjec.txt
rem set TARGET_FILE=insObjec.txt
set OUTPUT_FILE=output.log
set TMP_FILE=tmp.log

set TARGET_DIR1=Y:\\13_DBバッチ処理統合\\00_BAT\\DEL_PROC_FUN_DATA\\
set TARGET_DIR2=Y:\\13_DBバッチ処理統合\\00_BAT\\DEL_PROC_FUN_TABLE\\
set TARGET_DIR3=Y:\\13_DBバッチ処理統合\\00_BAT\\DEL_PROC_OR_TABLE\\
set TARGET_DIR4=Y:\\13_DBバッチ処理統合\\00_BAT\\INS_TBLVERSION\\

rem ドライブを変更
Y:

rem ----------------------------------------------------------------
cd %TARGET_DIR1%
echo %date% %time%  TARGET_FILE: %TARGET_FILE%
echo %date% %time%  TARGET_DIR: %TARGET_DIR1%

copy /y nul %TARGET_FILE% > nul
copy /y nul %OUTPUT_FILE% > nul

CALL:INTEGRATION_TARGET_FILE %TARGET_DIR1%
rem ----------------------------------------------------------------

rem ----------------------------------------------------------------
cd %TARGET_DIR2%
echo %date% %time%  TARGET_FILE: %TARGET_FILE%
echo %date% %time%  TARGET_DIR: %TARGET_DIR2%

copy /y nul %TARGET_FILE% > nul
copy /y nul %OUTPUT_FILE% > nul

CALL:INTEGRATION_TARGET_FILE %TARGET_DIR2%
rem ----------------------------------------------------------------

rem ----------------------------------------------------------------
cd %TARGET_DIR3%
echo %date% %time%  TARGET_FILE: %TARGET_FILE%
echo %date% %time%  TARGET_DIR: %TARGET_DIR3%

copy /y nul %TARGET_FILE% > nul
copy /y nul %OUTPUT_FILE% > nul

CALL:INTEGRATION_TARGET_FILE %TARGET_DIR3%
rem ----------------------------------------------------------------

rem ----------------------------------------------------------------
cd %TARGET_DIR4%
SET TARGET_FILE=insObjec.txt

echo %date% %time%  TARGET_FILE: %TARGET_FILE%
echo %date% %time%  TARGET_DIR: %TARGET_DIR4%

copy /y nul %TARGET_FILE% > nul
copy /y nul %OUTPUT_FILE% > nul

CALL:INTEGRATION_TARGET_FILE %TARGET_DIR4%
rem ----------------------------------------------------------------

GOTO END

:INTEGRATION_TARGET_FILE
rem 指定ディレクトリの直下のすべてのサブディレクトリを対象にする
for /r %1 %%f in (*.txt) do (
  echo %%f > %TMP_FILE%
  
  rem ファイルの中に指定文字列があるか確認する
  findstr %TARGET_FILE% %TMP_FILE% > nul
  
  rem 検索OKの場合
  if !ERRORLEVEL!==0 (
    
    echo %%fを追加します
    echo:>> %OUTPUT_FILE%
    rem 指定ファイルの全部の内容を統合先のファイルへ追記する
    type %%f >> %OUTPUT_FILE%
    
   ) else (
     echo %%fは対象外になります
    
   )
   
 )
 
 rem 一時結果ファイルを正式出力ファイルに名前を変更
 del %TMP_FILE%
 mv %OUTPUT_FILE% %TARGET_FILE%
 echo ----------------------------------------
 
 rem 関数の終了
 exit /b
 
 GOTO END
 
 :ERROR
 echo %date% %time% エラーが発生しました
 GOTO END
 
 :END
 echo %date% %time% 処理が完了しました
