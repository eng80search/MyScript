# 2018/08/09 ファイルを開始日から終了日まで複数コピーする

# -----設定部分-----
$CONFIG_IMAGEROOT_PATH    = "C:\Users\user1\01_Work\13_RebuildDirecotry\00_Test\01_SourceImage"
$CONFIG_SOURCE_IMAGE_PATH = Join-Path $PSScriptRoot "00.jpg"
$CONFIG_CURRENT_PATH      = $PSScriptRoot
# テスト用イメージフォルダ作成する際にバッチ番号毎に作成するかどうかのフラグ 1: 作成する 0: 作成しない
$CONFIG_FLG_HAS_BAT_SUBDIR  = 0 

Write-Output ("debug01:" + $CONFIG_CURRENT_PATH)

# 現在の実行ファイルの直下のサブディレクトリを取得して、再構築処理を実行
$CsvFiles = Get-ChildItem -Path $CONFIG_CURRENT_PATH  -Recurse  -Filter *.csv | Select-Object -ExpandProperty FullName 

# -----処理部分-----
# フォルダ再構築処理本体関数
function remakingDirectory($csvFileFullName)
{

    try{
        Write-Output ("csvFileFullName: " + $csvFileFullName)

        # 0.一行のデータを取得する
        $CsvDataArray = Import-Csv $csvFileFullName -Encoding Default | Select-Object "バッチ番号","スキャナ読取日","イメージファイル名"


        # CSVファイルを一行ずつ処理する
        foreach ($CsvData in $CsvDataArray)
        {

            Write-Output ("CsvData: " + $CsvData)

            # 処理：001から始まるフォルダ名を取得する(バッチ番号がこれに該当)
            $ImagePathSub01 = $CsvData."スキャナ読取日"
            $ImagePathSub02 = $CsvData."バッチ番号"

            # 処理：コピー先イメージファイルを取得する
            $ImageFileName = $CsvData."イメージファイル名"

            # 処理④：ファイルがあるか判断する。なければこのまま終了する。
            $ImageFileNameFullPath = $CONFIG_IMAGEROOT_PATH
            $ImageFileNameFullPath += "\" + $ImagePathSub01
            # 処理：バッチ番号毎のサブフォルダを作成するかしない
            if($CONFIG_FLG_HAS_BAT_SUBDIR){

                $ImageFileNameFullPath += "\" + $ImagePathSub02 
            }

            Write-Output ("ImageFileNameFullPath:" + $ImageFileNameFullPath)
            if(-not(Test-Path $ImageFileNameFullPath)){
                New-Item -ItemType Directory  -Path $ImageFileNameFullPath
            }

            $ImageFileNameFullPath += "\" + $ImageFileName


            $sourceFileFullPath = $CONFIG_SOURCE_IMAGE_PATH 

            # 3.移動元から移動先へファイルを移動する。
            Copy-Item $sourceFileFullPath $ImageFileNameFullPath

            # 4.正常終了

        }

    }catch{

            # 5.異常終了
            Write-Output $error[0]
            # $errorMsg = (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + (" CSVデータ: ") + $CsvData + " error:  " + $error[0]
            # $errorMsg | Out-File -Append "error.log"
            return 1
        }

}

# メイン処理関数
function main
{

    Write-Output "-----フォルダ構成の再構築を開始しています-----"
    $hasError = 0

    # 実行
    foreach($fileObj in $CsvFiles)
    {
        # $fileObj
        remakingDirectory $fileObj 
    }

    Write-Output "-----フォルダ構成の再構築が終了しました-----"
}


# 処理を実行する
main
