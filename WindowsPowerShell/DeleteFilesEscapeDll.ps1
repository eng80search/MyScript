# 2019/11/11 あるフォルダの直下のすべてのサブフォルダにおいて、Dll以外のファイルをすべて削除する
# 実行方法：
#           ①本スクリプトの直下にCSVサブフォルダを置く
#

#テスト用コード
# Write-Output ("debug00:DebugStart")

# -----設定部分-----
$CONFIG_ROOT_PATH = "C:\Users\setupuser\Documents\00_Ri\00_作業\31_Dll整理\20191105_QA_store"
$CONFIG_DEST_PATH = "C:\Users\setupuser\Documents\00_Ri\00_作業\31_Dll整理\QA_store_Dll"
$CONFIG_CURRENT_PATH = $PSScriptRoot
# 出力CSVファイル名
$CONFIG_OUT_FILE = "C:\Users\setupuser\Documents\00_Ri\00_作業\31_Dll整理\QA.csv"
$CONFIG_OUT_HEADER ="No,FilePath,FileVersion`r`n"
$CONFIG_OUT_DATA = $CONFIG_OUT_HEADER

# 現在の実行ファイルの直下のサブディレクトリを取得して、再構築処理を実行
# $AllFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH  -Recurse  | Select-Object -ExpandProperty FullName
$AllFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH  | Select-Object -ExpandProperty FullName 

# # コピー元元ルートフォルダからイメージファイルを取得する。
# $ImageFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH -Recurse  -Filter *.jpg | Select-Object -ExpandProperty FullName


# コピー元完了数のカウンター
# $script:CntCopy = 0
$CntCopy = 0

# -----処理部分-----
# フォルダ再構築処理本体関数
function doSomething($SourceFileNameFullPath)
{

    try{

            # Write-Output ("SourceFileNameFullPath: " + $SourceFileNameFullPath)
            # CSV

            # rootファルダに対して、再帰処理を行う
            # $FileExtention = Get-ChildItem $SourceFileNameFullPath Get-ChildItem | Foreach-Object {
            Get-ChildItem -Path $SourceFileNameFullPath -Recurse | Foreach-Object {
                # フォルダの場合
                if ($_.PSIsContainer) {
                    # Write-Output ("Skip Folder:" + $_.FullName)
                }
                else {
                    # Write-Output ("All File:" + $_.FullName)
                    if($_.Extension.ToLower() -eq ".dll"){
                        $script:CntCopy += 1
                        Write-Output (" [Info:" + $_.FullName + "] <version:" + $_.VersionInfo.FileVersion + ">")
                        # 一行のCSVデータを作成
                        $script:CONFIG_OUT_DATA += ([string]$CntCopy + "," + $_.FullName + "," + $_.VersionInfo.FileVersion + "`r`n")
                    }
                }
            }

    }catch{

            # 5.異常終了
            Write-Output $error[0]
            $errorMsg = (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + (" データ: ") + $CsvData + " error:  " + $error[0]
            $errorMsg | Out-File -Append "error.log"
            return 1
        }

}

# メイン処理関数
function main
{

    Write-Output "-----Dllファイルバージョン情報出力を開始しています-----"

    Write-Output ("実行パス:" + $CONFIG_CURRENT_PATH)
    Write-Output ("Dllファイルルートパス：" + $CONFIG_ROOT_PATH)
    # Write-Output ("コピー元先ルートディレクトリ：" + $CONFIG_DEST_PATH)
    Write-Output "----------------------------------------------"
    # 開始時刻を保存
    [DateTime]$dateTime = (Get-Date)

    # 実行
    foreach($fileObj in $AllFiles)
    {
        # $fileObj
        doSomething $fileObj 
    }

    # 結果をCSVファイルに出力
    $CONFIG_OUT_DATA | Out-File $CONFIG_OUT_FILE -Force -Encoding Default

    Write-Output "----------------------------------------------"
    Write-Output (" コピー元ファイル数：" + $CntCopy)
    Write-Output (" 経過時間(分)：" + (New-TimeSpan $dateTime (Get-Date)).TotalMinutes)
    Write-Output "-----Dllファイルバージョン情報出力が終了しました(Enterキーで終了します)-----"
}


# 処理を実行する
main
