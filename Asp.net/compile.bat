@REM �T�v�Fmsbuild.exe���g�p����asp.net�v���W�F�N�g���R���p�C������o�b�`�t�@�C��
@REM �g�p���@�F�R�}���h�v�����v�g�Ŏ��s����

@echo ***** CurrentDirectory��StoresLocator�v���W�F�N�g�ɐݒ肵�Ă��܂��E�E�E
@cd D:\00_Ri\00_���\10_gitSvnSource\src\PC\AcuvueStore
@REM �󔒍s��ǉ�
@echo.
@echo ***** msbuild��StoreLocator�v���W�F�N�g���r���h���Ă��܂��E�E�E
@echo ***** mode:debug
msbuild  /t:build /p:configuration=debug /p:Plateform="x64" 
@REM msbuild  /t:clean;build /p:configuration=release 
@echo ***** StoreLocator�v���W�F�N�g�̃r���h���������܂����B
