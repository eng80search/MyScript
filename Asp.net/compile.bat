@REM 概要：msbuild.exeを使用してasp.netプロジェクトをコンパイルするバッチファイル
@REM 使用方法：コマンドプロンプトで実行する

@echo ***** CurrentDirectoryをStoresLocatorプロジェクトに設定しています・・・
@cd D:\00_Ri\00_作業\10_gitSvnSource\src\PC\AcuvueStore
@REM 空白行を追加
@echo.
@echo ***** msbuildでStoreLocatorプロジェクトをビルドしています・・・
@echo ***** mode:debug
msbuild  /t:build /p:configuration=debug /p:Plateform="x64" 
@REM msbuild  /t:clean;build /p:configuration=release 
@echo ***** StoreLocatorプロジェクトのビルドが完了しました。
