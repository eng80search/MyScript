@echo off
rem *文字コード設定sjis *
chcp 932
setlocal enabledelayedexpansion

rem ************************************************************
rem * バッチ名: readCsvFileToSearch.bat
rem * 処理概要:
rem            CSVファイルの第一項目を検索ワード、第二項目を検索先のファイル名と認識し、
rem            検索ワードが検索先のファイルにあれば、該当する行をファイルに出力する
rem * 実行方法：
rem *          readCsvFileToSearch.bat --xml (省略の場合はIR.csvを検索する)
rem ************************************************************


rem ************************************************************
rem * 環境設定部分
rem ************************************************************
set CONFIG_DIR=%~dp0
set TARGET_DIR=C:\\Users\\pcni0274\\00_work\\20221104_アジアンインデックスUAT確認\\03.シナリオ\\00_修正前\\

set CSV_FILE_XML=import_XMLSearch.csv
set RESULT_FILE_XML=%CONFIG_DIR%result_XMLSearch.txt

set CSV_FILE_IR=import_IRSearch.csv
set RESULT_FILE_IR=%CONFIG_DIR%result_IRSearch.txt

rem ************************************************************
rem * メイン処理 mainがエラーの場合のみ、onerrorが実行される
rem ************************************************************
call :main || call :onerror
exit /b

:main
echo 実施時刻： %DATE% %TIME%

if "%1" == "--xml" (

    echo %RESULT_FILE_XML%
    echo 実施時刻：%DATE% %TIME% > %RESULT_FILE_XML%
    echo.

    cd %CONFIG_DIR%
    echo ========== 設定内容を出力開始 ==========
    echo    CONFIG_DIR: %CONFIG_DIR%
    echo    TARGET_DIR: %TARGET_DIR%
    echo    CSV_FILE_XML: %CSV_FILE_XML%
    echo ========== 設定内容を出力出力 ==========
    rem  改行コード出力
    echo.
    echo.

    echo ---------- XMLファイル検索開始 --------
    for /f "skip=1 tokens=1,2,3* delims=," %%i in (%CSV_FILE_XML%) do (

        echo.
        echo 検索ワード：%%i 検索元ファイル名：%%j

        echo. >> %RESULT_FILE_XML%
        echo 検索ワード：%%i 検索元ファイル名： %%j >> %RESULT_FILE_XML%

        rem ファイルを検索する（行番号あり、大文字小文字区別なし）
        cd %TARGET_DIR%
        find /n /i "%%i" %%k

        rem 検索結果を結果ファイルに書き出す
        find /n /i "%%i" %%k >> %RESULT_FILE_XML%
    )
    echo ---------- XMLファイル検索終了 --------
    echo 正常に終了しました[%ERRORLEVEL%]
    exit /b

) else (

    echo %RESULT_FILE_IR%
    echo 実施時刻： %DATE% %TIME% > %RESULT_FILE_IR%
    echo.

    cd %CONFIG_DIR%
    echo ========== 設定内容を出力開始 ==========
    echo    CONFIG_DIR: %CONFIG_DIR%
    echo    TARGET_DIR: %TARGET_DIR%
    echo    CSV_FILE_IR: %CSV_FILE_IR%
    echo ========== 設定内容を出力出力 ==========
    rem 改行コード出力
    echo.
    echo.

    echo ---------- IRファイル検索開始 --------
    for /f "skip=1 tokens=1,2,3* delims=," %%i in (%CSV_FILE_IR%) do (

        echo.
        echo XML検索ワード：%%i NEXT値：%%j

        echo. >> %RESULT_FILE_IR%
        echo XML検索ワード：%%i NEXT値： %%j 検索元ファイル名：%%k >> %RESULT_FILE_IR%

        rem ファイルを検索する（行番号あり、大文字小文字区別なし）
        cd %TARGET_DIR%
        find /n /i "%%j" %%k

        rem 検索結果を結果ファイルに書き出す
        find /n /i "%%j" %%k >> %RESULT_FILE_XML%
    )
    echo ---------- XMLファイル検索終了 --------
    echo 正常に終了しました[%ERRORLEVEL%]
    exit /b

)


rem ************************************************************
rem エラー処理
rem ************************************************************
:onerror
echo エラーが発生しました[%ERRORLEVEL%]
exit /b
