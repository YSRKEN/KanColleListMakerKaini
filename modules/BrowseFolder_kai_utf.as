/*

**���̃��W���[���͂[�������[���̂��[����(http://tu3.jp/)�ɂĔz�z���Ă���u�t�H���_�I���_�C�A���O���W���[���v��kanahiron�����ς������̂ł��B**
���z�z�� :http://tu3.jp/0110

*/

#ifndef __hsp3utf__
	dialog "���̃��W���[����HSP3utf���K�v�ł��B\n���C���\�[�X��include���Ă��������B\n\n���W���[��:BrowseFolder_kai_utf",1,"�I�����܂�"
	end
#endif

#ifndef xdim
#uselib "kernel32.dll"
#func global VirtualProtect@_xdim "VirtualProtect" var,int,int,var
#define global xdim(%1,%2) dim %1,%2: VirtualProtect@_xdim %1,%2*4,$40,x@_xdim
#endif

#module __BrowseFolder_kai_utf__

#uselib "comdlg32"
#func GetOpenFileName "GetOpenFileNameW" int
#func GetSaveFileName "GetSaveFileNameW" int
#cfunc CommDlgExtendedError "CommDlgExtendedError"
#uselib "user32.dll"
#func SendMessage "SendMessageW" int,int,int,int
#uselib "ole32.dll"
#func CoTaskMemFree "CoTaskMemFree" int
#uselib "shell32.dll"
#cfunc SHBrowseForFolder "SHBrowseForFolderW" int
#cfunc SHGetPathFromIDList "SHGetPathFromIDListW" int,int

#define BIF_RETURNONLYFSDIRS	0x0001
//�t�@�C���V�X�e���f�B���N�g���݂̂�Ԃ��܂��B����ȊO�̃A�C�e�����I������Ă���Ƃ��ɂ́A[OK]�{�^���͊D�F�\���ɂȂ�܂��B
#define BIF_DONTGOBELOWDOMAIN	0x0002
//�_�C�A���O�{�b�N�X�̃c���[�r���[�R���g���[���Ƀh���C�����x���̃l�b�g���[�N�t�H���_���܂߂Ȃ��悤�ɂ��܂��B
#define BIF_STATUSTEXT			0x0004
//�_�C�A���O�{�b�N�X�ɃX�e�[�^�X�̈��\�����܂��B�\���e�L�X�g��ݒ肷��ɂ́A�R�[���o�b�N�֐�����_�C�A���O�{�b�N�X�Ƀ��b�Z�[�W�𑗐M���܂��B
#define BIF_RETURNFSANCESTORS	0x0008
//�V�F���l�[���X�y�[�X�K�w�\���̒��Ń��[�g�t�H���_�̉��ɂ���t�@�C���V�X�e���T�u�t�H���_�݂̂�Ԃ��܂��B����ȊO�̃A�C�e�����I������Ă���Ƃ��ɂ́A[OK]�{�^���͊D�F�\���ɂȂ�܂��B
#define BIF_EDITBOX				0x0010
//Version 4.71 �ȍ~�F ���[�U�[���A�C�e�������������ނ��Ƃ��ł���G�f�B�b�g�R���g���[����\�����܂��B
#define BIF_VALIDATE			0x0020
//Version 4.71 �ȍ~�F ���[�U�[���G�f�B�b�g�R���g���[���ɖ����Ȗ��O����͂����ꍇ�ɁA BFFM_VALIDATEFAILED ���b�Z�[�W�ƂƂ��ɃR�[���o�b�N�֐����Ăяo����܂��BBIF_EDITBOX�t���O���w�肳��Ă��Ȃ��ꍇ�́A���̃t���O�͖�������܂��B
#define BIF_NEWDIALOGSTYLE		0x0040
//Version 5.0 �ȍ~�F �V�������[�U�[�C���^�[�t�F�[�X���g�p���܂��B�]���̃_�C�A���O�{�b�N�X�����傫���A���T�C�Y�\�ȃ_�C�A���O�{�b�N�X���\������A�_�C�A���O�{�b�N�X�ւ̃h���b�O�A���h�h���b�v�A�t�H���_�̍Đ����A�V���[�g�J�b�g���j���[�A�V�����t�H���_�쐬�A�폜�A���̑��̃V���[�g�J�b�g���j���[�R�}���h���ǉ�����܂��B���̃t���O���g�p����ɂ́A���炩����OleInitialize�֐��܂���CoInitialize�֐����Ăяo����COM�����������Ă����K�v������܂��B
#define BIF_USENEWUI			0x0050
//Version 5.0 �ȍ~�F �G�f�B�b�g�R���g���[�������A�V�������[�U�[�C���^�[�t�F�[�X���g�p���܂��B���̃t���O��BIF_EDITBOX|BIF_NEWDIALOGSTYLE�Ɠ����ł��B���̃t���O���g�p����ɂ́A���炩����OleInitialize�֐��܂���CoInitialize�֐����Ăяo����COM�����������Ă����K�v������܂��B
#define BIF_BROWSEINCLUDEURLS	0x0080
//Version 5.0 �ȍ~�F URL��\�����邱�Ƃ��ł���悤�ɂ��܂��BBIF_USENEWUI��BIF_BROWSEINCLUDEFILES�������Ɏw�肳��Ă��Ȃ���΂Ȃ�܂���B�����̃t���O���ݒ肳��Ă���Ƃ��A�I�����ꂽ�A�C�e�����܂ރt�H���_���T�|�[�g����ꍇ�ɂ̂݁AURL���\������܂��B�A�C�e���̑�����₢���킹�邽�߂Ƀt�H���_��IShellFolder::GetAttributesOf ���\�b�h���Ăяo���ꂽ�Ƃ��ɁA�t�H���_�ɂ����SFGAO_FOLDER�����t���O���ݒ肳�ꂽ�ꍇ�ɂ̂݁AURL���\������܂��B
#define BIF_UAHINT				0x0100
//Version 6.0 �ȍ~�F �G�f�B�b�g�R���g���[���̑���ɁA�_�C�A���O�{�b�N�X�ɗp�@�q���g��ǉ����܂��BBIF_NEWDIALOGSTYLE�t���O�ƂƂ��Ɏw�肵�Ȃ���΂Ȃ�܂���B
#define BIF_NONEWFOLDERBUTTON	0x0200
//Version 6.0 �ȍ~�F �_�C�A���O�{�b�N�X�Ɂu�V�����t�H���_�v�{�^����\�����Ȃ��悤�ɂ��܂��BBIF_NEWDIALOGSTYLE�t���O�ƂƂ��Ɏw�肵�Ȃ���΂Ȃ�܂���B
#define BIF_NOTRANSLATETARGETS	0x0400
//Version 6.0 �ȍ~�F �I�����ꂽ�A�C�e�����V���[�g�J�b�g�ł���Ƃ��A���̃����N��ł͂Ȃ��A�V���[�g�J�b�g�t�@�C�����̂�PIDL��Ԃ��܂��B
#define BIF_BROWSEFORCOMPUTER	0x1000
//�R���s���[�^�݂̂�Ԃ��܂��B����ȊO�̃A�C�e�����I������Ă���Ƃ��ɂ́A[OK]�{�^���͊D�F�\���ɂȂ�܂��B
#define BIF_BROWSEFORPRINTER	0x2000
//�v�����^�݂̂�Ԃ��܂��B����ȊO�̃A�C�e�����I������Ă���Ƃ��ɂ́AOK �{�^���͊D�F�\���ɂȂ�܂��B
#define BIF_BROWSEINCLUDEFILES	0x4000
//Version 4.71 �ȍ~�F �t�H���_�ƃt�@�C����\�����܂��B
#define BIF_SHAREABLE			0x8000
//Version 5.0 �ȍ~�F �����[�g�V�X�e����ɂ��鋤�L���\�[�X��\���ł���悤�ɂ��܂��BBIF_USENEWUI�t���O�ƂƂ��Ɏw�肵�Ȃ���΂Ȃ�܂���B

