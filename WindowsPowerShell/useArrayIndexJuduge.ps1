# 2019/05/30
# Windows PowerShellスクリプト
# 配列のIdex使い方メモ
#
# 設定部分

$FLG_COPY = $true
$ary_file1_copy = (2,4,5,9,11)

try{
    for($i = 0; $ -le 10, $i)
    {
        # IndexOfメソッドは検索がヒットしないと-1を返す
        $idx = [Array]::IndexOf($ary_file1_copy, $i)
        if($FLG_COPY -and $idx -gt -1)
        {
            Write-Output("Write somthing...")
        }
    }
} catch {
    Write-Output("Test")
}
