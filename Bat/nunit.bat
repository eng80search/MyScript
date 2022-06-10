echo off
rem nunit単体テストを動かすバッチ
rem 注意：本ファイルのEncoding=Sjis

rem Vimでカレントディレクトリを挿入する方法　:r!pwd
rem Vimで自分のファイル名を貼り付ける方法 "%p

rem --------------環境設定------------------
set DIR_CURRENT=%~dp0
set DIR_UNIT_OUTPUT="%DIR_CURRENT%nunitResult"

set EXE_UNIT_TEST="C:\\Program Files\\NUnit-2.7.1\\bin\\nunit-console.exe"

set TEST_MODULE_PATH="C:\\ProgramData\\APLWORK\\基盤\\RDAステータス管理\\RegProcStatus\\UT_RegProcStatus\\bin\\"
set TEST_MODULE_NAME=UT_RegProcStatus.exe
set TEST_CASE_ROOT=UT_RegProcStatus

set TEST_CASE_CLASS=TEST_Jp1Inf

rem ----------------------------------------

cls
echo *********** %date% %time% Nunitテストを開始 *************
echo.
echo   実行結果出力フォルダ： %DIR_UNIT_OUTPUT%
echo   テストモジュール：     %TEST_MODULE_PATH%
echo.

rem nunitテストを実施する
cd %DIR_UNIT_OUTPUT%
type nul > StdOut.txt
%EXE_UNIT_TEST% %TEST_MODULE_PATH%%TEST_MODULE_NAME% /nologo /out:StdOut.txt /run:%TEST_CASE_ROOT%.%TEST_CASE_CLASS% > result.txt

rem デバッグ情報をコンソール出力情報の後ろに追記する
echo ------------Text Output(start)--------------- >> result.txt
echo. >> result.txt
type StdOut.txt >> result.txt
echo. >> result.txt
echo ------------Text Output(end)----------------- >> result.txt
type result.txt

rem カレントディレクトリをバッチ実行パスに変更する
cd %DIR_CURRENT%

echo.
echo *********** %date% %time% Nunitテストが終了 *************