#ifndef TRUE
#define global FALSE 0
#define global TRUE  1
#endif

#define global BrowseFolder(%1,%2="",%3=0)  _BrowseFolder %1,%2,%3
#define global BrowseFolder2(%1,%2="",%3=1) _BrowseFolder %1,%2,%3

#deffunc _BrowseFolder str _szTitle, str _defaultfolder , int flag

	// flag��0�̎��́u�V�����t�H���_�v�{�^�����\���A1�̎��͕\��

	sdim retfldr, 1024
	sdim _retfldr, 1024
	sdim szTitle, 1024
	sdim inifldr, 1024

	xdim fncode, 8

	cnvstow szTitle, _szTitle
	//cnvstow inifldr, _defaultfolder
	inifldr = _defaultfolder
	if flag = FALSE{
		ulFlags = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE
	} else {
		ulFlags = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE | BIF_NONEWFOLDERBUTTON
	}

	fncode = $08247c83,$8b147501,$ff102444,$68016a30,$00000466,$102474ff,$330450ff,$0010c2c0
	hbdata = varptr(inifldr), varptr(SendMessage)
	BROWSEINFO = hwnd, 0, varptr(retfldr), varptr(szTitle), ulFlags, varptr(fncode), varptr(hbdata), 0
	pidl = SHBrowseForFolder(varptr(BROWSEINFO))
	fret = SHGetPathFromIDList(pidl,varptr(_retfldr))
	CoTaskMemFree pidl

	retfldr = cnvwtos(_retfldr)
	mref stt,64 : stt = fret
return retfldr

#global

//unicode�Ή��T���v���R�[�h
#if 0

	sdim String,256
	repeat 64
		ccnt = cnt*3
		poke String,ccnt+0,0xe2
		poke String,ccnt+1,0x98
		poke String,ccnt+2,0x80+cnt
	loop

	BrowseFolder String,"C:\\"			//�V�����t�H���_�{�^���L��
	//BrowseFolder2 String,"C:\\" 		//�V�����t�H���_�{�^������1
	//BrowseFolder String,"C:\\",1		//�V�����t�H���_�{�^������2
	if stat = TRUE{
		mes refstr
	} else {
		mes "���I��"
	}

#endif
