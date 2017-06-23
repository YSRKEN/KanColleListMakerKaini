//�����ĉ��B�Ŕz�z����Ă���MemoryMapModule.as��HSP3utf�p�ɉ���
//�z�z�� : http://www.tvg.ne.jp/menyukko/cauldron/hmmemorymap.html
//�쐬�� : �ߓ��a����
//���ώ� : kanahiron

/*====================================================================
                      ���L���������g�����W���[��
HSP3.0          2005.11.19
                2006. 1. 7  �V�K�쐬
HSP3.22         2011. 4. 7  �ď���
HSP3.3��2             5.21  ���W���[���č\���A���̕ύX
----------------------------------------------------------------------
���L�������쐬(HSP�W������)
    newmod  ���W���[���ϐ�, ���W���[����, ���L��, Size
        ���W���[���ϐ�  �ȍ~�̑���ΏۂɂȂ郂�W���[���^�ϐ�
        ���W���[����    MemoryMapModule
        ���L��          �������̖��O(�������O���w�肷�邱�Ƃŋ��L�ł���)
        Size            �������̊m�ۃT�C�Y(Byte�P��)
        stat            0(���s) or 1(�V�K�쐬����) or 2(2�ڈȍ~�̍쐬)

���L�������폜(HSP�W������)
    delmod  ���W���[���ϐ�
        ���W���[���ϐ�  �폜�Ώۂ̃��W���[���^�ϐ�

�ϐ��ɋ��L�����������蓖�Ă�
    Mmry_DupMemory  ���W���[���ϐ�, �ϐ���, �ϐ��̌^�w��
        ���W���[���ϐ�  �Ώۂ̃��W���[���^�ϐ�
        �ϐ���          ���L�����������蓖�Ă�ϐ�
                        ���̕ϐ�������E�Q�Ƃ̑ΏۂɂȂ�
                        (dup���Ă��邾���Ȃ̂Ŏ����g���Ȃǂ͌���)
        �ϐ��̌^�w��    �ȗ��E0�̏ꍇ�́Aint�^
        stat            �������̊m�ۃT�C�Y(Byte)����������

====================================================================*/
#ifndef MemoryMapModuleIncluded
#define MemoryMapModuleIncluded
#module MemoryMapModule MapHandle, StartPos, iSize
#uselib "KERNEL32.dll"
#func CreateFileMapping "CreateFileMappingW" int, nullptr, int, nullptr, int, wstr   ;stat=handle
;�t�@�C���}�b�s���O�I�u�W�F�N�g�쐬 -1:���z���, 0:����, 4:�ǂݏ���, 0:size��, SIZE, NAME
#func CloseHandle "CloseHandle" int             ;�I�u�W�F�N�g�n���h�����N���[�Y����
#func MapViewOfFile "MapViewOfFile" int, int, nullptr, nullptr, nullptr     ;stat=�J�n�ʒu
;���z��Ԃւ̃}�b�s���O HANDLE, 2:�ǂݏ���, 0:Offset��, 0:Offset��, 0:�S�̎w��
#func UnmapViewOfFile "UnmapViewOfFile" int     ;�}�b�s���O����     �J�n�ʒu
#func GetLastError "GetLastError"   ;�G���[�R�[�h�擾

#modinit str n, int s   ;���O�Ƒ傫��
    MapHandle  = 0  : StartPos = 0  : iSize = s ;���W���[���̕ϐ�����

    CreateFileMapping -1, 4, s, n       ;�}�b�s���O�I�u�W�F�N�g�쐬
    MapHandle = stat
    if MapHandle {
        GetLastError  : ib = stat       ;�쐬���̏�������Ă���
        MapViewOfFile MapHandle, 2      ;�}�b�s���O
        StartPos = stat
    }

    if MapHandle == 0 | StartPos == 0   : return 0  ;���s
    if ib != 183                        : return 1  ;���쐬
    return 2                                        ;�쐬����(�Q�ڈȍ~)

#modterm
    if StartPos   : UnmapViewOfFile StartPos
    if MapHandle  : CloseHandle     MapHandle
    return

#modfunc Mmry_DupMemory array a, int t
    if StartPos == 0  : return 0    ;���W���[���쐬�Ŏ��s���Ă���
    if t == 0  : ib = 4  : else  : ib = t
    dupptr a, StartPos, iSize, ib
    return iSize

; http://www.tvg.ne.jp/menyukko/
; Copyright(C) 2005-2012 �ߓ��a All rights reserved.
#global
#endif