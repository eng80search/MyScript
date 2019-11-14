# 2019/04/22
# Windows PowerShell�X�N���v�g
# �R�s�[��̃t�H���_���쐬����Ă��Ȃ��ꍇ�̂݁A�R�s�[���t�H���_����R�s�[���s���B
#
# �ݒ蕔��

# $CONFIG_CURRENT_PATH = $PSScriptRoot
$CONFIG_CURRENT_PATH = "C:\Users\user1\Documents\00_Ri\03_���\02_�A�v����o�����׈ꊇ�o�^�@�\\00_testData"
$CONFIG_END = 44
$CONFIG_START_INDEX = 2

$CONFIG_FILE1_NAME = "20190405_No"
$CONFIG_FILE2_NAME = "20190405_No"
$CONFIG_KAKUTEI_NAME = "20190405_operationDate.txt"

# �R�s�[���t�@�C��
$CONFIG_SOURCE_FILE1_FULLPATH = $CONFIG_CURRENT_PATH + "\0\1\20190405_No0_1.csv"
$CONFIG_SOURCE_FILE2_FULLPATH = $CONFIG_CURRENT_PATH + "\0\2\20190405_No0_2.csv"
$CONFIG_SOURCE_KAKUTEI_FULLPATH = $CONFIG_CURRENT_PATH + "\0\" + $CONFIG_KAKUTEI_NAME

try{

        # le:�ȉ� lt:��菬����
        for($i = $CONFIG_START_INDEX; $i -le $CONFIG_END; $i++)
        {
            # �f�B���N�g�����쐬
            $dirName = $CONFIG_CURRENT_PATH
            $dirName += "\" + $i
            if(-not(Test-Path $dirName)){
                New-Item -ItemType Directory  -Path $dirName
                Write-Output("�f�B���N�g���쐬����:" + $dirName)

                #�t�H���_�P���쐬
                $destDirName1 = $dirName + "\1"
                New-Item -ItemType Directory  -Path $destDirName1
                # File1�̖��O��ݒ肷��B
                $destFile1Name = $CONFIG_FILE1_NAME + $i + "_1.csv"
                $destFile1FullPath = $destDirName1 + "\" + $destFile1Name

                # File1�R�s�[
                Write-Output ("Info: �t�@�C��1[" + $destFile1Name + "]���R�s�[��t�H���_�փR�s�[���܂����B")
                Copy-Item  $CONFIG_SOURCE_FILE1_FULLPATH  $destFile1FullPath -force


                #�t�H���_�P���쐬
                $destDirName2 = $dirName + "\2"
                New-Item -ItemType Directory  -Path $destDirName2
                # File2�̖��O��ݒ肷��B
                $destFile2Name = $CONFIG_FILE2_NAME + $i + "_2.csv"
                $destFile2FullPath = $destDirName2 + "\" + $destFile2Name

                # File2�R�s�[
                Write-Output ("Info: �t�@�C��2[" + $destFile2Name + "]���R�s�[��t�H���_�փR�s�[���܂����B")
                Copy-Item  $CONFIG_SOURCE_FILE2_FULLPATH  $destFile2FullPath -force

                # �m��t�@�C�����R�s�[
                $destKakuteiName = $CONFIG_KAKUTEI_NAME
                $destKakuteiFullPath = $dirName + "\" + $destKakuteiName
                Write-Output ("Info: �m��t�@�C��[" + $destKakuteiName + "]���R�s�[��t�H���_�փR�s�[���܂����B")
                Copy-Item  $CONFIG_SOURCE_KAKUTEI_FULLPATH  $destKakuteiFullPath -force

            }

        }

        Write-Output("�쐬�������������܂����B")
} catch {

        Write-Output("�f�B���N�g���쐬�G���[!:" + $dirName)
}
