/**
 * ���[�e�B���e�B�֐��̃��W���[��
 */
#module kmodule
	/* WinAPI */
	#uselib "user32.dll"
		#cfunc GetSystemMetrics "GetSystemMetrics" int
	#const SM_CYCAPTION 4
	#const SM_CXDLGFRAME 7
	#const SM_CYDLGFRAME 8

	/**
	 * exist���߂̊֐���
	 * (���O���[�o���ϐ�strsize��ύX����)
	 * @param file_path ���݂��Ă��邩���m�F�������t�@�C���̃p�X
	 * @return �t�@�C���p�X��file_path�̏ꏊ�Ƀt�@�C�������݂��Ă���΃t�@�C���T�C�Y�A�����łȂ��ꍇ��-1
	 */
	#defcfunc _exist str file_path
		exist file_path
	return strsize

	/**
	 * �w�肵���p�X�ɂ���t�@�C�������S�ɍ폜����
	 * (���݂��Ȃ��p�X�ɑ΂���delete���߂����s����ƃG���[�ɂȂ邽��)
	 * @param file_path �t�@�C���̃p�X
	 * @return �t�@�C���p�X�̐�ɂ���t�@�C�������݂��鎞�ɂ̂݃t�@�C�����폜
	 */
	#deffunc local safe_delete str file_path
		if _exist(file_path) >= 0 :delete file_path
	return

	/**
	 * �ȉ��̃t�B�[���h�̒l������������
	 * menu_h : �ʏ�̃^�C�g���o�[�̍����{�^�C�g���o�[������A�T�C�Y���ύX�ł��Ȃ��E�B���h�E�̎��͂��͂ޘg�̍���
	 * menu_w : �^�C�g���o�[������A�T�C�Y���ύX�ł��Ȃ��E�B���h�E�̎��͂��͂ޘg�̕�
	 */
	#deffunc local init
		menu_h = GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYDLGFRAME)
		menu_w = GetSystemMetrics(SM_CXDLGFRAME)
	return

	/**
	 * ��̃t�B�[���h�l�ƕ����čl����ƁA
	 * _mousex : �}�E�X�J�[�\���̃E�B���h�E�ɑ΂��鑊��X���W�ŁAmousex�Ƃقړ����Ӗ�
	 * _mousey : �}�E�X�J�[�\���̃E�B���h�E�ɑ΂��鑊��Y���W�ŁAmousey�Ƃقړ����Ӗ�
	 */
	#define global _mousex mousex_()
	#defcfunc mousex_
	return (ginfo_mx - ginfo_wx1 - menu_w)

	#define global _mousey mousey_()
	#defcfunc mousey_
	return (ginfo_my - ginfo_wy1 - menu_h)

	/**
	 * ����notesel���Ă��镶����^�ɑ΂��A�w�肵���s�̕������Ԃ�
	 * @param line_number �s���w��
	 * @return (line_number+1)�s�ڂ̕�����
	 */
	#defcfunc _noteget int line_number
		noteget retval, line_number
	return retval

	/**
	 * �^����ꂽ��������Í�������
	 */
	#defcfunc local encstr str p1_
		len = strlen(p1_)
		sdim p1, len + 1
		sdim encdata, int(1.5 * len) + 3
		p1 = p1_
		randomize 3141
		repeat len
			poke p1, cnt, (peek(p1, cnt) xor rnd(256))
		loop
		randomize 5926
		repeat len
			poke p1, cnt, (peek(p1, cnt) xor rnd(256))
		loop
		randomize 5358
		repeat len
			poke p1, cnt, (peek(p1, cnt) xor rnd(256))
		loop
		Base64Encode p1, len, encdata
		encdata = strf("%02X%s", len, encdata)
		strrep�@encdata, "\n", ""
	return encdata

	/**
	 * �^����ꂽ��������Í�������
	 */
	#defcfunc local decstr var p1_
		len = int("$" + strmid(p1_, 0,2 ))
		sdim p1, strlen(p1_) + 1
		sdim decdata, len + 10
		p1 = strmid(p1_, 2, strlen(p1_) - 2)
		Base64Decode p1, strlen(p1), decdata
		randomize 3141
		repeat len
			poke decdata, cnt, (peek(decdata, cnt) xor rnd(256))
		loop
		randomize 5926
		repeat len
			poke decdata, cnt, (peek(decdata, cnt) xor rnd(256))
		loop
		randomize 5358
		repeat len
			poke decdata, cnt, (peek(decdata, cnt) xor rnd(256))
		loop
	return decdata
#global
