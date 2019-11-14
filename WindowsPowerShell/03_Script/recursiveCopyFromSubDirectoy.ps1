# 2018/12/19
# csvファイルからコピーファイル名を取得し、コピー元のルートパスのサブディレクトリを検索して、
# ファイルが存在すればそのファイルをコピー先のフォルダにコピーする。
#
# 実行方法：
#           ①コピー元ファイル名があるCSVファイルを準備する。（ヘッダはスキップする）
#           ②スクリプトの設定部分にてCSVファイルのパス、コピー元フォルダ、コピー先フォルダのパス情報を設定する。
#

#テスト用コード
# Write-Output ("debug00:DebugStart")


# -----設定部分-----
$CONFIG_CSV_PATH = "C:\Users\user1\01_Work\15_サブディレクトリコピースクリプト\00_ImportCSV"
$CONFIG_IMAGESOURCE_PATH = "C:\Users\user1\01_Work\15_サブディレクトリコピースクリプト\01_SourceImage"
$CONFIG_IMAGDEST_PATH = "C:\Users\user1\01_Work\15_サブディレクトリコピースクリプト\02_DestImage"
$CONFIG_CURRENT_PATH = $PSScriptRoot

# コピー総数のカウンター
$Script:CntAll = 0

# コピー完了数のカウンター
$Script:CntCopied = 0

# CSVファイル一覧を取得する。
$CsvFiles = Get-ChildItem -Path $CONFIG_CSV_PATH  -Recurse  -Filter *.csv | Select-Object -ExpandProperty FullName

# ルートディレクトリ直下の全サブディレクトリにて
# ソース画像ファイルの一覧を取得する。条件：属性がファイルで拡張子はjpg
$ImageSourceFiles = Get-ChildItem -Path $CONFIG_IMAGESOURCE_PATH -Recurse `
                    | Where-Object {$_.Attributes -eq "Archive"} `
                    | Where-Object {$_.Extension -eq ".JPG"} `
                    # | Select-Object -ExpandProperty FullName

# Write-Output ($ImageSourceFiles)

# # テスト：ファイル一覧表示
# foreach ($ImageSourceFile in $ImageSourceFiles)
# {
#     # 一列目の値を取得する
#     $Value = $ImageSourceFile
#     Write-Output ($Value)
# }


# コピー完了数のカウンター
$CntCopied = 0

# -----処理部分-----
# フォルダ再構築処理本体関数
function recursiveCopyFile($csvFileFullName)
{

    try{

        # テスト用
        # Write-Output ("csvFileFullName: " + $csvFileFullName)

        # 0.一行のデータを取得する
        $CsvDataArray = Import-Csv $csvFileFullName -Encoding Default | Select-Object "画像ファイル名"

        # CSVファイルを一行ずつ処理する
        foreach ($CsvData in $CsvDataArray)
        {

            # 一列目の値を取得する
            # Write-Output ("ImagePathInfo: " + $CsvData."画像ファイル名")
            $CsvInfoImgFileName = $CsvData."画像ファイル名"
            # Write-Output ($CsvInfoImgFileName)

            # コピー元ファイル一覧からコピー対象ファイルが存在するか確認する。
            foreach ($ImageSourceFile in $ImageSourceFiles)
            {

                # コピー元ファイルからファイル名のみ、取得する。
                $ImageFileNameOnly = $ImageSourceFile | Select-Object -ExpandProperty Name
                # Write-Output ("@@@--:" + $ImageFileNameOnly)

                # コピー元ファイル一覧からコピー対象ファイルが存在するか確認する。
                if($ImageFileNameOnly -eq $CsvInfoImgFileName){
                    # 改めてコピー元ファイルのフルパスを取得する。
                    $ImageFileNameFullPath = $ImageSourceFile | Select-Object -ExpandProperty FullName
                    $DestFullPath = $CONFIG_IMAGDEST_PATH 
                    Write-Output ("Info: 一致ファイル[" + $CsvInfoImgFileName + "]をコピー先フォルダへコピーしました。")
                    Copy-Item $ImageFileNameFullPath  $DestFullPath -force
                    $Script:CntCopied += 1
                }
            }

            $Script:CntAll += 1

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

    Write-Output "-----ファイルの再帰コピーを開始しています-----"

    Write-Output ("実行パス:" + $CONFIG_CURRENT_PATH)
    Write-Output ("CSVファイルディレクトリ：" + $CONFIG_CSV_PATH)
    Write-Output ("コピー元ルートディレクトリ：" + $CONFIG_IMAGESOURCE_PATH)
    Write-Output ("コピー先ルートディレクトリ：" + $CONFIG_IMAGDEST_PATH)
    Write-Output "----------------------------------------------"
    # 開始時刻を保存
    [DateTime]$dateTime = (Get-Date)

    # 実行
    foreach($fileObj in $CsvFiles)
    {
        # $fileObj
        recursiveCopyFile $fileObj 
    }


    Write-Output "----------------------------------------------"
    Write-Output (" 読み込みファイル数：" + $CntAll)
    Write-Output (" コピーファイル数：" + $CntCopied)
    Write-Output (" 経過時間(分)：" + (New-TimeSpan $dateTime (Get-Date)).TotalMinutes)
    Write-Output "-----ファイルの再帰コピーが終了しました(Enterキーで終了します)-----"
}


# 処理を実行する
main
