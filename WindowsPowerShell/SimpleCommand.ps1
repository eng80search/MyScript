# ファイル一覧を取得してcsvファイルに出力するスクリプト
$CONFIG_LIST_PATH = "C:\Users\setupuser\Documents\00_Ri\00_作業\00_Solace対応_20200210\05_リリース\20200227_Release_WEB03-04\Websites"
Set-Location -Path $CONFIG_LIST_PATH
Get-ChildItem -Recurse * | Select-Object Name, FullName, LastWriteTime | Export-Csv -encoding default  filelist.csv
