#ifndef chgbm
	#include "ChangeBitmapDepth.as"
#endif

// listMakerModule
// ���W�擾�ȂǎG���ȋ@�\���l�܂������W���[��(��낵���Ȃ�)

//����
// init_ListMakerMod array p1
// ���W���[���̏�����
// p1 - �v�f��4��int�^�z�� �f�B�X�v���C���ׂĂ�1���̉��z�f�B�X�v���C�Ɍ����Ă��Ƃ��̍���x,y ��w, ����h
//
// getKanCollePos		�}�E�X�I�[�o�[�Ŋ͂���̍��W���擾����(�����擾����2)
// �����Ƃ��イ
// KanCollePosManual	�h���b�O�Ŋ͂���̍��W���擾����(�蓮�擾)
// �����Ƃ��イ
// SelectCapturePos		�c�C�[�g�E�B���h�E����Ăяo�����L���v�`���͈͎擾
// �����Ƃ��イ
#module "ListMakerModule"

#uselib	"user32.dll"
#func MoveWindow "MoveWindow" int, int, int, int, int, int
#func LoadCursor "LoadCursorW" int, int
#func SetClassLong "SetClassLongW" int, int, int

#define ctype GetRGB(%1, %2, %3, %4, %5) %1((%3-1-%5)*%2 + %4 \ %2)
#define TRUE 1
#define FALSE 0

//CompArrays �z�񓯎m���r���S�Ĉ�v����ΐ^��Ԃ�
#define CompArrays(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) != %3(cnt){%1 = FALSE: break}: loop
//CompArrays2 �z�񓯎m���r���S�Ĉ�v���Ȃ���ΐ^��Ԃ�
#define CompArrays2(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) == %3(cnt){%1 = FALSE: break}: loop
//CompArrayAndValue �z��ƒl���r���S�Ĉ�v����ΐ^��Ԃ�
#define CompArrayAndValue(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) != %3{%1 = FALSE: break}: loop
//CompArrayAndValue2 �z��ƒl���r���S�Ĉ�v���Ȃ���ΐ^��Ԃ�
#define CompArrayAndValue2(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) == %3{%1 = FALSE: break}: loop


#deffunc init_ListMakerMod array disinfo_

	dim tsscap, 4
	dim mxy, 2
	dim mxy_, 2
	dim mwh, 2
	dim sti
	dim cliflag
	dim ccolor, 3
	dim nid
	dim disinfo, 4

	repeat 4
		disinfo(cnt) = disinfo_(cnt)
		logmes ""+disinfo(cnt)
	loop

return

#deffunc SelectCapturePos int imageid1, array sscap, int imageid3, int imageid4, int marginCutFlg

	nid = ginfo(3)
	tsscap(0) = 0, 0, 0, 0
	sscap(0) = 0, 0, 0, 0
	mxy(0) = 0, 0
	mxy_(0) = 0, 0
	mwh = 0, 0
	cliflag = 0
	ccolor(0) = 0, 0, 0

	//imageId3�����C���[�h�E�B���h�E
	gsel imageid4, 2 //�w�i
	imagehwnd4 = hwnd
	MoveWindow imagehwnd4, disinfo(0), disinfo(1), disinfo(2), disinfo(3), 1
	LoadCursor 0, 32515
	SetClassLong imagehwnd4, -12, stat

	gsel imageid3, -1
	imagehwnd3 = hwnd
	MoveWindow imagehwnd3, 0, 0, 0, 0, 0

	repeat

		ginfo0 = int(ginfo(0))
		ginfo1 = int(ginfo(1))

		stick sti, 256, 0
		if sti = 256{
			if cliflag = 0{
				cliflag = 1
				mxy_(0) = ginfo0
				mxy_(1) = ginfo1

			}
			if cliflag = 1{

				mwh(0) = abs(mxy_(0) - ginfo0)
				mwh(1) = abs(mxy_(1) - ginfo1)

				if mxy_(0) < ginfo0 {
					mxy(0) = mxy_(0)
				} else {
					mxy(0) = ginfo0
				}

				if mxy_(1) < ginfo1 {
					mxy(1) = mxy_(1)
				} else {
					mxy(1) = ginfo1
				}
				gsel imageid3, 2
				MoveWindow imagehwnd3, mxy(0), mxy(1), mwh(0), mwh(1), 1

			}
		}

		if (sti = 0 & cliflag = 1){
			cliflag = 0

			//
			gsel imageid3, -1
			gsel imageid4
			LoadCursor 0, 32512
			SetClassLong imagehwnd4, -12, stat
			gsel imageid4, -1

			////////////////////////////////////////
			gsel imageid1


			if (marginCutFlg) {

				tsscap(0) = mxy(0) - disinfo(0)
				tsscap(1) = mxy(1) - disinfo(1)
				tsscap(2) = mxy(0) + mwh(0) - disinfo(0)
				tsscap(3) = mxy(1) + mwh(1) - disinfo(1)

				pget tsscap(0), tsscap(1)+mwh(1)/2
				ccolor(0) = ginfo_r, ginfo_g, ginfo_b
				repeat mwh(0)/2, 1
					ccnt = cnt
					pget tsscap(0)+cnt, tsscap(1)+mwh(1)/2
					if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
						sscap(0) = tsscap(0)+cnt + disinfo(0)
						break
					}
				loop

				pget tsscap(2), tsscap(3)-mwh(1)/2
				ccolor(0) = ginfo_r, ginfo_g, ginfo_b
				repeat mwh(0)/2, 1
					ccnt = cnt
					pget tsscap(2)-cnt, tsscap(3)-mwh(1)/2
					if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
						sscap(2) = tsscap(2)-cnt + disinfo(0)+1
						break
					}
				loop

				pget tsscap(0)+mwh(0)/2, tsscap(1)
				ccolor(0) = ginfo_r, ginfo_g, ginfo_b
				repeat mwh(1)/2
					ccnt = cnt
					pget tsscap(0)+mwh(0)/2, tsscap(1)+cnt
					if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
						sscap(1) = tsscap(1)+cnt + disinfo(1)
						break
					}
				loop

				pget tsscap(2)-mwh(0)/2, tsscap(3)
				ccolor(0) = ginfo_r, ginfo_g, ginfo_b
				repeat mwh(1)/2
					ccnt = cnt
					pget tsscap(2)-mwh(0)/2, tsscap(3)-cnt
					if (ccolor(0) != ginfo_r) | (ccolor(1) != ginfo_g) | (ccolor(2) != ginfo_b) {
						sscap(3) = tsscap(3)-cnt+1 + disinfo(1)
						break
					}
				loop

			} else {
				sscap(0) = mxy(0)
				sscap(1) = mxy(1)
				sscap(2) = mxy(0) + mwh(0)
				sscap(3) = mxy(1) + mwh(1)
				logmes sscap(0)
				logmes sscap(1)
				logmes sscap(2)
				logmes sscap(3)
			}
			/////////////////////

			sscapwh(0) = sscap(2)-sscap(0), sscap(3)-sscap(1)
			if (sscapwh(0) >= 4 && sscapwh(1) >= 4){

				gsel imageid3, 2
				MoveWindow imagehwnd3, sscap(0), sscap(1), sscap(2)-sscap(0), sscap(3)-sscap(1), 1

				dialog "���͈̔͂��L���v�`�����܂����H", 2, "�m�F"
				if (stat == 6){
					gsel imageid3, -1
					break
				}
			} else {
				dialog "�I��͈͂����������邩�]���l�߂Ɏ��s���܂���\n�ēx�I�����܂����H", 2, "�m�F"
				if (stat == 7){
					sscap(0) = 0, 0, 0, 0
					gsel imageid3, -1
					break
				}
			}

			gsel imageid4, 2
			MoveWindow imagehwnd4, disinfo(0), disinfo(1), disinfo(2), disinfo(3), 1
			LoadCursor 0, 32515
			SetClassLong imagehwnd4, -12, stat
			//gsel imageid5, -1

			tsscap(0) = 0, 0, 0, 0
			sscap(0) = 0, 0, 0, 0
			mxy(0) = 0, 0
			mxy_(0) = 0, 0
			mwh = 0, 0
			MoveWindow imagehwnd3, 0, 0, 0, 0, 1
		}

		if (sti == 128 || sti == 512){
			gsel imageid3, -1
			gsel imageid4
			LoadCursor 0, 32512
			SetClassLong imagehwnd4, -12, stat
			gsel imageid4, -1
			break
		}

		redraw 1
		await 16
	loop

	//gsel imageid5, -1
	gsel nid

