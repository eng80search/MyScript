# 2019/11/11 ����t�H���_�̒����̂��ׂẴT�u�t�H���_�ɂ����āADll�ȊO�̃t�@�C�������ׂč폜����
# ���s���@�F
#           �@�{�X�N���v�g�̒�����CSV�T�u�t�H���_��u��
#

#�e�X�g�p�R�[�h
# Write-Output ("debug00:DebugStart")

# -----�ݒ蕔��-----
$CONFIG_ROOT_PATH = "C:\Users\setupuser\Documents\00_Ri\00_���\31_Dll����\20191105_QA_store"
$CONFIG_DEST_PATH = "C:\Users\setupuser\Documents\00_Ri\00_���\31_Dll����\QA_store_Dll"
$CONFIG_CURRENT_PATH = $PSScriptRoot
# �o��CSV�t�@�C����
$CONFIG_OUT_FILE = "C:\Users\setupuser\Documents\00_Ri\00_���\31_Dll����\QA.csv"
$CONFIG_OUT_HEADER ="No,FilePath,FileVersion`r`n"
$CONFIG_OUT_DATA = $CONFIG_OUT_HEADER

# ���݂̎��s�t�@�C���̒����̃T�u�f�B���N�g�����擾���āA�č\�z���������s
# $AllFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH  -Recurse  | Select-Object -ExpandProperty FullName
$AllFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH  | Select-Object -ExpandProperty FullName 

# # �R�s�[�������[�g�t�H���_����C���[�W�t�@�C�����擾����B
# $ImageFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH -Recurse  -Filter *.jpg | Select-Object -ExpandProperty FullName


# �R�s�[���������̃J�E���^�[
# $script:CntCopy = 0
$CntCopy = 0

# -----��������-----
# �t�H���_�č\�z�����{�̊֐�
function doSomething($SourceFileNameFullPath)
{

    try{

            # Write-Output ("SourceFileNameFullPath: " + $SourceFileNameFullPath)
            # CSV

            # root�t�@���_�ɑ΂��āA�ċA�������s��
            # $FileExtention = Get-ChildItem $SourceFileNameFullPath Get-ChildItem | Foreach-Object {
            Get-ChildItem -Path $SourceFileNameFullPath -Recurse | Foreach-Object {
                # �t�H���_�̏ꍇ
                if ($_.PSIsContainer) {
                    # Write-Output ("Skip Folder:" + $_.FullName)
                }
                else {
                    # Write-Output ("All File:" + $_.FullName)
                    if($_.Extension.ToLower() -eq ".dll"){
                        $script:CntCopy += 1
                        Write-Output (" [Info:" + $_.FullName + "] <version:" + $_.VersionInfo.FileVersion + ">")
                        # ��s��CSV�f�[�^���쐬
                        $script:CONFIG_OUT_DATA += ([string]$CntCopy + "," + $_.FullName + "," + $_.VersionInfo.FileVersion + "`r`n")
                    }
                }
            }

    }catch{

            # 5.�ُ�I��
            Write-Output $error[0]
            $errorMsg = (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + (" �f�[�^: ") + $CsvData + " error:  " + $error[0]
            $errorMsg | Out-File -Append "error.log"
            return 1
        }

}

# ���C�������֐�
function main
{

    Write-Output "-----Dll�t�@�C���o�[�W�������o�͂��J�n���Ă��܂�-----"

    Write-Output ("���s�p�X:" + $CONFIG_CURRENT_PATH)
    Write-Output ("Dll�t�@�C�����[�g�p�X�F" + $CONFIG_ROOT_PATH)
    # Write-Output ("�R�s�[���惋�[�g�f�B���N�g���F" + $CONFIG_DEST_PATH)
    Write-Output "----------------------------------------------"
    # �J�n������ۑ�
    [DateTime]$dateTime = (Get-Date)

    # ���s
    foreach($fileObj in $AllFiles)
    {
        # $fileObj
        doSomething $fileObj 
    }

    # ���ʂ�CSV�t�@�C���ɏo��
    $CONFIG_OUT_DATA | Out-File $CONFIG_OUT_FILE -Force -Encoding Default

    Write-Output "----------------------------------------------"
    Write-Output (" �R�s�[���t�@�C�����F" + $CntCopy)
    Write-Output (" �o�ߎ���(��)�F" + (New-TimeSpan $dateTime (Get-Date)).TotalMinutes)
    Write-Output "-----Dll�t�@�C���o�[�W�������o�͂��I�����܂���(Enter�L�[�ŏI�����܂�)-----"
}


# ���������s����
main
