# 2018/08/09 ファイルを開始日から終了日まで複数コピーする

$CONFIG_START_DATE  = 20180401
$CONFIG_END_DATE    = 20180430
$CONFIG_FILE_PREFIX = "D_ENTRP_"

$CONFIG_FOLDER_PATH = "C:\Users\user1\01_Work\13_振り分けツール作成\00_Test\00_ImportCSV\201804"
$CONFIG_SOURCE_FILE = "00.csv"

# ファイルをコピーする。
for ($cnt = $CONFIG_START_DATE; $cnt -le $CONFIG_END_DATE; $cnt++)
{
    $NewfileName        = $CONFIG_FILE_PREFIX + $cnt + ".csv"
    $sourceFileFullPath = Join-Path $CONFIG_FOLDER_PATH  $CONFIG_SOURCE_FILE
    $destFileFullPath   = Join-Path $CONFIG_FOLDER_PATH  $NewfileName

    Write-Output $NewfileName
    Copy-Item -Path $sourceFileFullPath -Destination $destFileFullPath
}
