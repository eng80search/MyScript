# 2018/12/19
# csv�t�@�C������R�s�[�t�@�C�������擾���A�R�s�[���̃��[�g�p�X�̃T�u�f�B���N�g�����������āA
# �t�@�C�������݂���΂��̃t�@�C�����R�s�[��̃t�H���_�ɃR�s�[����B
#
# ���s���@�F
#           �@�R�s�[���t�@�C����������CSV�t�@�C������������B�i�w�b�_�̓X�L�b�v����j
#           �A�X�N���v�g�̐ݒ蕔���ɂ�CSV�t�@�C���̃p�X�A�R�s�[���t�H���_�A�R�s�[��t�H���_�̃p�X����ݒ肷��B
#

#�e�X�g�p�R�[�h
# Write-Output ("debug00:DebugStart")


# -----�ݒ蕔��-----
$CONFIG_CSV_PATH = "C:\Users\user1\01_Work\15_�T�u�f�B���N�g���R�s�[�X�N���v�g\00_ImportCSV"
$CONFIG_IMAGESOURCE_PATH = "C:\Users\user1\01_Work\15_�T�u�f�B���N�g���R�s�[�X�N���v�g\01_SourceImage"
$CONFIG_IMAGDEST_PATH = "C:\Users\user1\01_Work\15_�T�u�f�B���N�g���R�s�[�X�N���v�g\02_DestImage"
$CONFIG_CURRENT_PATH = $PSScriptRoot

# �R�s�[�����̃J�E���^�[
$Script:CntAll = 0

# �R�s�[�������̃J�E���^�[
$Script:CntCopied = 0

# CSV�t�@�C���ꗗ���擾����B
$CsvFiles = Get-ChildItem -Path $CONFIG_CSV_PATH  -Recurse  -Filter *.csv | Select-Object -ExpandProperty FullName

# ���[�g�f�B���N�g�������̑S�T�u�f�B���N�g���ɂ�
# �\�[�X�摜�t�@�C���̈ꗗ���擾����B�����F�������t�@�C���Ŋg���q��jpg
$ImageSourceFiles = Get-ChildItem -Path $CONFIG_IMAGESOURCE_PATH -Recurse `
                    | Where-Object {$_.Attributes -eq "Archive"} `
                    | Where-Object {$_.Extension -eq ".JPG"} `
                    # | Select-Object -ExpandProperty FullName

# Write-Output ($ImageSourceFiles)

# # �e�X�g�F�t�@�C���ꗗ�\��
# foreach ($ImageSourceFile in $ImageSourceFiles)
# {
#     # ���ڂ̒l���擾����
#     $Value = $ImageSourceFile
#     Write-Output ($Value)
# }


# �R�s�[�������̃J�E���^�[
$CntCopied = 0

# -----��������-----
# �t�H���_�č\�z�����{�̊֐�
function recursiveCopyFile($csvFileFullName)
{

    try{

        # �e�X�g�p
        # Write-Output ("csvFileFullName: " + $csvFileFullName)

        # 0.��s�̃f�[�^���擾����
        $CsvDataArray = Import-Csv $csvFileFullName -Encoding Default | Select-Object "�摜�t�@�C����"

        # CSV�t�@�C������s����������
        foreach ($CsvData in $CsvDataArray)
        {

            # ���ڂ̒l���擾����
            # Write-Output ("ImagePathInfo: " + $CsvData."�摜�t�@�C����")
            $CsvInfoImgFileName = $CsvData."�摜�t�@�C����"
            # Write-Output ($CsvInfoImgFileName)

            # �R�s�[���t�@�C���ꗗ����R�s�[�Ώۃt�@�C�������݂��邩�m�F����B
            foreach ($ImageSourceFile in $ImageSourceFiles)
            {

                # �R�s�[���t�@�C������t�@�C�����̂݁A�擾����B
                $ImageFileNameOnly = $ImageSourceFile | Select-Object -ExpandProperty Name
                # Write-Output ("@@@--:" + $ImageFileNameOnly)

                # �R�s�[���t�@�C���ꗗ����R�s�[�Ώۃt�@�C�������݂��邩�m�F����B
                if($ImageFileNameOnly -eq $CsvInfoImgFileName){
                    # ���߂ăR�s�[���t�@�C���̃t���p�X���擾����B
                    $ImageFileNameFullPath = $ImageSourceFile | Select-Object -ExpandProperty FullName
                    $DestFullPath = $CONFIG_IMAGDEST_PATH 
                    Write-Output ("Info: ��v�t�@�C��[" + $CsvInfoImgFileName + "]���R�s�[��t�H���_�փR�s�[���܂����B")
                    Copy-Item $ImageFileNameFullPath  $DestFullPath -force
                    $Script:CntCopied += 1
                }
            }

            $Script:CntAll += 1

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

    Write-Output "-----�t�@�C���̍ċA�R�s�[���J�n���Ă��܂�-----"

    Write-Output ("���s�p�X:" + $CONFIG_CURRENT_PATH)
    Write-Output ("CSV�t�@�C���f�B���N�g���F" + $CONFIG_CSV_PATH)
    Write-Output ("�R�s�[�����[�g�f�B���N�g���F" + $CONFIG_IMAGESOURCE_PATH)
    Write-Output ("�R�s�[�惋�[�g�f�B���N�g���F" + $CONFIG_IMAGDEST_PATH)
    Write-Output "----------------------------------------------"
    # �J�n������ۑ�
    [DateTime]$dateTime = (Get-Date)

    # ���s
    foreach($fileObj in $CsvFiles)
    {
        # $fileObj
        recursiveCopyFile $fileObj 
    }


    Write-Output "----------------------------------------------"
    Write-Output (" �ǂݍ��݃t�@�C�����F" + $CntAll)
    Write-Output (" �R�s�[�t�@�C�����F" + $CntCopied)
    Write-Output (" �o�ߎ���(��)�F" + (New-TimeSpan $dateTime (Get-Date)).TotalMinutes)
    Write-Output "-----�t�@�C���̍ċA�R�s�[���I�����܂���(Enter�L�[�ŏI�����܂�)-----"
}


# ���������s����
main
