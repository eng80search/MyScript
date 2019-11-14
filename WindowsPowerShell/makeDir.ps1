# 2019/04/22
# Windows PowerShellスクリプト
# コピー先のフォルダが作成されていない場合のみ、コピー元フォルダからコピーを行う。
#
# 設定部分

# $CONFIG_CURRENT_PATH = $PSScriptRoot
$CONFIG_CURRENT_PATH = "C:\Users\user1\Documents\00_Ri\03_作業\02_アプリ提出分明細一括登録機能\00_testData"
$CONFIG_END = 44
$CONFIG_START_INDEX = 2

$CONFIG_FILE1_NAME = "20190405_No"
$CONFIG_FILE2_NAME = "20190405_No"
$CONFIG_KAKUTEI_NAME = "20190405_operationDate.txt"

# コピー元ファイル
$CONFIG_SOURCE_FILE1_FULLPATH = $CONFIG_CURRENT_PATH + "\0\1\20190405_No0_1.csv"
$CONFIG_SOURCE_FILE2_FULLPATH = $CONFIG_CURRENT_PATH + "\0\2\20190405_No0_2.csv"
$CONFIG_SOURCE_KAKUTEI_FULLPATH = $CONFIG_CURRENT_PATH + "\0\" + $CONFIG_KAKUTEI_NAME

try{

        # le:以下 lt:より小さい
        for($i = $CONFIG_START_INDEX; $i -le $CONFIG_END; $i++)
        {
            # ディレクトリを作成
            $dirName = $CONFIG_CURRENT_PATH
            $dirName += "\" + $i
            if(-not(Test-Path $dirName)){
                New-Item -ItemType Directory  -Path $dirName
                Write-Output("ディレクトリ作成完了:" + $dirName)

                #フォルダ１を作成
                $destDirName1 = $dirName + "\1"
                New-Item -ItemType Directory  -Path $destDirName1
                # File1の名前を設定する。
                $destFile1Name = $CONFIG_FILE1_NAME + $i + "_1.csv"
                $destFile1FullPath = $destDirName1 + "\" + $destFile1Name

                # File1コピー
                Write-Output ("Info: ファイル1[" + $destFile1Name + "]をコピー先フォルダへコピーしました。")
                Copy-Item  $CONFIG_SOURCE_FILE1_FULLPATH  $destFile1FullPath -force


                #フォルダ１を作成
                $destDirName2 = $dirName + "\2"
                New-Item -ItemType Directory  -Path $destDirName2
                # File2の名前を設定する。
                $destFile2Name = $CONFIG_FILE2_NAME + $i + "_2.csv"
                $destFile2FullPath = $destDirName2 + "\" + $destFile2Name

                # File2コピー
                Write-Output ("Info: ファイル2[" + $destFile2Name + "]をコピー先フォルダへコピーしました。")
                Copy-Item  $CONFIG_SOURCE_FILE2_FULLPATH  $destFile2FullPath -force

                # 確定ファイルをコピー
                $destKakuteiName = $CONFIG_KAKUTEI_NAME
                $destKakuteiFullPath = $dirName + "\" + $destKakuteiName
                Write-Output ("Info: 確定ファイル[" + $destKakuteiName + "]をコピー先フォルダへコピーしました。")
                Copy-Item  $CONFIG_SOURCE_KAKUTEI_FULLPATH  $destKakuteiFullPath -force

            }

        }

        Write-Output("作成処理が完了しました。")
} catch {

        Write-Output("ディレクトリ作成エラー!:" + $dirName)
}
