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

#global
