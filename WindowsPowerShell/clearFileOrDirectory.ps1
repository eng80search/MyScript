# 2019/04/22
# Windows PowerShellスクリプト
# コピー先のフォルダが作成されていない場合のみ、コピー元フォルダからコピーを行う。
#
# 設定部分

# $CONFIG_CURRENT_PATH = $PSScriptRoot
$CONFIG_CURRENT_PATH = ""

$CONFIG_FILE1_NAME = ""
$CONFIG_FILE2_NAME = ""
$CONFIG_KAKUTEI_NAME = ""


try{

            # ファイル削除１
            $fileName = "D:\Share\AplMeisaiBilkImport\IntermediateFile\01\Importdata_T_D_GAIYO.csv"
            if(Test-Path $fileName){
                #ファイル削除
                Remove-Item  $fileName
                Write-Output ("Info: ファイル1[" + $fileName + "]を削除しました。")
            }

            # ファイル削除２
            $fileName = "D:\Share\AplMeisaiBilkImport\IntermediateFile\02\Importdata_T_D_MEISAI.csv"
            if(Test-Path $fileName){
                #ファイル削除
                Remove-Item  $fileName
                Write-Output ("Info: ファイル1[" + $fileName + "]を削除しました。")
            }

            # ファイル削除３
            $fileName = "D:\Share\AplMeisaiBilkImport\IntermediateFile\03\Importdata_T_W_MEISAI_BULK_IMPORT.csv"
            if(Test-Path $fileName){
                #ファイル削除
                Remove-Item  $fileName
                Write-Output ("Info: ファイル1[" + $fileName + "]を削除しました。")
            }

            # ディレクトリ削除
            $dirName = "D:\Share\DetailFile"
            if(Test-Path $dirName){
                #ファイル削除
                $dirName += "\*"
                Remove-Item $dirName  -Recurse
                Write-Output ("Info: ディレクトリ[" + $dirName + "]以下を削除しました。")
            }

} catch {

        Write-Output("ファイルクリアエラー:" + $dirName)
}