return


#deffunc CheckKanCollePos int imageid, int posX, int posY, int sizeX, int sizeY

	nid = ginfo(3)

	ddim ratio, 5
	ratio = 0.9, 0.82, 0.73, 0.5, 0.12

	po = posX, posY
	po2 = -1, -1

	stX = int(1.0*BASE_SIZE_W*ZOOM_MIN)-1
	stY = int(1.0*BASE_SIZE_H*ZOOM_MIN)-1

	pccX = 0
	pccY = 0
	dim tccX, 5
	dim tccY, 5
	flagX = 0
	flagY = 0
	as = 0.0

	topCnt = 0

	success = FALSE

	gsel imageid, 0

	repeat BASE_SIZE_W*ZOOM_MAX, stY
		topCnt = cnt
		x = cnt
		y = int(BASE_ASPECT_RATIO * cnt + 0.5)

		pget po(0)+ topCnt -1, po(1) + ratio(0)*y
		pccX = (ginfo_b << 16 | ginfo_g << 8 | ginfo_r)

		pget po(0) + ratio(0)*x, po(1)+y -1
		pccY = (ginfo_b << 16 | ginfo_g << 8 | ginfo_r)

		repeat 5
			pget po(0)+ topCnt, po(1) + ratio(cnt)*y
			tccX(cnt) = (ginfo_b << 16 | ginfo_g << 8 | ginfo_r)

			pget po(0) + ratio(cnt)*x, po(1)+y
			tccY(cnt) = (ginfo_b << 16 | ginfo_g << 8 | ginfo_r)

			//�f�o�b�O�p ������R�����g�A�E�g����Ɛ�������̈ꕔ������
			//color 255, 0, 0
			//pset po(0) + ratio(cnt)*x, po(1)+y
			//pset po(0)+ topCnt, po(1) + ratio(cnt)*y
		loop
		CompArrayAndValue flagX, tccX, tccX(0)
		CompArrayAndValue flagY, tccY, tccY(0)

		if ( flagX && flagY ){
			//�f�o�b�O�p
			//title strf("%4d %4d %4d %4d %4d %4d %4d %f", x, y, pccX, tccX(0), pccY, tccY(0), topCnt, absf(1.0*(y)/(x) - 0.6))
			//wait 120
			if ( pccX != tccX(0) && pccY != tccY(0)){
				as = absf( BASE_ASPECT_RATIO - 1.0*y/x )
				if (as <= 0.021){
					po2(0) = x + po(0)
					po2(1) = y + po(1)
					success = TRUE
					break
				}

			}
		}
		await
	loop

	gsel nid
return ( success && (po2(0)-po(0)) == sizex )

#global
