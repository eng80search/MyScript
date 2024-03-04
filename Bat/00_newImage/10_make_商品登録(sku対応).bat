@echo off
rem chcp 932


REM MySQLSQLのbinディレクトリ
set MARIADBPATH=C:\Program Files\MariaDB 10.5\bin\
rem sqlファイルのselect into outfileの出力先
set MARIADB_EXPORT_PATH=C:\temp\
set BACKUP_PATH=.\88_履歴\

rem ファイル関連
set DIR_SKU_KANRI=.\_import_data\
set FILE_SKU_PRODUCT=%DIR_SKU_KANRI%10_product.csv
set FILE_SKU_COLOR=%DIR_SKU_KANRI%11_color.csv
set FILE_SKU_SIZE=%DIR_SKU_KANRI%12_size.csv
set FILE_VARIATION=%MARIADB_EXPORT_PATH%20_variation.csv
set FILE_SKU_KANRI=%MARIADB_EXPORT_PATH%21_sku_kanri.csv

set FILE_OUT_CSV=normal-item.csv

set START_MSG= ============= 商品登録(SKU対応)処理を開始しました =============
set MOVE_CSV_MSG_OK=********** %FILE_OUT_CSV%を%BACKUP_PATH%へ移動しました *********
set MOVE_CSV_MSG_ERROR=********** %FILE_OUT_CSV%を%BACKUP_PATH%へ移動できません *********
set DB_MAKE_START_MSG=********** 20_variation.csv及び21_sku_kanri.csvファイルの作成を開始しました *********
set DB_MAKE_END_MSG=********** 20_variation.csv及び21_sku_kanri.csvファイルの作成を完了しました *********
set DB_MAKE_ERROR_MSG=********** 20_variation.csv及び21_sku_kanri.csvファイルの作成が失敗しました *********
set END_OK_MSG= ============= 商品登録(SKU対応)処理が正常終了しました =============
set END_NG_MSG= ============= エラー発生！商品登録(SKU対応)処理が異常終了しました =============


set FILE_SQL_SKU_NO=.\_sql\01_商品登録(sku対応)用.sql
set NOT_FILE_SKU_PRODUCT=********** 警告：%FILE_SKU_PRODUCT%がありません ********** 
set NOT_FILE_SKU_COLOR=********** 警告：%FILE_SKU_PRODUCT%がありません ********** 
set NOT_FILE_SKU_SIZE=********** 警告：%FILE_SKU_PRODUCT%がありません ********** 
set DEL_FILE_VARIATION=********** 既存の%FILE_VARIATION%を削除しました  **********
set DEL_FILE_SKU_KNARI=********** 既存の%FILE_SKU_KANRI%を削除しました  **********

REM 接続先情報
set HOST=127.0.0.1
set DB_NAME=new_image
set USER_ID=root
set OPTION=--default-character-set=sjis

echo %date% %time% 
echo %START_MSG% 
rem 改行
echo;

set time0n=%time: =0%
set YYYYMMDD_HHMMSS=%date:~0,4%%date:~5,2%%date:~8,2%_%time0n:~0,2%%time0n:~3,2%%time0n:~6,2%
rem echo %YYYYMMDD_HHMMSS%
set FILE_OUT_CSV_BACKUP=%BACKUP_PATH%%YYYYMMDD_HHMMSS%_%FILE_OUT_CSV%

rem ERRORLEVELをリセット
cd > nul
rem 既存のファイルをバックアップ
if exist "%FILE_OUT_CSV%" (
    move %FILE_OUT_CSV% %FILE_OUT_CSV_BACKUP%
) 

IF NOT %ERRORLEVEL% == 0 (
  echo %MOVE_CSV_MSG_ERROR%  
  GOTO ERROR
) ELSE (
  echo %MOVE_CSV_MSG_OK%
)

rem Excelファイルから入力用CSVファイルを作成する
rem バッチファイルがあるディレクトリをカレントディレクトリに設定
cd /d %~dp0
cd _python
python 01_make_import_csv.py
SET RESULT=%ERRORLEVEL%
cd ..

rem Exel->CSV出力実行結果確認
IF NOT %RESULT% == 0 (
  GOTO ERROR
) 

rem import用CSVファイルの存在チェック
if not exist %FILE_SKU_PRODUCT% (
    echo %NOT_FILE_SKU_PRODUCT%
    GOTO ERROR
)

if not exist %FILE_SKU_COLOR% (
    echo %NOT_FILE_SKU_COLOR%
    GOTO ERROR
)

if not exist %FILE_SKU_SIZE% (
    echo %NOT_FILE_SKU_SIZE%
    GOTO ERROR
)


rem 大事！パスワード指定は必ずこの環境変数でしか設定できない
set MYSQL_PWD=password

if exist %FILE_VARIATION% (
    del %FILE_VARIATION%
    echo %DEL_FILE_VARIATION%
    echo;
) 

if exist %FILE_SKU_KANRI% (
    del %FILE_SKU_KANRI%
    echo %DEL_FILE_SKU_KNARI%
    echo;
) 

echo;
echo %DB_MAKE_START_MSG% 
echo;
REM MariaDBスクリプト実行
"%MARIADBPATH%mariadb" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID%  < %FILE_SQL_SKU_NO%

rem DB実行結果確認
IF NOT %ERRORLEVEL% == 0 (
  GOTO ERROR
) ELSE (
  echo;
  move /Y %MARIADB_EXPORT_PATH%20_variation.csv .\_import_data\
  move /Y %MARIADB_EXPORT_PATH%21_sku_kanri.csv .\_import_data\
  echo %DB_MAKE_END_MSG%
)

rem 商品登録(sku対応)CSVファイルを作成する
echo;
rem バッチファイルがあるディレクトリをカレントディレクトリに設定
cd /d %~dp0
cd _python
python 02_make_out_csv.py
SET RESULT=%ERRORLEVEL%
rem echo %RESULT%
cd ..

rem Exel->CSV出力実行結果確認
IF NOT %RESULT% == 0 (
  GOTO ERROR
) ELSE (
  GOTO NORMAL
)

rem エラー終了
:ERROR
    echo;
    echo %END_NG_MSG%
    echo %date% %time%
    PAUSE
    GOTO FINAL

rem 正常終了
:NORMAL
    echo;
    echo %END_OK_MSG% 
    echo %date% %time%
    cd /d %~dp0
    PAUSE
    start explorer.exe "%FILE_OUT_CSV%"
    exit /b 0

:FINAL
    rem PAUSE
    rem explorer .
