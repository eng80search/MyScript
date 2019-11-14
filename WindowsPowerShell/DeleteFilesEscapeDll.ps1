# 2019/11/11 あるフォルダの直下のすべてのサブフォルダにおいて、Dll以外のファイルをすべて削除する
# 実行方法：
#           ①本スクリプトの直下にCSVサブフォルダを置く
#

#テスト用コード
# Write-Output ("debug00:DebugStart")


# -----設定部分-----
$CONFIG_ROOT_PATH = "C:\Users\user1\01_Work\13_RebuildDirecotry\00_Test\01_SourceImage"
$CONFIG_IMAGDEST_PATH = "C:\Users\user1\01_Work\13_RebuildDirecotry\00_Test\02_MovedImage"
$CONFIG_CURRENT_PATH = $PSScriptRoot

# 取込元のイメージフォルダの構成がYYYYMMDDの場合は0 YYYYMMDD\バッチ番号の場合1を設定する
$CONFIG_FLG_HAS_BAT_SUBDIR  = 0 


# 現在の実行ファイルの直下のサブディレクトリを取得して、再構築処理を実行
$AllFiles = Get-ChildItem -Path $CONFIG_CURRENT_PATH  -Recurse  | Select-Object -ExpandProperty FullName 

# # 移動元ルートフォルダからイメージファイルを取得する。
# $ImageFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH -Recurse  -Filter *.jpg | Select-Object -ExpandProperty FullName


# 移動完了数のカウンター
# $script:CntMoved = 0
$CntMoved = 0

# -----処理部分-----
# フォルダ再構築処理本体関数
function remakingDirectory($csvFileFullName)
{

    try{

        # Write-Output ("csvFileFullName: " + $csvFileFullName)

        # 0.一行のデータを取得する
        $CsvDataArray = Import-Csv $csvFileFullName -Encoding Default | Select-Object "スキャナ読取日","バッチ番号","委託者コード","イメージファイル名"


        # CSVファイルを一行ずつ処理する
        foreach ($CsvData in $CsvDataArray)
        {


            # Write-Output ("CsvData: " + $CsvData)

            # 1.移動元イメージフォルダを取得する。
            # 処理①：YYYYMMDDサブフォルダ名を取得する。(スキャナ読取り日がこれに該当)
            $ImagePathSub01 = $CsvData."スキャナ読取日"
            # Write-Output ("ImagePathSub01:" + $ImagePathSub01)

            # 処理②：001から始まるフォルダ名を取得する(バッチ番号がこれに該当)
            $ImagePathSub02 = $CsvData."バッチ番号"

            # 処理③：イメージファイルを取得する
            $ImageFileName = $CsvData."イメージファイル名"

            # 処理④：ファイルがあるか判断する。なければこのまま終了する。
            $ImageFileNameFullPath = $CONFIG_ROOT_PATH
            $ImageFileNameFullPath += "\" + $ImagePathSub01
            # 判断：取込元のフォルダ構成にバッチ毎にサブフォルダが作成されているかどうか
            if($CONFIG_FLG_HAS_BAT_SUBDIR){
                $ImageFileNameFullPath += "\" + $ImagePathSub02 
            }
            $ImageFileNameFullPath += "\" + $ImageFileName

            # Write-Output ("ImageFileNameFullPath:" + $ImageFileNameFullPath)
            # 存在しない場合は、終了する
            if(-not(Test-Path $ImageFileNameFullPath)){
                continue
            }

            # Write-Output ("debug03:" + $ImageFileNameFullPath)

            # 2.フォルダ再構築環境を作成する

            # 処理①：委託者コードを取得する
            $ConsignorCode = $CsvData."委託者コード"

            # Write-Output ("委託者コード:" + $ConsignorCode)

            # 処理②：イメージファイル名からYYYYMM形式の年月を取得する委託者コード
            $YearMonth = $ImagePathSub01.Substring(0,4)

            # 処理③：処理①と処理③からの取得情報からフォルダを作成する。
            #         作成済であれば、作成はしない
            $DestFullPath = $CONFIG_IMAGDEST_PATH 
            $DestFullPath += "\" + $YearMonth 
            $DestFullPath += "\" + $ConsignorCode

            # 存在しない場合は、作成する
            if(-not(Test-Path $DestFullPath)){
                New-Item -ItemType Directory  -Path $DestFullPath
                # Write-Output ("DestFullPath:" + $DestFullPath)
            }

            # 3.移動元から移動先へファイルを移動する。
            Move-Item $ImageFileNameFullPath  $DestFullPath -force
            $script:CntMoved += 1
            Write-Output ("移動完了:" + $ImageFileNameFullPath + " カウント数：" + $CntMoved)
            # 4.正常終了

        }

    }catch{

            # 5.異常終了
            Write-Output $error[0]
            $errorMsg = (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + (" CSVデータ: ") + $CsvData + " error:  " + $error[0]
            $errorMsg | Out-File -Append "error.log"
            return 1
        }

}

# メイン処理関数
function main
{

    Write-Output "-----フォルダ構成の再構築を開始しています-----"

    Write-Output ("実行パス:" + $CONFIG_CURRENT_PATH)
    Write-Output ("移動元ルートディレクトリ：" + $CONFIG_ROOT_PATH)
    Write-Output ("移動先ルートディレクトリ：" + $CONFIG_IMAGDEST_PATH)
    Write-Output "----------------------------------------------"
    # 開始時刻を保存
    [DateTime]$dateTime = (Get-Date)

    # 実行
    foreach($fileObj in $AllFiles)
    {
        # $fileObj
        remakingDirectory $fileObj 
    }


    Write-Output "----------------------------------------------"
    Write-Output (" 移動ファイル数：" + $CntMoved)
    Write-Output (" 経過時間(分)：" + (New-TimeSpan $dateTime (Get-Date)).TotalMinutes)
    Write-Output "-----フォルダ構成の再構築が終了しました(Enterキーで終了します)-----"
}


# 処理を実行する
main
