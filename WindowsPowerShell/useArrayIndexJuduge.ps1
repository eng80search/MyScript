# 2019/05/30
# Windows PowerShell�X�N���v�g
# �z���Idex�g��������
#
# �ݒ蕔��

$FLG_COPY = $true
$ary_file1_copy = (2,4,5,9,11)

try{
    for($i = 0; $ -le 10, $i)
    {
        # IndexOf���\�b�h�͌������q�b�g���Ȃ���-1��Ԃ�
        $idx = [Array]::IndexOf($ary_file1_copy, $i)
        if($FLG_COPY -and $idx -gt -1)
        {
            Write-Output("Write somthing...")
        }
    }
} catch {
    Write-Output("Test")
}
