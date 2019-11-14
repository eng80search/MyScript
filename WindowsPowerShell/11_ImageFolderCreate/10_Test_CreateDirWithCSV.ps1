# 2018/08/09 �t�@�C�����J�n������I�����܂ŕ����R�s�[����

# -----�ݒ蕔��-----
$CONFIG_IMAGEROOT_PATH    = "C:\Users\user1\01_Work\13_RebuildDirecotry\00_Test\01_SourceImage"
$CONFIG_SOURCE_IMAGE_PATH = Join-Path $PSScriptRoot "00.jpg"
$CONFIG_CURRENT_PATH      = $PSScriptRoot
# �e�X�g�p�C���[�W�t�H���_�쐬����ۂɃo�b�`�ԍ����ɍ쐬���邩�ǂ����̃t���O 1: �쐬���� 0: �쐬���Ȃ�
$CONFIG_FLG_HAS_BAT_SUBDIR  = 0 

Write-Output ("debug01:" + $CONFIG_CURRENT_PATH)

# ���݂̎��s�t�@�C���̒����̃T�u�f�B���N�g�����擾���āA�č\�z���������s
$CsvFiles = Get-ChildItem -Path $CONFIG_CURRENT_PATH  -Recurse  -Filter *.csv | Select-Object -ExpandProperty FullName 

# -----��������-----
# �t�H���_�č\�z�����{�̊֐�
function remakingDirectory($csvFileFullName)
{

    try{
        Write-Output ("csvFileFullName: " + $csvFileFullName)

        # 0.��s�̃f�[�^���擾����
        $CsvDataArray = Import-Csv $csvFileFullName -Encoding Default | Select-Object "�o�b�`�ԍ�","�X�L���i�ǎ��","�C���[�W�t�@�C����"


        # CSV�t�@�C������s����������
        foreach ($CsvData in $CsvDataArray)
        {

            Write-Output ("CsvData: " + $CsvData)

            # �����F001����n�܂�t�H���_�����擾����(�o�b�`�ԍ�������ɊY��)
            $ImagePathSub01 = $CsvData."�X�L���i�ǎ��"
            $ImagePathSub02 = $CsvData."�o�b�`�ԍ�"

            # �����F�R�s�[��C���[�W�t�@�C�����擾����
            $ImageFileName = $CsvData."�C���[�W�t�@�C����"

            # �����C�F�t�@�C�������邩���f����B�Ȃ���΂��̂܂܏I������B
            $ImageFileNameFullPath = $CONFIG_IMAGEROOT_PATH
            $ImageFileNameFullPath += "\" + $ImagePathSub01
            # �����F�o�b�`�ԍ����̃T�u�t�H���_���쐬���邩���Ȃ�
            if($CONFIG_FLG_HAS_BAT_SUBDIR){

                $ImageFileNameFullPath += "\" + $ImagePathSub02 
            }

            Write-Output ("ImageFileNameFullPath:" + $ImageFileNameFullPath)
            if(-not(Test-Path $ImageFileNameFullPath)){
                New-Item -ItemType Directory  -Path $ImageFileNameFullPath
            }

            $ImageFileNameFullPath += "\" + $ImageFileName


            $sourceFileFullPath = $CONFIG_SOURCE_IMAGE_PATH 

            # 3.�ړ�������ړ���փt�@�C�����ړ�����B
            Copy-Item $sourceFileFullPath $ImageFileNameFullPath

            # 4.����I��

        }

    }catch{

            # 5.�ُ�I��
            Write-Output $error[0]
            # $errorMsg = (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + (" CSV�f�[�^: ") + $CsvData + " error:  " + $error[0]
            # $errorMsg | Out-File -Append "error.log"
            return 1
        }

}

# ���C�������֐�
function main
{

    Write-Output "-----�t�H���_�\���̍č\�z���J�n���Ă��܂�-----"
    $hasError = 0

    # ���s
    foreach($fileObj in $CsvFiles)
    {
        # $fileObj
        remakingDirectory $fileObj 
    }

    Write-Output "-----�t�H���_�\���̍č\�z���I�����܂���-----"
}


# ���������s����
main
