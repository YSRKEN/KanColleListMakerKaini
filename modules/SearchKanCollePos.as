/**
 * �͂���̍��W����ʂ��猟�����郂�W���[��
 * ��{�I�ɂ́u�E�B���h�EID���󂯎��ƁARectangle�̌��ꗗ�ƌ�␔��Ԃ��v�悤�ɑ����Ă���
 */
#module SearchKanCollePos
    /* �e��萔�ݒ� */
    #const DEFAULT_GAME_WINDOW_WIDTH 1200  //�W���I�ȃQ�[����ʂ�X�T�C�Y
    #const DEFAULT_GAME_WINDOW_HEIGHT 720  //�W���I�ȃQ�[����ʂ�Y�T�C�Y
    #const MAX_ZOOM_RATIO 3  //�Q�[����ʂ�MAX_ZOOM_RATIO�{�܂ő傫���Ă�OK�A�Ƃ������Ӗ�
    #const STICK_ESCBUTTON 128
    #const STICK_LEFTBUTTON 256
    #const STICK_RIGHTBUTTON 512
    #define TRUE 1
    #define FALSE 0

    #const SM_XVIRTUALSCREEN 76
    #const SM_YVIRTUALSCREEN 77
    #const SM_CXVIRTUALSCREEN 78
    #const SM_CYVIRTUALSCREEN 79
    #const IDC_ARROW 32512
    #const MAKEINTRESOURCE 32515
    #const GCL_HCURSOR -12

    #const VIRTUAL_DISPLAY_X GetSystemMetrics(SM_XVIRTUALSCREEN)
	#const VIRTUAL_DISPLAY_Y GetSystemMetrics(SM_YVIRTUALSCREEN)
	#const VIRTUAL_DISPLAY_W GetSystemMetrics(SM_CXVIRTUALSCREEN)
	#const VIRTUAL_DISPLAY_H GetSystemMetrics(SM_CYVIRTUALSCREEN)

    /* �ŏ��l��Ԃ� */
    #defcfunc local Min int a, int b
        if (a > b) :return b
    return a

    /* �ő�l��Ԃ� */
    #defcfunc local Max int a, int b
        if (a > b) :return a
    return b

    /* �w�肵���_��RGB�l���擾����B(R<<16)+(G<<8)+B */
    #defcfunc local _pget int x, int y
        pget x, y
    return (ginfo_r << 16) + (ginfo_g << 8) + (ginfo_b)

    /**
     * ListMakerModule#getKanCollePos�ō̗p����Ă���A���S���Y��
     * (mx, my)�͊͂���̉�ʓ���(�E�B���h�EID�ɑ΂���)1���W�ł���A������܂ފ͂���̉�ʂ����o����
     */
    #defcfunc local method1 int windowId, array rectangles, int mx, int my
        // �萔�ݒ�
        MIN_GAME_WINDOW_WIDTH_HALF = 250 / 2
        MIN_GAME_WINDOW_HEIGHT_HALF = 150 / 2
        MIN_GAME_WINDOW_WIDTH_QUARTER = MIN_GAME_WINDOW_WIDTH_HALF / 2
        MIN_GAME_WINDOW_HEIGHT_QUARTER = MIN_GAME_WINDOW_HEIGHT_HALF / 2

        // ���O����
        gsel windowId
        window_width = ginfo_sx
        window_height = ginfo_sy

        // ��ʂ�����������Ƃ��͌��o���Ȃ��悤�ɂ���
        if (mx < MIN_GAME_WINDOW_WIDTH_HALF) :return 0
        if (mx + MIN_GAME_WINDOW_WIDTH_HALF >= window_width) :return 0
        if (my < MIN_GAME_WINDOW_HEIGHT_HALF) :return 0
        if (my + MIN_GAME_WINDOW_HEIGHT_HALF >= window_height) :return 0

        // �͂���̉�ʂ̉E�����W�̍X��1�s�N�Z���E��(�ʏ́F���W2)��X���Wrx���擾����
        // �܂�A(mx, my)���炠����x�E�ɐi�񂾓_A�ɂ��āAA����MIN_GAME_WINDOW_HEIGHT_QUARTER�Ԋu��
        // �c�����ɏ㉺2�_�Â擾���A�����̐F��A�̐F�Ɠ����Ȃ�AA��X���W��rx���Ɛ��肳���
        maxRightX = Min(mx + DEFAULT_GAME_WINDOW_WIDTH * MAX_ZOOM_RATIO, window_width)
        for px, mx + MIN_GAME_WINDOW_WIDTH_HALF, maxRightX
            tempColor = _pget(px, my)
            flg = TRUE
            for py, my - MIN_GAME_WINDOW_HEIGHT_HALF, my + MIN_GAME_WINDOW_HEIGHT_HALF + 1, MIN_GAME_WINDOW_HEIGHT_QUARTER
                if (_pget(px, py) != tempColor) :flg = FALSE :_break
            next
            if (flg) :logmes "rx = " + px + "(" + tempColor + ")" :_rx = px :_break
        next

        // ���W2��Y���Wry���擾����
        maxRightY = Min(my + DEFAULT_GAME_WINDOW_HEIGHT * MAX_ZOOM_RATIO, window_height)
        for py, my + MIN_GAME_WINDOW_HEIGHT_HALF, maxRightY
            tempColor = _pget(mx, py)
            flg = TRUE
            for px, mx - MIN_GAME_WINDOW_WIDTH_HALF, my + MIN_GAME_WINDOW_WIDTH_HALF + 1, MIN_GAME_WINDOW_WIDTH_QUARTER
                if (_pget(px, py) != tempColor) :flg = FALSE :_break
            next
            if (flg) :logmes "ry = " + py + "(" + tempColor + ")" :_ry = py :_break
        next

        // �͂���̉�ʂ̍�����W�̍X��1�s�N�Z������(�ʏ́F���W1)��Y���Wly���擾����
        minLeftY = Max(my - DEFAULT_GAME_WINDOW_HEIGHT * MAX_ZOOM_RATIO, -1)
        for py, my - MIN_GAME_WINDOW_HEIGHT_HALF, minLeftY, -1
            tempColor = _pget(mx, py)
            flg = TRUE
            for px, mx - MIN_GAME_WINDOW_WIDTH_HALF, my + MIN_GAME_WINDOW_WIDTH_HALF + 1, MIN_GAME_WINDOW_WIDTH_QUARTER
                if (_pget(px, py) != tempColor) :flg = FALSE :_break
            next
            if (flg) :logmes "ly = " + py + "(" + tempColor + ")" :_ly = py :_break
        next

        // �c�������܂�ɏ���������ۂ́A���ł͂Ȃ��Ƃ��Ēe��
        _height = _ry - _ly - 1
        if (_height < 100) :return 0

        // ���W1��X���Wlx���擾����
        minLeftX = Max(mx - DEFAULT_GAME_WINDOW_WIDTH * MAX_ZOOM_RATIO, -1)
        for px, mx - MIN_GAME_WINDOW_WIDTH_HALF, minLeftX, -1
            tempColor = _pget(px, my)
            flg = TRUE
            for py, my - MIN_GAME_WINDOW_HEIGHT_HALF, my + MIN_GAME_WINDOW_HEIGHT_HALF + 1, MIN_GAME_WINDOW_HEIGHT_QUARTER
                if (_pget(px, py) != tempColor) :flg = FALSE :_break
            next
            if (flg) :logmes "lx = " + px + "(" + tempColor + ")" :_lx = px :_break
        next

        // �c���䂪���������ꍇ�́A���ł͂Ȃ��Ƃ��Ēe��
        _width = _rx - _lx - 1
        if (abs(_height * 5 / 3 - _width) >= 3) :return 0

        // �ۑ��p�̃o�b�t�@�[��p��
        dim rectangles, 1, 4
        rectangles(0, 0) = _lx + 1
        rectangles(0, 1) = _ly + 1
        rectangles(0, 2) = _width
        rectangles(0, 3) = _height
    return 1

    /**
     * ListMakerModule#KanCollePosManual�ō̗p����Ă���A���S���Y��
     * �EwindowId�͎��O�ɉ��z�f�B�X�v���C�S�̂�BitBlt����Ă���buffer
     * �EoverlayWindowId�͉��z�f�B�X�v���C�S�̂Ɠ����T�C�Y�̃��C���[�h�E�B���h�E��bgscr
     * �EbgWindowId�͉��z�f�B�X�v���C�S�̂Ɠ����T�C�Y��bgscr�ŁAwindowId�̓��e���R�s�[����Ă���
     * �EbgWindowId���őO�ʕ\���ɂ��č�������z�f�B�X�v���C����ɍ��킹�A
     * �@�}�E�X���h���b�O���铮����overlayWindowId�̈ʒu�E�傫�������킹�Ă���B
     * �@�}�E�X�{�^���𗣂��ƁA�u�I��g�̕ӂ̒���X����1�s�N�Z���Â������m�F���Ă����A
     * �@X�ƈقȂ�F�ɍs�����������Ƃ���ł��̕ӂ̍i�肪���������Ƃ݂Ȃ��v�Ƃ������m��
     * �EEsc�L�[���E�}�E�X�{�^���������Ƌ����I������
     * �E���̊֐��̏I�����A�֐����s�O��gsel���Ă����E�B���h�EID��gsel������
     * �E�߂�l��RECT���z�肳��Ă���A�I�����s���̓I�[��0�ɂȂ�B
     * �@Rectangle�ɕϊ����Ă��A�I�����s���̓I�[��0�ɂȂ�v�Z
     */
    #defcfunc local method2 int windowId, array rectangles, int overlayWindowId, int bgWindowId
        // �ȑO�̃J�����g�E�B���h�EID���L��
        currentWindowId = ginfo_sel

        // �ۑ��p�̃o�b�t�@�[��p��
        dim rectangles, 1, 4
        rectangles(0, 0) = 0
        rectangles(0, 1) = 0
        rectangles(0, 2) = 0
        rectangles(0, 3) = 0

        // �E�B���h�E����̏������s��
        ;bgWindowId���őO�ʕ\���ɂ��č�������z�f�B�X�v���C����ɍ��킹��
    	gsel bgWindowId, 2
    	bgWindowIdHandle = hwnd
    	MoveWindow bgWindowIdHandle, VIRTUAL_DISPLAY_X, VIRTUAL_DISPLAY_Y, VIRTUAL_DISPLAY_W, VIRTUAL_DISPLAY_H, TRUE
        ;�}�E�X�J�[�\�����N���X��ɕύX���Ă���
    	LoadCursor 0, MAKEINTRESOURCE
    	SetClassLong bgWindowIdHandle, GCL_HCURSOR, stat
        ;overlayWindowId���\���ɂ��Ă���
    	gsel overlayWindowId, -1
    	overlayWindowIdHandle = hwnd
    	MoveWindow overlayWindowIdHandle, 0, 0, 0, 0, 0

        // �}�E�X�I���̃��[�v
        while (TRUE)
            // �L�[���͏�Ԃ�ǂݎ��(���}�E�X�{�^���͉������ςȂ������m)
            stick ky, STICK_LEFTBUTTON, 0

            // ���}�E�X�{�^���������Ă����ۂ̏���
            if (ky & STICK_LEFTBUTTON){
                // �X�^�u
            }else :if ((ky & STICK_ESCBUTTON) || (ky & STICK_RIGHTBUTTON)){
                // Esc�L�[ or �E�}�E�X�{�^�����������ۂ̏���
                // �X�^�u
            }else {
                // ���������Ă��Ȃ��Ƃ��̏���
                ; �I�[�o�[���C�E�B���h�E���\���ɂ���
                gsel overlayWindowId, -1
                ; bgWindowId�ɂ�����}�E�X�|�C���^�̐ݒ�����ɖ߂�
    			gsel bgWindowId
    			LoadCursor 0, IDC_ARROW
    			SetClassLong bgWindowId, GCL_HCURSOR, stat
                ; bgWindowId���\���ɂ���
    			gsel bgWindowId, -1
    			_break
            }
            await 16
            _break
        wend
    return 0
#global
