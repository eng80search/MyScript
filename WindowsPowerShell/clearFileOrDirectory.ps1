# 2019/04/22
# Windows PowerShell�X�N���v�g
# �R�s�[��̃t�H���_���쐬����Ă��Ȃ��ꍇ�̂݁A�R�s�[���t�H���_����R�s�[���s���B
#
# �ݒ蕔��

# $CONFIG_CURRENT_PATH = $PSScriptRoot
$CONFIG_CURRENT_PATH = ""

$CONFIG_FILE1_NAME = ""
$CONFIG_FILE2_NAME = ""
$CONFIG_KAKUTEI_NAME = ""


try{

            # �t�@�C���폜�P
            $fileName = "D:\Share\AplMeisaiBilkImport\IntermediateFile\01\Importdata_T_D_GAIYO.csv"
            if(Test-Path $fileName){
                #�t�@�C���폜
                Remove-Item  $fileName
                Write-Output ("Info: �t�@�C��1[" + $fileName + "]���폜���܂����B")
            }

            # �t�@�C���폜�Q
            $fileName = "D:\Share\AplMeisaiBilkImport\IntermediateFile\02\Importdata_T_D_MEISAI.csv"
            if(Test-Path $fileName){
                #�t�@�C���폜
                Remove-Item  $fileName
                Write-Output ("Info: �t�@�C��1[" + $fileName + "]���폜���܂����B")
            }

            # �t�@�C���폜�R
            $fileName = "D:\Share\AplMeisaiBilkImport\IntermediateFile\03\Importdata_T_W_MEISAI_BULK_IMPORT.csv"
            if(Test-Path $fileName){
                #�t�@�C���폜
                Remove-Item  $fileName
                Write-Output ("Info: �t�@�C��1[" + $fileName + "]���폜���܂����B")
            }

            # �f�B���N�g���폜
            $dirName = "D:\Share\DetailFile"
            if(Test-Path $dirName){
                #�t�@�C���폜
                $dirName += "\*"
                Remove-Item $dirName  -Recurse
                Write-Output ("Info: �f�B���N�g��[" + $dirName + "]�ȉ����폜���܂����B")
            }

} catch {

        Write-Output("�t�@�C���N���A�G���[:" + $dirName)
}
