/**
 * �͂���̍��W����ʂ��猟�����郂�W���[��
 * ��{�I�ɂ́u�E�B���h�EID���󂯎��ƁARectangle�̌��ꗗ�ƌ�␔��Ԃ��v�悤�ɑ����Ă���
 */

#if 1
    #include "../SubSource/FunctionDefinition.hsp"
#endif

#include "ChangeBitmapDepth.as"

#module SearchKanCollePos
    /* �e��萔�ݒ� */
    #const DEFAULT_GAME_WINDOW_WIDTH 1200  //�W���I�ȃQ�[����ʂ�X�T�C�Y
    #const DEFAULT_GAME_WINDOW_HEIGHT 720  //�W���I�ȃQ�[����ʂ�Y�T�C�Y
    #const MAX_ZOOM_RATIO 3.0  //�Q�[����ʂ�MAX_ZOOM_RATIO�{�܂ő傫���Ă�OK�A�Ƃ������Ӗ�
    #const MIN_ZOOM_RATIO 0.4  //�Q�[����ʂ�MIN_ZOOM_RATIO�{�܂ŏ������Ă�OK�A�Ƃ������Ӗ�
    #const STICK_ESCBUTTON 128
    #const STICK_LEFTBUTTON 256
    #const STICK_RIGHTBUTTON 512
    #define TRUE 1
    #define FALSE 0
    #define BASE_ASPECT_RATIO 0.6
    #const MREF_VRAM 66

    #const SM_XVIRTUALSCREEN 76
    #const SM_YVIRTUALSCREEN 77
    #const SM_CXVIRTUALSCREEN 78
    #const SM_CYVIRTUALSCREEN 79
    #const IDC_ARROW 32512
    #const MAKEINTRESOURCE 32515
    #const GCL_HCURSOR -12

    #define VIRTUAL_DISPLAY_X GetSystemMetrics@(SM_XVIRTUALSCREEN)
	#define VIRTUAL_DISPLAY_Y GetSystemMetrics@(SM_YVIRTUALSCREEN)
	#define VIRTUAL_DISPLAY_W GetSystemMetrics@(SM_CXVIRTUALSCREEN)
	#define VIRTUAL_DISPLAY_H GetSystemMetrics@(SM_CYVIRTUALSCREEN)

    /* �ŏ��l��Ԃ� */
    #defcfunc local Min int a, int b
        if (a > b) :return b
    return a

    /* �ő�l��Ԃ� */
    #defcfunc local Max int a, int b
        if (a > b) :return a
    return b

    /* �w�肵���_��RGB�l���擾����B(R<<16)|(G<<8)|B */
    #defcfunc local _pget int x, int y
        pget x, y
    return ((ginfo_r << 16) | (ginfo_g << 8) | (ginfo_b))

    /* �uchggm 32�v�����󋵉��ŁA�w�肵���_��RGB�l���擾����B(R<<16)|(G<<8)|B */
    #defcfunc local _pget2 int x, int y
    return vram(x + (windowHeight - 1 - y) * windowWidth)

    /**
     * ListMakerModule#getKanCollePos�ō̗p����Ă���A���S���Y��
     * (mx, my)�͊͂���̉�ʓ���(�E�B���h�EID�ɑ΂���)1���W�ł���A������܂ފ͂���̉�ʂ����o����
     */
    #defcfunc local SemiAuto int windowId, array rectangles, int mx, int my
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
        dim rectangles, 4, 1
        rectangles(0, 0) = _lx + 1, _ly + 1, _width, _height
    return 1

    /**
     * ListMakerModule#KanCollePosManual��ListMakerModule#SelectCapturePos�ō̗p����Ă���A���S���Y��
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
     * �@(�Ȃ��AmarginCutFlg��FALSE�Ȃ�΁A�I��������̃g���~���O�ߒ����������Ȃ�)
     */
    #defcfunc local Manual int windowId, array rectangles, int overlayWindowId, int bgWindowId, int marginCutFlg
        // �ȑO�̃J�����g�E�B���h�EID���L��
        currentWindowId = ginfo_sel

        // �ۑ��p�̃o�b�t�@�[��p��
        dim rectangles, 4, 1
        rectangles(0, 0) = 0, 0, 0, 0
        rectangleCount = 0

        // �E�B���h�E����̏������s��
        ;bgWindowId���őO�ʕ\���ɂ��č�������z�f�B�X�v���C����ɍ��킹��
    	gsel bgWindowId, 2
    	bgWindowIdHandle = hwnd
    	MoveWindow@ bgWindowIdHandle, VIRTUAL_DISPLAY_X, VIRTUAL_DISPLAY_Y, VIRTUAL_DISPLAY_W, VIRTUAL_DISPLAY_H, TRUE
        ;�}�E�X�J�[�\�����N���X��ɕύX���Ă���
    	LoadCursor@ 0, MAKEINTRESOURCE
    	SetClassLong@ bgWindowIdHandle, GCL_HCURSOR, stat
        ;overlayWindowId���\���ɂ��Ă���
    	gsel overlayWindowId, -1
    	overlayWindowIdHandle = hwnd
    	MoveWindow@ overlayWindowIdHandle, 0, 0, 0, 0, 0

        // �}�E�X�I���̃��[�v
        selectFlg = FALSE       //�I�𒆂�TRUE
        selectBeginPos.0 = 0, 0 //�I���J�n���̃}�E�X���W(�X�N���[�����W�n)
        selectAreaRect.0 = 0, 0, 0, 0   //�I��͈͂�Rect(�X�N���[�����W�n)
        while (TRUE)
            // �L�[���͏�Ԃ�ǂݎ��(���}�E�X�{�^���͉������ςȂ������m)
            stick ky, STICK_LEFTBUTTON, 0

            // ���}�E�X�{�^���������Ă����ۂ̏���
            if (ky & STICK_LEFTBUTTON){
                if (selectFlg == FALSE){
                    // �I���n�߂̏��
                    selectBeginPos(0) = ginfo_mx
                    selectBeginPos(1) = ginfo_my
                    selectFlg = TRUE
                }else{
                    // �I�𒆂̏��
                    //selectAreaRect�𐏎��X�V���A���̌��ʂɂ����overlayWindowId��I��͈͏�ɕ\�������Ă���
                    selectAreaRect(0) = Min(selectBeginPos(0), ginfo_mx)
                    selectAreaRect(1) = Min(selectBeginPos(1), ginfo_my)
                    selectAreaRect(2) = Max(selectBeginPos(0), ginfo_mx) - selectAreaRect(0)
                    selectAreaRect(3) = Max(selectBeginPos(1), ginfo_my) - selectAreaRect(1)
                    gsel overlayWindowId, 2
    				MoveWindow@ overlayWindowIdHandle, selectAreaRect(0), selectAreaRect(1), selectAreaRect(2), selectAreaRect(3), TRUE
                 }
            }else :if ((ky & STICK_ESCBUTTON) || (ky & STICK_RIGHTBUTTON)){
                // Esc�L�[ or �E�}�E�X�{�^�����������ۂ̏���
                ; �I�[�o�[���C�E�B���h�E���\���ɂ���
                gsel overlayWindowId, -1
                ; bgWindowId�ɂ�����}�E�X�|�C���^�̐ݒ�����ɖ߂�
    			gsel bgWindowId
    			LoadCursor@ 0, IDC_ARROW
    			SetClassLong@ bgWindowIdHandle, GCL_HCURSOR, stat
                ; bgWindowId���\���ɂ���
    			gsel bgWindowId, -1
    			_break
            }else {
                // ���������Ă��炸�A�I�����O�����u�ԂȂ�΁A�I��͈͂ɂ��Ă̏������s��
                if (selectFlg) {
                    // �I����Ԃ�����
                    selectFlg = FALSE

                    // overlayWindowId��bgWindowId���\���ɂ���
                    ; �I�[�o�[���C�E�B���h�E���\���ɂ���
                    gsel overlayWindowId, -1
                    ; bgWindowId�ɂ�����}�E�X�|�C���^�̐ݒ�����ɖ߂�
        			gsel bgWindowId
        			LoadCursor@ 0, IDC_ARROW
        			SetClassLong@ bgWindowId, GCL_HCURSOR, stat
                    ; bgWindowId���\���ɂ���
        			gsel bgWindowId, -1

                    // �I�𕔕�����͂���̉�ʂ����o����
                    gsel windowId
                    if (marginCutFlg){
                        ;�����͈͂��Z�o����
                        dim tempRect, 4
                        tempRect(0) = selectAreaRect(0) - VIRTUAL_DISPLAY_X
                        tempRect(1) = selectAreaRect(1) - VIRTUAL_DISPLAY_Y
                        tempRect(2) = selectAreaRect(2)
                        tempRect(3) = selectAreaRect(3)
                        ;�܂����ӂ���i��
                        tempColor = _pget(tempRect(0), tempRect(1) + tempRect(3) / 2)
                        for px, tempRect(0), tempRect(0) + tempRect(2) / 2
                            if (_pget(px, tempRect(1) + tempRect(3) / 2) != tempColor) {
                                rectangles(0, 0) = px
                                _break
                            }
                        next
                        ;���ɉE��
                        tempColor = _pget(tempRect(0) + tempRect(2), tempRect(1) + tempRect(3) / 2)
                        for px, tempRect(0) + tempRect(2), tempRect(0) + tempRect(2) / 2, -1
                            if (_pget(px, tempRect(1) + tempRect(3) / 2) != tempColor) {
                                rectangles(2, 0) = px - rectangles(0, 0)
                                _break
                            }
                        next
                        ;���ɏ��
                        tempColor = _pget(tempRect(0) + tempRect(2) / 2, tempRect(1))
                        for py, tempRect(1), tempRect(1) + tempRect(3) / 2
                            if (_pget(tempRect(0) + tempRect(2) / 2, py) != tempColor) {
                                rectangles(1, 0) = py
                                _break
                            }
                        next
                        ;�Ō�ɉ���
                        tempColor = _pget(tempRect(0) + tempRect(2) / 2, tempRect(1) + tempRect(3))
                        for py, tempRect(1) + tempRect(3), tempRect(1) + tempRect(3) / 2, -1
                            if (_pget(tempRect(0) + tempRect(2) / 2, py) != tempColor) {
                                rectangles(3, 0) = py - rectangles(1, 0)
                                _break
                            }
                        next
                    }else{
                        rectangles(0, 0) = selectAreaRect(0) - VIRTUAL_DISPLAY_X
                        rectangles(1, 0) = selectAreaRect(1) - VIRTUAL_DISPLAY_Y
                        rectangles(2, 0) = selectAreaRect(2)
                        rectangles(3, 0) = selectAreaRect(3)
                    }

                    // ���o�ł��Ă��邩���m�F����B�ʖڂȂ�ēx�I��������
                    if (rectangles(2, 0) >= 99 && rectangles(3, 0) >= 59) {
                        gsel overlayWindowId, 2
        				MoveWindow@ overlayWindowIdHandle, rectangles(0, 0) + VIRTUAL_DISPLAY_X, rectangles(1, 0) + VIRTUAL_DISPLAY_Y, rectangles(2, 0), rectangles(3, 0), TRUE
        				dialog "�������擾�ł��Ă��܂����H", 2, "�m�F"
        				if (stat == 6) {
        					gsel overlayWindowId, -1
                            rectangleCount = 1
        					_break
        				}
                    }else {
                        dialog "�擾�Ɏ��s���܂���\n�ēx�I�����܂����H", 2, "�m�F"
        				if (stat == 7) {
        					gsel overlayWindowId, -1
        					_break
        				}
                    }
                    ;bgWindowId���őO�ʕ\���ɂ��č�������z�f�B�X�v���C����ɍ��킹��
                	gsel bgWindowId, 2
                	bgWindowIdHandle = hwnd
                	MoveWindow@ bgWindowIdHandle, VIRTUAL_DISPLAY_X, VIRTUAL_DISPLAY_Y, VIRTUAL_DISPLAY_W, VIRTUAL_DISPLAY_H, TRUE
                    ;�}�E�X�J�[�\�����N���X��ɕύX���Ă���
                	LoadCursor@ 0, MAKEINTRESOURCE
                	SetClassLong@ bgWindowIdHandle, GCL_HCURSOR, stat
                    ;overlayWindowId���\���ɂ��Ă���
                	gsel overlayWindowId, -1
                	overlayWindowIdHandle = hwnd
                	MoveWindow@ overlayWindowIdHandle, 0, 0, 0, 0, TRUE
                    ;�I��͈͂����Z�b�g
                    selectBeginPos.0 = 0, 0 //�I���J�n���̃}�E�X���W(�X�N���[�����W�n)
                    selectAreaRect.0 = 0, 0, 0, 0   //�I��͈͂�Rect(�X�N���[�����W�n)
                }
            }
            await 16
        wend

        // �J�����g�E�B���h�E�����ɖ߂�
        gsel currentWindowId
    return rectangleCount

    /**
     * ListMakerModule#CheckKanCollePos�̃R�[�h���΂ߓǂ݂��čČ�����
     * �܂�A�u�c���䂪���������v�u�N���b�v�g��1�s�N�Z�������̐F���Ⴄ���v�����Ă���
     */
    #defcfunc local isValidRect int windowId, int rectX, int rectY, int rectW, int rectH
        logmes("isValidRect")
        /* �c���䂪���������H */
        aspect_ratio_diff = absf(BASE_ASPECT_RATIO - 1.0 * rectW / rectH)
        if (aspect_ratio_diff > 0.021) :return FALSE

        /* �N���b�v�g��1�s�N�Z�������̐F���Ⴄ���H */
        // �ȑO�̃J�����g�E�B���h�EID���L��
        currentWindowId = ginfo_sel
        // �萔������
        ddim ratio, 5
    	ratio = 0.9, 0.82, 0.73, 0.5, 0.12
        // �e�ӂɂ��Ċm�F����
        gsel windowId
        result = FALSE
        while(TRUE)
            // ��g�ɂ��Ċm�F����
            flg1 = TRUE
            tempColor = _pget(rectX + ratio(0) * rectW, rectY - 1)
            for k, 1, length(ratio)
                if (_pget(rectX + ratio(k) * rectW, rectY - 1) != tempColor) {
                    flg1 = FALSE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            flg2 = FALSE
            for k, 0, length(ratio)
                if (_pget(rectX + ratio(k) * rectW, rectY) != tempColor) {
                    flg = TRUE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            // ���g
            flg1 = TRUE
            tempColor = _pget(rectX + ratio(0) * rectW, rectY + rectH)
            for k, 1, length(ratio)
                if (_pget(rectX + ratio(k) * rectW, rectY + rectH) != tempColor) {
                    flg1 = FALSE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            flg2 = FALSE
            for k, 0, length(ratio)
                if (_pget(rectX + ratio(k) * rectW, rectY + rectH - 1) != tempColor) {
                    flg = TRUE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            _break
            // ���g
            flg1 = TRUE
            tempColor = _pget(rectX - 1, rectY + ratio(0) * rectH)
            for k, 1, length(ratio)
                if (_pget(rectX - 1, rectY + ratio(k) * rectH) != tempColor) {
                    flg1 = FALSE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            flg2 = FALSE
            for k, 0, length(ratio)
                if (_pget(rectX, rectY + ratio(k) * rectH) != tempColor) {
                    flg = TRUE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            // �E�g
            flg1 = TRUE
            tempColor = _pget(rectX + rectW, rectY + ratio(0) * rectH)
            for k, 1, length(ratio)
                if (_pget(rectX + rectW, rectY + ratio(k) * rectH) != tempColor) {
                    flg1 = FALSE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            flg2 = FALSE
            for k, 0, length(ratio)
                if (_pget(rectX + rectW - 1, rectY + ratio(k) * rectH) != tempColor) {
                    flg = TRUE
                    _break
                }
            next
            if (flg1 == FALSE) :_break
            //
            result = TRUE
            _break
        wend
        // �J�����g�E�B���h�E�����ɖ߂�
        gsel currentWindowId
    return result

    /**
     * ListMakerModule#getKanCollePosAuto�ō̗p����Ă���A���S���Y��
     */
    #defcfunc local Auto int windowId, array rectangles
        startTime = timeGetTime@()

        /* �ȑO�̃J�����g�E�B���h�EID���L�� */
        currentWindowId = ginfo_sel

        /* �e��萔�������� */
        ;�Q�[����ʂƂ��ĔF������ŏ��T�C�Y
        MIN_GAME_WINDOW_WIDTH = int(MIN_ZOOM_RATIO * DEFAULT_GAME_WINDOW_WIDTH)
        MIN_GAME_WINDOW_HEIGHT = int(MIN_ZOOM_RATIO * DEFAULT_GAME_WINDOW_HEIGHT)
        ;�Q�[����ʂƂ��ĔF������ő�T�C�Y
        MAX_GAME_WINDOW_WIDTH = int(MAX_ZOOM_RATIO * DEFAULT_GAME_WINDOW_WIDTH)
        MAX_GAME_WINDOW_HEIGHT = int(MAX_ZOOM_RATIO * DEFAULT_GAME_WINDOW_HEIGHT)
        ;�ŏ��T�C�Y�̃E�B���h�E�̑傫��-1��STEP_COUNT�Ŋ������Ԋu�ŉ�f��ǂݎ��
        ;���Ⴆ�΁A���[�X�g�P�[�X��MIN_GAME_WINDOW_WIDTH=301�������Ƃ��Ă��A
        ;�@STEP_WIDTH��100�ɂȂ�B����ƁA������MIN_GAME_WINDOW_WIDTH�ȉ�ʂ�
        ;�@STEP_WIDTH�Ԋu�ň����ꂽ����̏�œ��������ꍇ�A��ʂ̏�ӂɏ��Ȃ��Ƃ�
        ;�@STEP_COUNT�{�̕���̐����ʂ邱�Ƃ��ۏ؂����
        STEP_COUNT = 2
        STEP_WIDTH = (MIN_GAME_WINDOW_WIDTH - 1) / STEP_COUNT
        STEP_HEIGHT = (MIN_GAME_WINDOW_HEIGHT - 1) / STEP_COUNT
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime

        /**
         * ��ӂ����o(PHASE1�EPHASE2����)
         * 1. STEP_WIDTH�s�N�Z�����Ƃɉ�f��ǂݎ��(Y=y��Y=y+1)
         * 2. �ȉ���2�z��̒��ŁA�uA1�`A{STEP_COUNT}�͑S�������F�v����
         *    �uB1�`B{STEP_COUNT}�̂ǂꂩ��Ax�ƈႤ�F�v�ł���ӏ���������
         *   Y=y  [..., A1, A2, .., A{STEP_COUNT}, ...]
         *   Y=y+1[..., B1, B2, .., B{STEP_COUNT}, ...]
         * STEP_WIDTH����L�v�Z���ɂ��Ă���̂́AY=y�ɂ����Ċm����
         * �u�ʒuA1�`A{STEP_COUNT}�v�̋�Ԃ̒������Q�[����ʂ̍ŏ�����(MIN_GAME_WINDOW_WIDTH)
         * �Ƃ��邽�߂ł���B�u���v����������Ȃ��Ǝ�肱�ڂ������������˂Ȃ��B
         * �܂��A�uB1�`B{STEP_COUNT}�̂ǂꂩ��Ax�ƈႤ�F�v�łȂ��ƁA�֐���`�ɂ�����
         * �u����1�s�N�Z�������ɁA�FA�ƈقȂ�F��1�s�N�Z���ȏ㑶�݂���v�𖞂����Ȃ�
         * �\����������(�X�e�b�v�T�[�`�Ȃ̂Łu�\���v�Œe���Ă���)�B
         *
         * �Ȃ��ArectYList1��Y=y�̗��y���W�ArectXList1�͂��ꂼ��ɂ�����A1��X���W�ł���
         */
        gsel windowId
        windowWidth = ginfo_winx
        windowHeight = ginfo_winy
        buffer 99, windowWidth, windowHeight
        chgbm@ 32
        mref vram, MREF_VRAM
        gcopy windowId, 0, 0, windowWidth, windowHeight
        dim rectXList1, 5 :dim rectYList1, 5 :rectList1Size = 0
        for y, 0, windowHeight - MIN_GAME_WINDOW_HEIGHT - 1
            // �܂��AY=y�̌�����������
            for x, 0, windowWidth - MIN_GAME_WINDOW_WIDTH - 1, STEP_WIDTH
                // �ӂ̐F�̌����擾
                tempColor = _pget2(x, y)
                // Y=y�̌�₽�肤�邩�𒲍����A�ʖڂȂ�X�L�b�v����
                flg = TRUE
                for x2, x + STEP_WIDTH, x + STEP_COUNT * STEP_WIDTH, STEP_WIDTH
                    if (_pget2(x2, y) != tempColor) {
                        flg = FALSE
                        _break
                    }
                next
                if (flg == FALSE) :_continue
                // Y=y+1�̕����`�F�b�N����
                flg = FALSE
                for x2, x, x + STEP_COUNT * STEP_WIDTH, STEP_WIDTH
                    if (_pget2(x2, y + 1) != tempColor) {
                        flg = TRUE
                        _break
                    }
                next
                if (flg) {
                    // ��₪���������̂Œǉ�
                    rectYList1(rectList1Size) = y
                    rectXList1(rectList1Size) = x
                    rectList1Size++
                }
            next
        next
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime

        /**
         * ��ӂ��m�F(PHASE3����)
         * A1�`A{STEP_COUNT}�������F�����m�F����
         */
        dim rectXList2, 5 :dim rectYList2, 5 :rectList2Size = 0
        for k, 0, rectList1Size
            tempColor = _pget2(rectXList1(k), rectYList1(k))
            flg = TRUE
            for x, rectXList1(k) + 1, rectXList1(k) + STEP_COUNT * STEP_WIDTH
                if (_pget2(x, rectYList1(k)) != tempColor) :flg = FALSE :_break
            next
            if (flg) {
                // ��₪���������̂Œǉ�
                rectXList2(rectList2Size) = rectXList1(k)
                rectYList2(rectList2Size) = rectYList1(k)
                rectList2Size++
            }
        next
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime

        /**
         * ���ӂ����o(PHASE4����)
         * ��ӂ̌��̍����𑖍����A���ӂƂȂ肤��ӂ��������邩�𒲍�����
         * �E��L��A1�s�N�Z����荶��STEP_WIDTH�s�N�Z���̊ԂɁA�u������W�v�̌�₪����ƍl������
         * �E�䂦�ɏ��Ԃ�1�s�N�Z���Â��Ă����A�c�����̕ӂ��������邩���`�F�b�N����
         * �E���ɂȂ肤�邩�̔���ɂ́A��ӂ̌����Ɠ������X�e�b�v�T�[�`��p����
         */
        dim rectXList3, 5 :dim rectYList3, 5 :rectList3Size = 0
        for k, 0, rectList2Size
            tempColor = _pget2(rectXList2(k), rectYList2(k))
            for x, rectXList2(k) - 1, Max(rectXList2(k) - STEP_WIDTH, -1), -1
                if (_pget2(x, rectYList2(k)) != tempColor) :_break
                // X=x�̌�₽�肤�邩�𒲍����A�ʖڂȂ�X�L�b�v����
                flg = TRUE
                for y, rectYList2(k) + STEP_HEIGHT, Min(rectYList2(k) + STEP_HEIGHT * STEP_COUNT, windowHeight), STEP_HEIGHT
                    if (_pget2(x, y) != tempColor) :flg = FALSE :_break
                next
                if (flg == FALSE) :_continue
                // X=x+1�̕����`�F�b�N����
                flg = FALSE
                for y, rectYList2(k) + STEP_HEIGHT, Min(rectYList2(k) + STEP_HEIGHT * STEP_COUNT, windowHeight), STEP_HEIGHT
                    if (_pget2(x + 1, y) != tempColor) :flg = TRUE :_break
                next
                if (flg) {
                    // ��₪���������̂Œǉ�
                    rectXList3(rectList3Size) = x
                    rectYList3(rectList3Size) = rectYList2(k)
                    rectList3Size++
                }
            next
        next
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime

        /**
         * ���ӂ��m�F(PHASE5����)
         * ���ӂ������F�����m�F����
         */
        dim rectXList4, 5 :dim rectYList4, 5 :rectList4Size = 0
        for k, 0, rectList3Size
            tempColor = _pget2(rectXList3(k), rectYList3(k))
            flg = TRUE
            for y, rectYList3(k) + 1, rectYList3(k) + STEP_COUNT * STEP_HEIGHT
                if (_pget2(rectXList3(k), y) != tempColor) :flg = FALSE :_break
            next
            if (flg) {
                // ��₪���������̂Œǉ�
                rectXList4(rectList4Size) = rectXList3(k)
                rectYList4(rectList4Size) = rectYList3(k)
                rectList4Size++
            }
        next
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime

        /**
         * �E�ӁE���ӂ��m�F���A���ɒǉ�����
         */
        ddim ratio, 5
        ratio = 0.9, 0.82, 0.73, 0.5, 0.12
        dim rectangles, 4 :rectangleSize = 0
        for k, 0, rectList4Size
            // x�͘g�̉E��x���W
            for x, rectXList4(k) + MIN_GAME_WINDOW_WIDTH + 1, windowWidth
                w = x - rectXList4(k) - 1
                // �g�̉E��y���W���Z�o
                y = Min(rectYList4(k) + BASE_ASPECT_RATIO * w + 1, windowHeight - 1)
                h = y - rectYList4(k) - 1
                // �g�̐F���擾
                tempColor = _pget2(rectXList4(k), rectYList4(k))
                // ����(�E��)
                flg1 = TRUE
                for j, 0, length(ratio)
                    if (_pget2(x, rectYList4(k) + ratio(j) * h + 1) != tempColor) {
                        flg1 = FALSE
                        _break
                    }
                next
                if (flg1 == FALSE){
                    _continue
                }
                flg2 = FALSE
                for j, 0, length(ratio)
                    if (_pget2(x - 1, rectYList4(k) + ratio(j) * h + 1) != tempColor) {
                        flg2 = TRUE
                        _break
                    }
                next
                if (flg2 == FALSE) {
                    _continue
                }
                // ����(����)
                flg1 = TRUE
                for j, 0, length(ratio)
                    if (_pget2(rectXList4(k) + ratio(j) * w + 1, y) != tempColor) {
                        flg1 = FALSE
                        _break
                    }
                next
                if (flg1 == FALSE) {
                    _continue
                }
                flg2 = FALSE
                for j, 0, length(ratio)
                    if (_pget2(rectXList4(k) + ratio(j) * w + 1, y - 1) != tempColor) {
                        flg2 = TRUE
                        _break
                    }
                next
                if (flg2 == FALSE) {
                    _continue
                }
                // �ǋL
                rectangles(0, rectangleSize) = rectXList4(k) + 1, rectYList4(k) + 1, w, h
                rectangleSize++
            next
        next
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime

        /* �J�����g�E�B���h�E�����ɖ߂� */
        gsel currentWindowId
        endTime = timeGetTime@()
        logmes "" + (endTime - startTime) + "ms"
        startTime = endTime
    return rectangleSize
#global

#if 1
    title "���W�擾�����̃e�X�g"
    buffer 1
    picload "���W�F���e�X�g�p-2.png"

    /*// �A���S���Y��1
    dim rectangles //�����Ă��������x�������Ɏg�p
    gsel 1 :count = SemiAuto@SearchKanCollePos(1, rectangles, 1059, 1099) :gsel 0
    mes "�y�A���S���Y��1�z"
    gosub *show_result

    // �A���S���Y��2
    gsel 1 :count = Auto@SearchKanCollePos(1, rectangles) :gsel 0
    mes "�y�A���S���Y��3�z(" + elapsedTime + "ms)"
    gosub *show_result*/

    repeatTime = 10
    startTime = timeGetTime()
    for k, 0, repeatTime
        gsel 1 :gsel 0
    next
    elapsedTime1 = timeGetTime() - startTime
    startTime = timeGetTime()
    for k, 0, repeatTime
        gsel 1 :count = Auto@SearchKanCollePos(1, rectangles) :gsel 0
    next
    elapsedTime2 = timeGetTime() - startTime

    mes "�y�A���S���Y��3�z(" + (1.0 * (elapsedTime2 - elapsedTime1) / repeatTime) + "ms)"

    //gsel 1 :count = Auto@SearchKanCollePos(1, rectangles) :gsel 0

    gosub *show_result
    stop

    *show_result
        mes "���F" + count
        sdim textBuffer, 4096
        for k, 0, count
            x = rectangles(0, k)
            y = rectangles(1, k)
            w = rectangles(2, k)
            h = rectangles(3, k)
            textBuffer += strf("(%d,%d)-%dx%d,", x, y, w, h)
        next
        mes "���F" + textBuffer
    return
#endif
