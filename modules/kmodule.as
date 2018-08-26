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
	 * �w�肵���t�@�C���p�X�Ƀt�@�C�������݂��邩�𔻒肷��
	 * (���O���[�o���ϐ�strsize��ύX����)
	 * @param path ���݂��Ă��邩���m�F�������t�@�C���̃p�X
	 * @return �t�@�C���p�X��path�̏ꏊ�Ƀt�@�C�������݂��Ă����1�A�����łȂ��ꍇ��0
	 */
	#defcfunc kmexist str file_path
		exist file_path
	return strsize

	/**
	 * �ȉ��̃t�B�[���h�̒l������������
	 * menuh : �ʏ�̃^�C�g���o�[�̍����{�^�C�g���o�[������A�T�C�Y���ύX�ł��Ȃ��E�B���h�E�̎��͂��͂ޘg�̍���
	 * menuw : �^�C�g���o�[������A�T�C�Y���ύX�ł��Ȃ��E�B���h�E�̎��͂��͂ޘg�̕�
	 */
	#deffunc kmmouse_init
		menuh = GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYDLGFRAME)
		menuw = GetSystemMetrics(SM_CXDLGFRAME)
	return

	/**
	 * ��̃t�B�[���h�l�ƕ����čl����ƁA
	 * kmmousex : �}�E�X�J�[�\���̃E�B���h�E�ɑ΂��鑊��X���W�ŁAmousex�Ƃقړ����Ӗ�
	 * kmmousey : �}�E�X�J�[�\���̃E�B���h�E�ɑ΂��鑊��Y���W�ŁAmousey�Ƃقړ����Ӗ�
	 */
	#define global kmmousex kmmousex_()
	#defcfunc kmmousex_
	return (ginfo_mx - ginfo_wx1 - menuw)

	#define global kmmousey kmmousey_()
	#defcfunc kmmousey_
	return (ginfo_my - ginfo_wy1 - menuh)

	/**
	 * ����notesel���Ă��镶����^�ɑ΂��A�w�肵���s�̕������Ԃ�
	 * @param line_number �s���w��
	 * @return (line_number+1)�s�ڂ̕�����
	 */
	#defcfunc kmnoteget int line_number
		noteget retval, line_number
	return retval

	/**
	 * �^����ꂽ��������Í���������̂Ǝv����
	 * �����Abase64encode���߂�grep���Ă�������Ȃ���
	 */
	#defcfunc encstr str p1_,local len
		len = strlen(p1_)
		sdim p1,len+1
		sdim encdata,int(1.5*len)+3
		p1 = p1_
		randomize 3141
		repeat len
			poke p1,cnt,(peek(p1,cnt) xor rnd(256))
		loop
		randomize 5926
		repeat len
			poke p1,cnt,(peek(p1,cnt) xor rnd(256))
		loop
		randomize 5358
		repeat len
			poke p1,cnt,(peek(p1,cnt) xor rnd(256))
		loop
		base64encode p1,len,encdata
		encdata = strf("%02X%s",len,encdata)
		strrep�@encdata,"\n",""
	return encdata

	/**
	 * �^����ꂽ��������Í���������̂Ǝv����
	 * �����Abase64decode���߂��i����
	 */
	#defcfunc decstr var p1_,local len
		len = int("$"+strmid(p1_,0,2))
		sdim p1,strlen(p1_)+1
		sdim decdata,len+10
		p1 = strmid(p1_,2,strlen(p1_)-2)
		base64decode p1,strlen(p1),decdata
		randomize 3141
		repeat len
			poke decdata,cnt,(peek(decdata,cnt) xor rnd(256))
		loop
		randomize 5926
		repeat len
			poke decdata,cnt,(peek(decdata,cnt) xor rnd(256))
		loop
		randomize 5358
		repeat len
			poke decdata,cnt,(peek(decdata,cnt) xor rnd(256))
		loop
	return decdata
#global
