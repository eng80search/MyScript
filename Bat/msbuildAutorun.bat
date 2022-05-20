@rem コマンドプロンプトからmsbuildを実行して、ソリューションをビルドする
@rem 注意：本ファイルのEncoding=SJIS; msbuildはパスを通しておく

@rem Vimでカレントディレクトリを挿入する方法： :r!pwd

@echo ********** プロジェクトのビルドを開始しました ***************
@echo 開始時刻　%date% %time%

rem テスト用モジュールをビルドする
@echo ---------- テスト用モジュールをビルドする ------------------
@cd C:\Users\T21A824\00_work\01_Source\09_RDSステータス管理対応\RDA_TEST_Stub
msbuild /t:build /p:configuration=debug /p:Plateform="x64"

rem RDAステータス管理Exeモジュールをビルドする
@echo ---------- RDAステータス管理Exeモジュールをビルドする ------
@cd C:\ProgramData\APLWORK\基盤\RDAステータス管理\RegProcStatus
msbuild /t:build /p:configuration=debug /p:Plateform="x64"

rem RDAステータス管理バッチを呼び出す
@echo ---------- RDAステータス管理バッチを呼び出す --------------
@cd C:\ProgramData\APLWORK\基盤\RDAステータス管理\BAT
call RegProcStatus.bat

@echo 終了時刻　%date% %time%
@echo ********** プロジェクトのビルドが完了しました *************
