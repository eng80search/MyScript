@echo off
rem chcp 932


REM MySQLSQL��bin�f�B���N�g��
set MARIADBPATH=C:\Program Files\MariaDB 10.5\bin\
rem sql�t�@�C����select into outfile�̏o�͐�
set MARIADB_EXPORT_PATH=C:\temp\
set BACKUP_PATH=.\88_����\

rem �t�@�C���֘A
set DIR_SKU_KANRI=.\_import_data\
set FILE_SKU_PRODUCT=%DIR_SKU_KANRI%10_product.csv
set FILE_SKU_COLOR=%DIR_SKU_KANRI%11_color.csv
set FILE_SKU_SIZE=%DIR_SKU_KANRI%12_size.csv
set FILE_VARIATION=%MARIADB_EXPORT_PATH%20_variation.csv
set FILE_SKU_KANRI=%MARIADB_EXPORT_PATH%21_sku_kanri.csv

set FILE_OUT_CSV=normal-item.csv

set START_MSG= ============= ���i�o�^(SKU�Ή�)�������J�n���܂��� =============
set MOVE_CSV_MSG_OK=********** %FILE_OUT_CSV%��%BACKUP_PATH%�ֈړ����܂��� *********
set MOVE_CSV_MSG_ERROR=********** %FILE_OUT_CSV%��%BACKUP_PATH%�ֈړ��ł��܂��� *********
set DB_MAKE_START_MSG=********** 20_variation.csv�y��21_sku_kanri.csv�t�@�C���̍쐬���J�n���܂��� *********
set DB_MAKE_END_MSG=********** 20_variation.csv�y��21_sku_kanri.csv�t�@�C���̍쐬���������܂��� *********
set DB_MAKE_ERROR_MSG=********** 20_variation.csv�y��21_sku_kanri.csv�t�@�C���̍쐬�����s���܂��� *********
set END_OK_MSG= ============= ���i�o�^(SKU�Ή�)����������I�����܂��� =============
set END_NG_MSG= ============= �G���[�����I���i�o�^(SKU�Ή�)�������ُ�I�����܂��� =============


set FILE_SQL_SKU_NO=.\_sql\01_���i�o�^(sku�Ή�)�p.sql
set NOT_FILE_SKU_PRODUCT=********** �x���F%FILE_SKU_PRODUCT%������܂��� ********** 
set NOT_FILE_SKU_COLOR=********** �x���F%FILE_SKU_PRODUCT%������܂��� ********** 
set NOT_FILE_SKU_SIZE=********** �x���F%FILE_SKU_PRODUCT%������܂��� ********** 
set DEL_FILE_VARIATION=********** ������%FILE_VARIATION%���폜���܂���  **********
set DEL_FILE_SKU_KNARI=********** ������%FILE_SKU_KANRI%���폜���܂���  **********

REM �ڑ�����
set HOST=127.0.0.1
set DB_NAME=new_image
set USER_ID=root
set OPTION=--default-character-set=sjis

echo %date% %time% 
echo %START_MSG% 
rem ���s
echo;

set time0n=%time: =0%
set YYYYMMDD_HHMMSS=%date:~0,4%%date:~5,2%%date:~8,2%_%time0n:~0,2%%time0n:~3,2%%time0n:~6,2%
rem echo %YYYYMMDD_HHMMSS%
set FILE_OUT_CSV_BACKUP=%BACKUP_PATH%%YYYYMMDD_HHMMSS%_%FILE_OUT_CSV%

rem ERRORLEVEL�����Z�b�g
cd > nul
rem �����̃t�@�C�����o�b�N�A�b�v
if exist "%FILE_OUT_CSV%" (
    move %FILE_OUT_CSV% %FILE_OUT_CSV_BACKUP%
) 

IF NOT %ERRORLEVEL% == 0 (
  echo %MOVE_CSV_MSG_ERROR%  
  GOTO ERROR
) ELSE (
  echo %MOVE_CSV_MSG_OK%
)

rem Excel�t�@�C��������͗pCSV�t�@�C�����쐬����
rem �o�b�`�t�@�C��������f�B���N�g�����J�����g�f�B���N�g���ɐݒ�
cd /d %~dp0
cd _python
python 01_make_import_csv.py
SET RESULT=%ERRORLEVEL%
cd ..

rem Exel->CSV�o�͎��s���ʊm�F
IF NOT %RESULT% == 0 (
  GOTO ERROR
) 

rem import�pCSV�t�@�C���̑��݃`�F�b�N
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


rem �厖�I�p�X���[�h�w��͕K�����̊��ϐ��ł����ݒ�ł��Ȃ�
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
REM MariaDB�X�N���v�g���s
"%MARIADBPATH%mariadb" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID%  < %FILE_SQL_SKU_NO%

rem DB���s���ʊm�F
IF NOT %ERRORLEVEL% == 0 (
  GOTO ERROR
) ELSE (
  echo;
  move /Y %MARIADB_EXPORT_PATH%20_variation.csv .\_import_data\
  move /Y %MARIADB_EXPORT_PATH%21_sku_kanri.csv .\_import_data\
  echo %DB_MAKE_END_MSG%
)

rem ���i�o�^(sku�Ή�)CSV�t�@�C�����쐬����
echo;
rem �o�b�`�t�@�C��������f�B���N�g�����J�����g�f�B���N�g���ɐݒ�
cd /d %~dp0
cd _python
python 02_make_out_csv.py
SET RESULT=%ERRORLEVEL%
rem echo %RESULT%
cd ..

rem Exel->CSV�o�͎��s���ʊm�F
IF NOT %RESULT% == 0 (
  GOTO ERROR
) ELSE (
  GOTO NORMAL
)

rem �G���[�I��
:ERROR
    echo;
    echo %END_NG_MSG%
    echo %date% %time%
    PAUSE
    GOTO FINAL

rem ����I��
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
