# ファイル一覧を取得するスクリプト
Get-ChildItem -Recurse * | Select-Object FullName|Export-Csv -encoding default  filelist.csv
