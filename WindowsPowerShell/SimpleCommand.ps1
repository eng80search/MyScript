# �t�@�C���ꗗ���擾����csv�t�@�C���ɏo�͂���X�N���v�g
$CONFIG_LIST_PATH = "C:\Users\setupuser\Documents\00_Ri\00_���\00_sprint20_�X�܏ڍ׃o�i�[�\��\05_�����[�X\20200615_Release_WEB03-04\Websites"
Set-Location -Path $CONFIG_LIST_PATH
Get-ChildItem -Recurse * | Select-Object Name, FullName, LastWriteTime | Export-Csv -encoding default  filelist.csv
