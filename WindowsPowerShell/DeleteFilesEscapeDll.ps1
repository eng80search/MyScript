# 2019/11/11 ����t�H���_�̒����̂��ׂẴT�u�t�H���_�ɂ����āADll�ȊO�̃t�@�C�������ׂč폜����
# ���s���@�F
#           �@�{�X�N���v�g�̒�����CSV�T�u�t�H���_��u��
#

#�e�X�g�p�R�[�h
# Write-Output ("debug00:DebugStart")


# -----�ݒ蕔��-----
$CONFIG_ROOT_PATH = "C:\Users\user1\01_Work\13_RebuildDirecotry\00_Test\01_SourceImage"
$CONFIG_IMAGDEST_PATH = "C:\Users\user1\01_Work\13_RebuildDirecotry\00_Test\02_MovedImage"
$CONFIG_CURRENT_PATH = $PSScriptRoot

# �捞���̃C���[�W�t�H���_�̍\����YYYYMMDD�̏ꍇ��0 YYYYMMDD\�o�b�`�ԍ��̏ꍇ1��ݒ肷��
$CONFIG_FLG_HAS_BAT_SUBDIR  = 0 


# ���݂̎��s�t�@�C���̒����̃T�u�f�B���N�g�����擾���āA�č\�z���������s
$AllFiles = Get-ChildItem -Path $CONFIG_CURRENT_PATH  -Recurse  | Select-Object -ExpandProperty FullName 

# # �ړ������[�g�t�H���_����C���[�W�t�@�C�����擾����B
# $ImageFiles = Get-ChildItem -Path $CONFIG_ROOT_PATH -Recurse  -Filter *.jpg | Select-Object -ExpandProperty FullName


# �ړ��������̃J�E���^�[
# $script:CntMoved = 0
$CntMoved = 0

# -----��������-----
# �t�H���_�č\�z�����{�̊֐�
function remakingDirectory($csvFileFullName)
{

    try{

        # Write-Output ("csvFileFullName: " + $csvFileFullName)

        # 0.��s�̃f�[�^���擾����
        $CsvDataArray = Import-Csv $csvFileFullName -Encoding Default | Select-Object "�X�L���i�ǎ��","�o�b�`�ԍ�","�ϑ��҃R�[�h","�C���[�W�t�@�C����"


        # CSV�t�@�C������s����������
        foreach ($CsvData in $CsvDataArray)
        {


            # Write-Output ("CsvData: " + $CsvData)

            # 1.�ړ����C���[�W�t�H���_���擾����B
            # �����@�FYYYYMMDD�T�u�t�H���_�����擾����B(�X�L���i�ǎ���������ɊY��)
            $ImagePathSub01 = $CsvData."�X�L���i�ǎ��"
            # Write-Output ("ImagePathSub01:" + $ImagePathSub01)

            # �����A�F001����n�܂�t�H���_�����擾����(�o�b�`�ԍ�������ɊY��)
            $ImagePathSub02 = $CsvData."�o�b�`�ԍ�"

            # �����B�F�C���[�W�t�@�C�����擾����
            $ImageFileName = $CsvData."�C���[�W�t�@�C����"

            # �����C�F�t�@�C�������邩���f����B�Ȃ���΂��̂܂܏I������B
            $ImageFileNameFullPath = $CONFIG_ROOT_PATH
            $ImageFileNameFullPath += "\" + $ImagePathSub01
            # ���f�F�捞���̃t�H���_�\���Ƀo�b�`���ɃT�u�t�H���_���쐬����Ă��邩�ǂ���
            if($CONFIG_FLG_HAS_BAT_SUBDIR){
                $ImageFileNameFullPath += "\" + $ImagePathSub02 
            }
            $ImageFileNameFullPath += "\" + $ImageFileName

            # Write-Output ("ImageFileNameFullPath:" + $ImageFileNameFullPath)
            # ���݂��Ȃ��ꍇ�́A�I������
            if(-not(Test-Path $ImageFileNameFullPath)){
                continue
            }

            # Write-Output ("debug03:" + $ImageFileNameFullPath)

            # 2.�t�H���_�č\�z�����쐬����

            # �����@�F�ϑ��҃R�[�h���擾����
            $ConsignorCode = $CsvData."�ϑ��҃R�[�h"

            # Write-Output ("�ϑ��҃R�[�h:" + $ConsignorCode)

            # �����A�F�C���[�W�t�@�C��������YYYYMM�`���̔N�����擾����ϑ��҃R�[�h
            $YearMonth = $ImagePathSub01.Substring(0,4)

            # �����B�F�����@�Ə����B����̎擾��񂩂�t�H���_���쐬����B
            #         �쐬�ςł���΁A�쐬�͂��Ȃ�
            $DestFullPath = $CONFIG_IMAGDEST_PATH 
            $DestFullPath += "\" + $YearMonth 
            $DestFullPath += "\" + $ConsignorCode

            # ���݂��Ȃ��ꍇ�́A�쐬����
            if(-not(Test-Path $DestFullPath)){
                New-Item -ItemType Directory  -Path $DestFullPath
                # Write-Output ("DestFullPath:" + $DestFullPath)
            }

            # 3.�ړ�������ړ���փt�@�C�����ړ�����B
            Move-Item $ImageFileNameFullPath  $DestFullPath -force
            $script:CntMoved += 1
            Write-Output ("�ړ�����:" + $ImageFileNameFullPath + " �J�E���g���F" + $CntMoved)
            # 4.����I��

        }

    }catch{

            # 5.�ُ�I��
            Write-Output $error[0]
            $errorMsg = (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + (" CSV�f�[�^: ") + $CsvData + " error:  " + $error[0]
            $errorMsg | Out-File -Append "error.log"
            return 1
        }

}

# ���C�������֐�
function main
{

    Write-Output "-----�t�H���_�\���̍č\�z���J�n���Ă��܂�-----"

    Write-Output ("���s�p�X:" + $CONFIG_CURRENT_PATH)
    Write-Output ("�ړ������[�g�f�B���N�g���F" + $CONFIG_ROOT_PATH)
    Write-Output ("�ړ��惋�[�g�f�B���N�g���F" + $CONFIG_IMAGDEST_PATH)
    Write-Output "----------------------------------------------"
    # �J�n������ۑ�
    [DateTime]$dateTime = (Get-Date)

    # ���s
    foreach($fileObj in $AllFiles)
    {
        # $fileObj
        remakingDirectory $fileObj 
    }


    Write-Output "----------------------------------------------"
    Write-Output (" �ړ��t�@�C�����F" + $CntMoved)
    Write-Output (" �o�ߎ���(��)�F" + (New-TimeSpan $dateTime (Get-Date)).TotalMinutes)
    Write-Output "-----�t�H���_�\���̍č\�z���I�����܂���(Enter�L�[�ŏI�����܂�)-----"
}


# ���������s����
main
