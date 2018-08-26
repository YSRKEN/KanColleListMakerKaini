/**
 * ���[�e�B���e�B�֐��̃��W���[��
 */
#module kmodule
	/* WinAPI */
	#uselib "user32.dll"
		#func GetSystemMetrics "GetSystemMetrics" int
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
	#deffunc local SafeDelete str file_path
		if _exist(file_path) >= 0 :delete file_path
	return

	/**
	 * �ȉ��̃t�B�[���h�̒l������������
	 * menuH : �ʏ�̃^�C�g���o�[�̍����{�^�C�g���o�[������A�T�C�Y���ύX�ł��Ȃ��E�B���h�E�̎��͂��͂ޘg�̍���
	 * menuW : �^�C�g���o�[������A�T�C�Y���ύX�ł��Ȃ��E�B���h�E�̎��͂��͂ޘg�̕�
	 */
	#deffunc local Init
		menuH = GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYDLGFRAME)
		menuW = GetSystemMetrics(SM_CXDLGFRAME)
	return

	/**
	 * ��̃t�B�[���h�l�ƕ����čl����ƁA
	 * _mousex : �}�E�X�J�[�\���̃E�B���h�E�ɑ΂��鑊��X���W�ŁAmousex�Ƃقړ����Ӗ�
	 * _mousey : �}�E�X�J�[�\���̃E�B���h�E�ɑ΂��鑊��Y���W�ŁAmousey�Ƃقړ����Ӗ�
	 */
	#define global _mousex mousex_()
	#defcfunc mousex_
	return (ginfo_mx - ginfo_wx1 - menuW)

	#define global _mousey mousey_()
	#defcfunc mousey_
	return (ginfo_my - ginfo_wy1 - menuH)

	/**
	 * ����notesel���Ă��镶����^�ɑ΂��A�w�肵���s�̕������Ԃ�
	 * @param line_number �s���w��
	 * @return (line_number+1)�s�ڂ̕�����
	 */
	#defcfunc _noteget int lineNumber
		noteget retVal, lineNumber
	return retVal

	/**
	 * �^����ꂽ��������Í�������
	 */
	#defcfunc local EncStr str p1_
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
		Encode@machine_base64 p1, len, encData
		encData = strf("%02X%s", len, encData)
		strrep encData, "\n", ""
	return encData

	/**
	 * �^����ꂽ��������Í�������
	 */
	#defcfunc local DecStr var p1_
		len = int("$" + strmid(p1_, 0,2 ))
		sdim p1, strlen(p1_) + 1
		sdim decData, len + 10
		p1 = strmid(p1_, 2, strlen(p1_) - 2)
		Decode@machine_base64 p1, strlen(p1), decData
		randomize 3141
		repeat len
			poke decData, cnt, (peek(decData, cnt) xor rnd(256))
		loop
		randomize 5926
		repeat len
			poke decData, cnt, (peek(decData, cnt) xor rnd(256))
		loop
		randomize 5358
		repeat len
			poke decData, cnt, (peek(decData, cnt) xor rnd(256))
		loop
	return decData
#global
