/*=======================================================================================================
                                                                    �摜�t�@�C���ɂ��낢�낷�郂�W���[��
HSP3.22         2010.12.30  �V�K����
                2011. 1. 4  �ǉ��FImgM_GetSize JPG-$C4����
                        12  �ǉ��FImgM_SetImageData (�b��)
                        16  �C���FJpeg End�}�[�J�[�����΍�
                            ����FImgF_GdipPicload , ImgM_GdipPicload , ImgM_GdipGzoom
                            �ڐA�FImgM_CalcFitSize
                        27  �C���FJpeg MarkerSize�s��(NikonD700�o�O�H)�΍�
HSP3.3��1             2.16  �C���FJpeg �j���摜 �΍�
HSP3.22(��)           4. 7  ���n�B
                      5. 1  �C���FImgM_CalcFitSize 0����
HSP3.3��3             7.12  ����FImgM_GdipJpgsave
HSP3.3RC1(�����łĂ�̂�)   9.15    ����FImgM_GdipRotateFlip
                     11. 3  ��L���W���[���S�Ĕj��(Next Stage ��)

                                                    �摜�t�@�C�����샂�W���[���Q�� �� �摜���H���W���[��
HSP3.3          2011.11. 3  [����]ImgF_PicloadEx
                     12.20  [����]ImgF_GetPicSize,ImgF_GetFormat,ImgP_CalcFitSize,ImgP_gzoom
                2012. 1. 9  [�ڐA](�R�s�y)ImgF_jpgsave,ImgP_RotateFlip
                      1.11  �̍فA���W���[����
HSP3.4��4       2014. 6. 7  �ӂ��̃��W���[���𓝍��AHDL�Ή�
                �`    6.28  [�p�~](�����֐�)_ImgF_LoadAndSigCheck �� ImgF_GetFormat�ɓ���
                            [����](�����֐�)ImgM_CreateH , ImgM_CloseH
                            [�ҏW]ImgF_PicloadEx ������Mode2�A���Ȃ����Č����Ă��A���t�@�擾
                            [�ҏW]ImgP_gzoom �������ɕ��u���Ă��炵��orz
                            [����]ImgP_Memsave , ImgP_FilterPastel/Vivid/Nega/SubAbs , ImgP_grotate
%--------------------------------------------------------------------------------------------------------
%dll        ;                   HDL(HSP Document Library)�Ή��t�@�C���Bcommon�ɕ��荞�ނ����őΉ����܂��B
�a�ސ����W���[��
%port       ;   DLL�⃂�W���[����ʓr�p�ӂ���K�v�͂���܂���Win32API���g�p���܂��̂Ŋ��Ɉˑ����܂��B
Win
%author     ;                                       Copyright (C) 2010-2014 �ߓ��a All rights reserved.
�ߓ��a
%url        ;                                   �ŐV�ł͂����炩��B�Ȃ񂩂Ă��Ɓ[WEB Site�w�����ĉ��B�x
http://www.tvg.ne.jp/menyukko/
%note       ;                                                                           �W���t�@�C����
ImageModule2.hsp ���C���N���[�h����B
WinXP�ȍ~�̊���GDI+��W���������Ă܂��B
; com ���g�p���܂��B
%======================================================================================================*/

#ifndef ImageModule2Included
#define ImageModule2Included
#module ImageModule2

#uselib "gdiplus"       ; ���� �ӂ�����ӂ�����[-. orz
; �� Gdiplus�̊�b --------------------------------------------------------------------------------------
#func GdiplusStartup    "GdiplusStartup"    var, var, nullptr
    ; �����܂��Ȃ�                              [Rtn Token(LoadHandle?)][OpenPrm Struct][Output Struct]
#func GdiplusShutdown   "GdiplusShutdown"   int                 ; �����񂫂�
; �� Image��Bitmap�Ƃ��̎��� ----------------------------------------------------------------------------
;   [Stream]��comobj�^�ł�OK!�A�ł�com�ɂ��Ă���n���K�v�����邵�Ǘ����ʓ|�ɂȂ��B
;   �ۑ��p�����[�^�͕s�v�Ȃ�nullptr��int�Œ�`���Ă����΂̂��̖ʓ|�͖����񂾂��ǂ�...
#func GdipLoadImageFromFile         "GdipLoadImageFromFile"     wstr, var   ; �������ł����̂Ŗ��p�ł��B
#func GdipLoadImageFromStream       "GdipLoadImageFromStream"   int, var    ; ��[Stream][Rtn Image]
#func GdipSaveImageToFile           "GdipSaveImageToFile"       int, wstr, var, var
    ; ���摜���t�@�C���ۑ�                                          [Image][FileName][DataFormat][Param]
#func GdipSaveImageToStream         "GdipSaveImageToStream"     int, int, var, var
    ; ���摜��ϐ��ɕۑ�                                            [Image][Stream][DataFormat][Param]
#func GdipCreateBitmapFromGdiDib    "GdipCreateBitmapFromGdiDib" int, int, var
    ; ��HSP��ʂ���Bitmap����                    [BitmapInfo(bmscr.6)][BitmapData(bmscr.5)][Rtn Bitmap]
#func GdipCloneBitmapAreaI          "GdipCloneBitmapAreaI"      int, int, int, int, int, int, var
    ; ��Bitmap����Bitmap����                    [x][y][Width][Height][PixelFormat][Bitmap][Rtn NewBitmap]
#func GdipGetImageWidth             "GdipGetImageWidth"         int, var    ; ��[Image][Rtn Width]
#func GdipGetImageHeight            "GdipGetImageHeight"        int, var    ; ��[Image][Rtn Height]
#func GdipImageRotateFlip           "GdipImageRotateFlip"       int, int    ; ��[Image][FlipType]
#func GdipDisposeImage              "GdipDisposeImage"          int         ; ��Image�j��
; �� ImageAttributes�Ƃ䂩���Ȓ��Ԃ��� ------------------------------------------------------------------
#func GdipCreateImageAttributes         "GdipCreateImageAttributes" var     ; ��[Rtn ImageAttr]
#func GdipSetImageAttributesColorMatrix "GdipSetImageAttributesColorMatrix" \
                                                                    int, int, int, var, nullptr, nullptr
    ; ���F�}�g�� [ImageAttr][ColorAdjustType][TRUE=SetCMat/FALSE=ClearCMat][ColorMat][GrayMat][GrayFlag]
#func GdipDisposeImageAttributes "GdipDisposeImageAttributes" int
; �� Matrix�̃W���P�ɂ���C�Ȃ��f�荞�ލ���w ------------------------------------------------------------
#func GdipCreateMatrix          "GdipCreateMatrix"      var                 ; ������B
#func GdipDeleteMatrix          "GdipDeleteMatrix"      int                 ; ���̂Ă��B
#func GdipTranslateMatrix       "GdipTranslateMatrix"   int, float, float, int
    ; ��                                                                    [Matrix][OffsetX][Y][Order]
#func GdipRotateMatrix          "GdipRotateMatrix"      int, float, int     ; ��[Matrix][angle][Order]
; �� Graphics���s�� -------------------------------------------------------------------------------------
#func GdipCreateFromHDC         "GdipCreateFromHDC"     int, var            ; ��hdc����Graphics����
#func GdipDeleteGraphics        "GdipDeleteGraphics"    int                 ; ��Graphics�j��
#func GdipSetWorldTransform     "GdipSetWorldTransform" int, int
    ; ��Graphics��Matrix�K�p                             [Graphics][Matrix]
; �� Image��Graphics�̕`��֌W(���Ȃ�ǂ�ǂ�) ----------------------------------------------------------
#func GdipDrawImageI            "GdipDrawImageI"        int, int, int, int  ; ��[Graphics][Image][x][y]
#func GdipDrawImageRectI        "GdipDrawImageRectI"    int, int, int, int, int, int
    ; ��                                                        [Graphics][Image][x][y][Width][Height]
#func GdipDrawImageRectRectI    "GdipDrawImageRectRectI" \
                        int, int, int, int, int, int, int, int, int, int, int, int, nullptr, nullptr
    ; ��Graphics��Image��]��(�g�k�t��)
                    ; [Graphics][Image][Paste x][y][Width][Height][base x][y][Width][Height]
                    ;                               [UnitPixel][ImageAttributes][Callback][CallbackData]

; �� �萔�Ȃ�
; GdipCloneBitmapAreaI [PixelFormat]
#const PixelFormatIndexed           $00010000   ; Indexes into a palette
#const PixelFormatGDI               $00020000   ; Is a GDI-supported format
#const PixelFormatAlpha             $00040000   ; Has an alpha component
#const PixelFormatCanonical         $00200000 
#const PixelFormat8bppIndexed        3|( 8<<8)|PixelFormatGDI|PixelFormatIndexed
#const PixelFormat24bppRGB           8|(24<<8)|PixelFormatGDI
#const PixelFormat32bppARGB         10|(32<<8)|PixelFormatGDI|PixelFormatAlpha|PixelFormatCanonical
; GdipImageRotateFlip [FlipType]
    ; 0 = RotateNoneFlipNone    Rotate180FlipXY     ; 4 = RotateNoneFlipX   Rotate180FlipY
    ; 1 = Rotate90FlipNone      Rotate270FlipXY     ; 5 = Rotate90FlipX     Rotate270FlipY
    ; 2 = Rotate180FlipNone     RotateNoneFlipXY    ; 6 = Rotate180FlipX    RotateNoneFlipY
    ; 3 = Rotate270FlipNone     Rotate90FlipXY      ; 7 = Rotate270FlipX    Rotate90FlipY
; GdipSetImageAttributesColorMatrix [enum ColorAdjustType]
    ; ColorAdjustTypeDefault, ColorAdjustTypeBitmap, ColorAdjustTypeBrush, ColorAdjustTypePen,
    ; ColorAdjustTypeText, ColorAdjustTypeCount, ColorAdjustTypeAny/*Reserved*/

#uselib "kernel32.dll"      ; ���� �J�[�l��
#func GlobalAlloc   "GlobalAlloc"   int, int
#func GlobalFree    "GlobalFree"    int
#func GlobalLock    "GlobalLock"    int
#func GlobalUnlock  "GlobalUnlock"  int
#func GlobalSize    "GlobalSize"    int
#define GMEM_MOVEABLE      2
#define GMEM_ZEROINIT     64
#define GMEM_SHARE      8192
#define GHND              66

#uselib "Ole32.dll"         ; ���� ����
#func CreateStreamOnHGlobal "CreateStreamOnHGlobal" int, int, var   ; ��Create Stream With GlobalMemory
        ; [GlobalHandle]�O���[�o���������̃n���h��(0�ɂ���ƃX�g���[���������ŗp�ӂ��Ă����)
        ; [DelOnRelease]1�ɂ���ƃX�g���[���̉�����ɃO���[�o�����������폜���Ă����...�炵��
        ; [Rtn hStream] �o�����������X�g���[���̃n���h�����󂯎��ϐ�
#func GetHGlobalFromStream  "GetHGlobalFromStream"  int, var  ; ���X�g���[���̎��O���[�o����������q��

#uselib "gdi32.dll"         ; ���� gdi
#func BitBlt                    "BitBlt"                    int, int, int, int, int, int, int, int, int
#func SelectObject              "SelectObject"              int, int
#func CreateCompatibleBitmap    "CreateCompatibleBitmap"    int, int, int
#func DeleteObject              "DeleteObject"              int
#func CreateCompatibleDC        "CreateCompatibleDC"        int
#func DeleteDC                  "DeleteDC"                  int
; BitBlt�̃��[�h
#define SRCPAINT    $00EE0086       ; �R�s�[���ƃR�s�[���or
#define SRCCOPY     $00CC0020       ; �P���R�s�[
#define PATINVERT   $005A0049       ; �u���V�Ƃ̔r���I�_���a
#define DSTINVERT   $00550009       ; �l�K�|�W���]

; GDI+�𒆐S�Ƀn���h���Ǘ����ʓ|�Ȃ̂Ŏ����I�ɂ��C�����߂�����Ă݂�
#enum ImchMode_Group01 = 0
#enum   ImchMode_GdipOpenDll        ; GDI+�̖{��(�������ɔ������g�p��)
#enum ImchMode_Group02
#enum   ImchMode_ImageFromStream    ; hImage from hStream       hStream
#enum   ImchMode_ImageFromWindow    ; hImage from CurrentWindow �����쎞��bb�g�p�B
#enum   ImchMode_ImageFromImage     ; hImage from hImage        hImage, pos x, pos y, width, height, pf
#enum ImchMode_Group03
#enum   ImchMode_GraphicFromWindow  ; hGraphic from CurrentWindow
#enum ImchMode_Group04
#enum   ImchMode_Matrix             ; hMatrix
#enum ImchMode_Group05
#enum   ImchMode_ImageAttributes    ; hImageAttr
#enum ImchMode_Group06
#enum   ImchMode_StreamWithGM       ; hStream from hGlobal      hGlobal ; ���������bb�g�p�B
#enum ImchMode_Group07
#enum   ImchMode_CompBitmapObject   ; hBitmap                   hdc, sizeX, sizeY
#enum ImchMode_Group08
#enum   ImchMode_CompDC             ; hDC
#enum ImchMode_Group09
#enum   ImchMode_GlobalAlloc        ; hGlobal                   size
#enum ImchMode_Group10

#define ImchMode_UseGdipFirst   ImchMode_Group02    ; GDI+���g�p����ŏ��̃O���[�v
#define ImchMode_UseGdipLast    ImchMode_Group06    ; GDI+���g�p���Ȃ��ŏ��̃O���[�v

;   ImchHL  �n���h���X�g�b�N�p���֐����g���񂵂̕ϐ�(HL:HandleList)
;       (0)���݂̃X�g�b�N�n���h����  (1)GDI+���p���̃g�[�N�����������t���O  (2�`6)���R�̈�
;       (7)CreateH�Ŏg���e���|��  (8�`����)ImchMode_xxx  (9�`�)handle

#deffunc ImgM_CreateH int m, int a, int b, int c, int d, int e, int f
    ImchHL(7) = ImchHL * 2 + 9      ; ImchHL�̃n���h���i�[���Index     ���������ϐ��΍����L�q
    ImchHL(ImchHL(7) - 1) = m, 0    ; mode��handle
    ImchHL ++                       ; �X�g�b�N���̃J�E���g

    ;if m == ImchMode_GdipOpenDll       ; ���������܂����B��
    if (ImchMode_UseGdipFirst < m & m < ImchMode_UseGdipLast) & ImchHL(1) == 0 {    ; GDI+ Startup
        ImchHL(2) = 1, 0, 0, 0  : GdiplusStartup ImchHL(1), ImchHL(2)
    }

    if m == ImchMode_ImageFromStream {
        GdipLoadImageFromStream a, ImchHL(ImchHL(7))
    }
    if m == ImchMode_ImageFromWindow {
        dim bb, 1                               ; �����̏����͓��ɈӖ��͖������ǖ��������ϐ��΍�
        mref bb, 67
        GdipCreateBitmapFromGdiDib bb(6), bb(5), ImchHL(ImchHL(7))
    }
    if m == ImchMode_ImageFromImage {
        ;   a:����hImage  b,c:�؂�o���ʒuXY  d,e:�؂�o���T�C�YWH  f:PixelFormat
        ImchHL(2) = PixelFormat32bppARGB        ; f�̃f�t�H���g
        if f  : ImchHL(2) = f
        GdipCloneBitmapAreaI b, c, d, e, ImchHL(2), a, ImchHL(ImchHL(7))
    }
    if m == ImchMode_GraphicFromWindow {
        GdipCreateFromHDC hdc, ImchHL(ImchHL(7))
    }
    if m == ImchMode_Matrix {
        GdipCreateMatrix ImchHL(ImchHL(7))
    }
    if m == ImchMode_GlobalAlloc {
        ;   a:�m�ۂ��郁�����T�C�Y
        GlobalAlloc GMEM_ZEROINIT | GMEM_SHARE, a  : ImchHL(ImchHL(7)) = stat
    }
    if m == ImchMode_StreamWithGM {
        ;   a:�O���[�o���������̃n���h��
        if a == 0  : CreateStreamOnHGlobal 0, 1, ImchHL(ImchHL(7))      ; GM�w��Ȃ�
        if a != 0  : CreateStreamOnHGlobal a, 0, ImchHL(ImchHL(7))      ; GM�w�肠��
    }
    if m == ImchMode_ImageAttributes {
        GdipCreateImageAttributes ImchHL(ImchHL(7))
    }
    if m == ImchMode_CompBitmapObject {
        ;   a:���ɂ���hDC  b,c:SizeWH
        CreateCompatibleBitmap a, b, c  : ImchHL(ImchHL(7)) = stat
    }
    if m == ImchMode_CompDC {
        ;   a:���ɂ���hDC
        CreateCompatibleDC a  : ImchHL(ImchHL(7)) = stat    ; a:hDC
    }
    return ImchHL(ImchHL(7))

#deffunc ImgM_CloseH
    repeat ImchHL
        memcpy ImchHL(3), ImchHL((ImchHL - cnt - 1) * 2 + 8), 8     ; �^�[�Q�b�g

        ;if ImchMode_Group01<ImchHL(3) & ImchHL(3)<ImchMode_Group02  : GdiplusShutdown   ImchHL(4)
        if ImchMode_Group02<ImchHL(3) & ImchHL(3)<ImchMode_Group03  : GdipDisposeImage   ImchHL(4)
        if ImchMode_Group03<ImchHL(3) & ImchHL(3)<ImchMode_Group04  : GdipDeleteGraphics ImchHL(4)
        if ImchMode_Group04<ImchHL(3) & ImchHL(3)<ImchMode_Group05  : GdipDeleteMatrix   ImchHL(4)
        if ImchMode_Group05<ImchHL(3) & ImchHL(3)<ImchMode_Group06 {
            GdipDisposeImageAttributes ImchHL(4)
        }
        if ImchMode_Group06<ImchHL(3) & ImchHL(3)<ImchMode_Group07 {
            newcom bb, , -1, ImchHL(4)  : delcom bb
            ; �X�g���[���̔j���̓R�������Ă��炻�̃R����j������Ƃ�������
            ; GM���J��������ꏏ�ɃX�g���[�����j���������Đ�������T�C�g���������񂾂��ǉR�����orz
        }
        if ImchMode_Group07<ImchHL(3) & ImchHL(3)<ImchMode_Group08  : DeleteObject  ImchHL(4)
        if ImchMode_Group08<ImchHL(3) & ImchHL(3)<ImchMode_Group09  : DeleteDC      ImchHL(4)
        if ImchMode_Group09<ImchHL(3) & ImchHL(3)<ImchMode_Group10  : GlobalFree    ImchHL(4)
    loop

    if ImchHL(1)  : GdiplusShutdown ImchHL(1)       ; GDI+���J���Ă����Ȃ�B
    ImchHL = 0, 0
    return

/*=======================================================================================================
%index                                                                          ; �� "ImageFileModule"
%group
�摜�֘A���W���[��(�t�@�C������Q��)
%--------------------------------------------------------------------------------------------------------
%index
ImgF_GetFormat
�摜�t�@�C�����(�摜�t�H�[�}�b�g)
%prm
(Path)
Path [����]�t�@�C����(�p�X)
%inst
Path�Ŏw�肵���t�@�C���𕪐͂��Ă��̋L�^�`����Ԃ��܂��B�܂�memfile���߂ɂ��[���t�@�C���ɂ��Ή����Ă��܂��B
���̊֐��̖߂�l�͈ȉ��̂����ꂩ�ł��B
    0 : �s���ȃt�H�[�}�b�g
    1 : BITMAP
    2 : JPEG
    3 : GIF
    4 : PNG
%------------------------------------------------------------------------------------------------------*/
#defcfunc ImgF_GetFormat str n
    ; ���̊֐��͕��Y���Ƃ��� strsize �Ƀt�@�C���T�C�Y��Ԃ�
    ; ���W���[�����ϐ��� sb �Ƀt�@�C���f�[�^�S�����擾����(ImgF_GetPicSize�Ŏg������)
    exist n  : if strsize < 0  : return 0               ; ������(�t�@�C���Ȃ���B)
    sb = "(C)�ߓ��a"  : memexpand sb, strsize           ; sb�Ƀt�@�C���f�[�^��S���[�h
    bload n, sb, strsize
    if wpeek(sb, 0) == $4D42        : return 1          ; BITMAP    $42,$4D = "BM"
    if wpeek(sb, 0) == $D8FF        : return 2          ; JPEG      $FF,$D8 = "  "
    if lpeek(sb, 0) == $38464947    : return 3          ; GIF       $47,$49,$46,$38 = "GIF8"
    if lpeek(sb, 0) == $474E5089 & lpeek(sb, 4) == $0A1A0A0D  : return 4
                                            ; PNG   $89,$50,$4E,$47,$0D,$0A,$1A,$0A = " PNG    "
    return 0

/*-------------------------------------------------------------------------------------------------------
%index
ImgF_GetPicSize
�摜�t�@�C�����(�摜�̑傫��)
%prm
Path, SizeX, SizeY
Path  [����]�t�@�C����(�p�X)
SizeX [�ϐ�]�摜��(X)����������ϐ�(int)
SizeY [�ϐ�]�摜��(Y)����������ϐ�(int)
%inst
Path�Ŏw�肵���t�@�C���𕪐͂��Ă��̉摜�����[�h�������̃C���[�W�T�C�Y���擾���܂��B�܂�memfile���߂ɂ��[���t�@�C���ɂ��Ή����Ă��܂��B
���͉\�Ȍ`����BMP,JPG,GIF,PNG�̂����ꂩ�ŁA���ߎ��s��̃V�X�e���ϐ�stat�ɂ̓t�@�C���`���������l���������܂��B
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgF_GetPicSize str n, var x, var y
    x = 0  : y = 0                      ; �Ƃ肠�����ʂ�ہB�c����Ȃ���0����
    ib = ImgF_GetFormat(n)              ; �t�H�[�}�b�g�^�C�v
    ib(1) = strsize                     ; �f�[�^�T�C�Y

    if ib == 1 {                        ; �r�b�g�}�b�v�t�H�[�}�b�g
        if lpeek(sb, 14) == 40  : x = lpeek(sb, 18)  : y =lpeek(sb, 22)     ; Windows�`��
    }

    if ib == 2 {                        ; JPEG�t�H�[�}�b�g
        ib(2) = 2                           ; offset
        repeat
            if ib(1) <= ib(2)  : break          ; �A�v���N���b�V���[(�j���t�@�C��)�΍�
            if peek(sb, ib(2)) != $FF {         ; Nikon�N���b�V���[�΍�
                ib(2) ++                            ; nicoD700nico�̃o�O(�H)�ŃA�v����������...�����
                continue                            ; �Ƃ���Marker�炵���Ƃ���܂ŃX�L�b�v
            }

            ib(3) = peek(sb, ib(2) + 1)
            if ib(3) == $D9  : break            ; �t�@�C���I���̂��m�点
            if ib(3) == $C0 | ib(3) == $C2 {
                                        ; �ړI�n���� (�n�t�}���̃x�[�X���C�����v���O���b�V�u��Marker)
                ib(4) = wpeek(sb, ib(2) + 7), wpeek(sb, ib(2) + 5)  ;�g���b�v����(�������悾����orz)
                x = (ib(4) >> 8 & $00FF) | (ib(4) << 8 & $FF00)
                y = (ib(5) >> 8 & $00FF) | (ib(5) << 8 & $FF00)
                break
            }
            ib(4) = wpeek(sb, ib(2) + 2)        ; ����ȊO�̉����̏ꍇ
            ib(5) = (ib(4) >> 8 & $00FF) | (ib(4) << 8 & $FF00)
            ib(2) += ib(5) + 2
        loop
    }

    if ib == 3  : x = wpeek(sb, 6)  : y = wpeek(sb, 8)  ; GIF�t�H�[�}�b�g

    if ib == 4 {                        ; PNG�t�H�[�}�b�g
        if lpeek(sb, 12) == $52444849 {     ; $49,$48,$44,$52 = "IHDR"  ��IHDR�w�b�_�[�ł����Ă�����ׂ�
            ib(2) = lpeek(sb, 16), lpeek(sb, 20)    ; �r�b�O�G���f�B�A�����Ȃ��orz...
            x = (ib(2)>>24&$FF) | (ib(2)>>8&$FF00) | (ib(2)<<8&$FF0000) | (ib(2)<<24&$FF000000)
            y = (ib(3)>>24&$FF) | (ib(3)>>8&$FF00) | (ib(3)<<8&$FF0000) | (ib(3)<<24&$FF000000)
        }
    }
    return ib

/*-------------------------------------------------------------------------------------------------------
%index
ImgF_PicloadEx
�摜�t�@�C�������[�h(GDI+)
%prm
Path, Mode, Option, WinID
Path   [����]�t�@�C����(�p�X)
Mode   [�萔]�摜���[�h���[�h
    0 : �E�B���h�E������(��)
    1 : �E�B���h�E�̏������͂��Ȃ�
    2 : �E�B���h�E������(��)
Option [�萔]�r�b�g�t���O
    %**00 =  0 : �`���Window�W������
    %**01 =  1 : WinID��buffer�ŏ�����
    %**10 =  2 : WinID��screen�ŏ�����
    %**11 =  3 : WinID��bgscr�ŏ�����
    %00** =  0 : ���ߏ���K�p(�W��)
    %01** =  4 : ���ߏ��͖�������
    %10** =  8 : ���ߏ��݂̂�`��
    %11** = 12 : gmode 7 �Ŏg����`��
WinID  [���l]Option��Window�������w�莞�ɗ��p
     0�ȏ� : �w��ID�̃E�B���h�E��������
    -1�ȉ� : ���g�p�E�B���h�E��������
%inst
HSP�W����picload���߂�GDI+���g���čČ����܂��B���[�h�ł���t�@�C���`����BMP,JPG,GIF,PNG�Ȃ�GDI+�œǂݍ��߂�K�v������܂��B�܂�memfile���߂ɂ��[���t�@�C���ɂ��Ή����Ă��܂��B
Path��Mode��picload���߂Ɠ����ł���Option���w�肷�邱�ƂŊg�����[�h�����s�ł��܂��B
Option�ŃE�B���h�E�̏��������w�肷�邱�ƂŁApicload�O�̂ЂƎ��(screen��gsel)���ȗ��\�ł��B������Mode��1�̎��͂��̐ݒ�͓K�p����܂���B
Option��PNG��GIF�t�@�C���̎����߃s�N�Z��/�A���t�@�u�����h�̈������w��\�ł��B
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgF_PicloadEx str s, int f, int m, int w
    ; �{�Ƃ�PNG�ɐ����Ή��������ߑ��݈Ӌ`�Ȃ��Ȃ����B�ł�memfile(png��)�̊g���q�Ȃ���� viiV <kanikani
    exist s  : if strsize == -1  : return
    ib = strsize, 0, 0, 0, 0, 0, 0, 0
            ; �t�@�C���T�C�Y, �摜�T�C�YW, �摜�T�C�YH, hGlobal, hStream, hImage, hGraphics, hImageAttr

    ImgM_CreateH ImchMode_GlobalAlloc, ib  : ib(3) = stat   ; hGlobal
    GlobalLock ib(3)                                        ; GM���Œ肷��
    dupptr bb, stat, ib, 2                                  ; �Œ肵��GM�ɕϐ��������蓖�Ă�
    bload s, bb, ib, 0                                      ; ���蓖�Ă��ϐ��Ƀt�@�C���̓��e�𗬂�����
    GlobalUnlock ib(3)                                      ; �Œ����
    ImgM_CreateH ImchMode_StreamWithGM, ib(3)  : ib(4) = stat       ; GM��Stream��

    ImgM_CreateH ImchMode_ImageFromStream, ib(4)  : ib(5) = stat    ; Stream����Image
    GdipGetImageWidth  ib(5), ib(1)                         ; image.��
    GdipGetImageHeight ib(5), ib(2)                         ; image.�c

    if f == 0 | f == 2 {                        ; �E�B���h�E�̏������𔺂�
        if (m & 3) == 0 {                               ; �I�v�V�����ŃE�B���h�E�w��͖���
            mref bb, 67  : ib(8) = bb(17), ginfo_sel
        } else {                                        ; �I�v�V�����ŃE�B���h�E�w�肪�L��
            ib(8) = m & 3
            if w < 0  : ib(9) = ginfo_newid  : else  : ib(9) = w
        }
        if (m & %1100) == %1100  : ib(10) = ib(1) * 2  : else  : ib(10) = ib(1) ; ����

        ; �����܂ł�ib�� (8)�E�B���h�E�`�� (9)WindowID (10)Window����
        if ib(8) == 1  : buffer ib(9), ib(10), ib(2)
        if ib(8) == 2  : screen ib(9), ib(10), ib(2)
        if ib(8) == 3  : bgscr  ib(9), ib(10), ib(2)
        if f == 2  : boxf                               ; ���[�h2�̎��͍��h�肷��
    }

    ImgM_CreateH ImchMode_GraphicFromWindow  : ib(6) = stat

    if m & %1100 {              ; �I�v�V�����ŃA���t�@�u�����h�������w�肳��Ă���ꍇ
        ImgM_CreateH ImchMode_ImageAttributes  : ib(7) = stat

        if m & %0100 {              ; �A���t�@�u�����h�𖳎�����摜�`��
            ib( 8) = $3F800000, 0, 0, 0, 0, 0, $3F800000, 0, 0, 0, 0, 0, $3F800000, 0, 0
            ib(23) = 0, 0, 0, 0, 0, 0, 0, 0, $3F800000, $3F800000
            GdipSetImageAttributesColorMatrix ib(7), 1, 1, ib(8)
            GdipDrawImageRectRectI ib(6),ib(5),ginfo_cx,ginfo_cy,ib(1),ib(2),0,0,ib(1),ib(2),2,ib(7)
        }
        if m & %1000 {              ; �A���t�@�u�����h�}�X�N�̎��o��
            ib( 8) = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            ib(23) = $3F800000, $3F800000, $3F800000, 0, 0, 0, 0, 0, $3F800000, $3F800000
            GdipSetImageAttributesColorMatrix ib(7), 1, 1, ib(8)
            GdipDrawImageRectRectI ib(6),ib(5),ginfo_cx+((m>>2&1)*ib(1)),ginfo_cy,ib(1),ib(2),0,0,ib(1),ib(2),2,ib(7)
                ; ��Ƀv���[���摜��`�悵�Ă���Ƃ��́A���̉摜�̉E�ɕ`�悷��悤�ɂ���B
        }
    } else {                    ; �I�v�V�����ɃA���t�@�u�����h�������w��Ȃ��ꍇ�͕��ʂ̃R�s�[
        GdipDrawImageRectI ib(6), ib(5), ginfo_cx, ginfo_cy, ib(1), ib(2)   ; �A���t�@�͓K�p�����
    }

    ImgM_CloseH                 ; ��n����
    mref bb, 67  : if bb(19) & $FFFF0000  : redraw 1        ; �ĕ`�揈��
    return

/*-------------------------------------------------------------------------------------------------------
%index
ImgF_jpgsave
��ʃC���[�W�Z�[�u.JPG��(GDI+)
%prm
Path, Quality
Path    [����]�ۑ�����t�@�C����(�p�X)
Quality [���l]�i��
    0:�����k(�e��)�`100:�ሳ�k(���ߍׂ₩)
%inst
HSP�W����bmpsave���߂݂����Ȃ��̂ł��BGDI+���g�p����JPG�`���Ńt�@�C���ۑ����܂��B�i���w��t���B
%href
ImgP_Memsave
%------------------------------------------------------------------------------------------------------*/
#deffunc gdiimagesave str s, int p
	if getpath(s,18) = ".png" {
		ib     = 100,0,$557CF406,$11D31A04,$0000739A,$2EF31EF8,1,$1D5BE4B5,$452DFA4A,$B35DDD9C,$EBE70551,1,4,0
	} else {
		ib     = p,0,$557CF401,$11D31A04,$0000739A,$2EF31EF8,1,$1D5BE4B5,$452DFA4A,$B35DDD9C,$EBE70551,1,4,0
	}
    ib(13) = varptr(ib)                 ; �z�񎩓��m�ۂ�����Ă������悤�Ɋm�肵�Ă�����
    ImgM_CreateH ImchMode_ImageFromWindow  : ib(1) = stat
    GdipSaveImageToFile ib(1), s, ib(2), ib(6)

    ImgM_CloseH
return ayy                              ; HSP������GDI+�C���[�W�ۑ���jpeg���k���w�肪�������Ƃɑ΂���[�u

/*=======================================================================================================
%index                                                                          ; �� "ImagePrintModule"
%group
�摜�֘A���W���[��(���H�`��)
%--------------------------------------------------------------------------------------------------------
%index
ImgP_CalcFitSize
���{�v�Z(��`�Ɏ��܂�摜�T�C�Y)
%prm
Res_W, Res_H, PicW, PicH, RectW, RectH
Res_W, Res_H [�ϐ�]���ʂ��󂯎��ϐ�(int�^)
PicW,  PicH  [���l]���摜�̑傫��(�����A�c��)
RectW, RectH [���l]��`�̑傫��(�����A�c��)
%inst
�c����Œ�ŉ摜���g�k���鎞�Ɏw��̈�Ɏ��܂�ő�T�C�Y���Z�o���܂��B
%href
ImgP_gzoom
%index
ImgP_gzoom
�ϔ{���ĉ�ʃR�s�[(GDI+)
%prm
SizeX, SizeY, TrimWinID, TrimX, TrimY, TrimW, TrimH
SizeX, SizeY [���l]�\��t�����̉�ʃT�C�Y
TrimWinID    [���l]�R�s�[���̃E�B���h�EID
TrimX, TrimY [���l]�R�s�[���̋N�_���W
TrimW, TrimH [���l]�R�s�[���̐؂�o���T�C�Y
%inst
HSP�W����gzoom���߂�GDI+���g�p���čČ����܂��B�W�����߂����A���Ɋg�厞�ɉ掿���ǂ��Ȃ邩������܂���B
�摜�̓J�����g�|�W�V����������Ƃ����ʒu��SizeX��SizeY�Ŏw�肵���傫���ŕ`�悳��܂��B
TrimX��TrimY�͒ʏ퍶����W�ł����ATrimW��TrimH�ɕ����l���w�肷�邱�ƂŃ~���[���]���s�����Ƃ��\�ł��B
%href
ImgP_CalcFitSize
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgP_CalcFitSize var x, var y, int a, int b, int w, int h
    if a == 0 | b == 0  : x = 0  : y = 0    : return    ; 0����B
    ib = w * 10000 / a , h * 10000 / b                  ; ������(��)��B
    if ib <  ib(1)  : x = w  : y = b * ib / 10000
    if ib == ib(1)  : x = w  : y = h
    if ib >  ib(1)  : x = a * ib(1) / 10000  : y = h
    if x + 1 == w  : x = w                              ; �덷1pixel
    if y + 1 == h  : y = h
    return                                              ; ���̖��߂Ŏ����g���ĂȂ��̖̂͐̂��c�B

#deffunc ImgP_gzoom int w, int h, int i, int x, int y, int a, int b
    ib = ginfo_sel
    gsel i   : ImgM_CreateH ImchMode_ImageFromWindow    : ib(1) = stat      ; �R�s�[����Image�ɂ���
    gsel ib  : ImgM_CreateH ImchMode_GraphicFromWindow  : ib(2) = stat      ; �R�s�[���Graphic�ɂ���
    GdipDrawImageRectRectI ib(2), ib(1), ginfo_cx, ginfo_cy, w, h, x, y, a, b, 2    ; �R�s�[���s�B
    ImgM_CloseH
    mref bb, 67  : if bb(19) & $FFFF0000  : redraw 1                        ; �ĕ`�揈��
    return

/*-------------------------------------------------------------------------------------------------------
%index
ImgP_RotateFlip
�摜�̔��]��90����](GDI+)
%prm
Mode, TrimWinID, TrimX, TrimY, TrimW, TrimH
Mode         [�萔]��]���@
    0 : �������Ȃ�            (gcopy���)
    1 : ���v��� 90����]
    2 : ���v���180����]     (�㉺���E���]�Ƃ�����)
    3 : ���v���270����]
    4 :   0����]��A���E���] (���E���]�Ƃ����܂ł��Ȃ�)
    5 :  90����]��A���E���]
    6 : 180����]��A���E���] (�㉺���]�Ƃ�����)
    7 : 270����]��A���E���]
TrimWinID    [���l]�R�s�[���̃E�B���h�EID
TrimX, TrimY [���l]�R�s�[���̋N�_���W
TrimW, TrimH [���l]�R�s�[���̐؂�o���T�C�Y
%inst
�摜���~���[���]��90�x��]���ăR�s�[���܂��B�摜�̓J�����g�|�W�V����������Ƃ����ʒu�ɕ`�悳��܂��B
%href
ImgP_grotate
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgP_RotateFlip int m, int i, int x, int y, int w, int h
    ib = ginfo_sel

    gsel i
    ImgM_CreateH ImchMode_ImageFromWindow                    : ib(1) = stat ; �R�s�[����Image�ɂ���
    ImgM_CreateH ImchMode_ImageFromImage, ib(1), x, y, w, h  : ib(2) = stat ; �g���~���O����Image
    GdipImageRotateFlip ib(2), m                                            ; ��]���s�B

    gsel ib
    ImgM_CreateH ImchMode_GraphicFromWindow  : ib(3) = stat         ; �\��t�����Graphics
    GdipDrawImageI ib(3), ib(2), ginfo_cx, ginfo_cy                 ; �\��t�����s�B

    ImgM_CloseH
    mref bb, 67  : if bb(19) & $FFFF0000  : redraw 1                ; �ĕ`�揈��
    return

/*-------------------------------------------------------------------------------------------------------
%index
ImgP_Memsave
��ʃC���[�W�Z�[�uto�ϐ�(GDI+)
%prm
Res_Bin, Format, Width, Height, Option
Res_Bin [�ϐ�]�f�[�^���󂯎��ϐ�(������^�ɕϊ��\�ł��邱��)
Format  [�萔]�ۑ��`��
    1 : BMP
    2 : JPG
    3 : GIF
    4 : PNG
Width   [���l]����
Height  [���l]�c��
Option  [���l]JPG�̎� : �i��(0�`100)
%inst
���݂̉�ʃC���[�W��Format�Ŏw�肵���t�@�C���`���ŕۑ����܂��BRes_Bin�Ŏw�肵���ϐ����o�͐�ƂȂ�܂��B���ߎ��s��A�V�X�e���ϐ�stat�ɏo�͂��ꂽ�f�[�^�T�C�Y(byte)���������Ă��܂��B

Width��Height��0��ȗ��̏ꍇ�A��ʑS�̂��ΏۂƂȂ�܂�(�摜�T�C�Y�̓E�B���h�E�̏������T�C�Y�ł�)�BWidth��Height��0�ȊO�̏ꍇ�̓J�����g�|�W�V��������w��͈̔͂��ۑ�����܂��B
�ۑ��`����2(JPG)�̏ꍇ�AOption�ŕi�����w�肵�܂��B0(�����k�A�e��)����100(�ሳ�k�A���ߍׂ₩)�̐����Ŏw��\�ł��B�ȗ�����0�����ł��B
%href
ImgF_jpgsave
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgP_Memsave var b, int m, int w, int h, int p ; �ϐ�,�`��,��,����,�i��
    ib = 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0, 1, 0,0,0,0,0,0,0,0
    ;   (0)GlobalSize (1)stream (2)image(����) (3)image(works) (4)hGlobal
    ;   (5)PosX (6)PosY (7)Width (8)Height (9)PixelFormat (10�`13)ImageCodec
    ;   (14)�p������(0���ƕۑ��Ɏ��s����̂�1�ȏ�A1�����K�v�Ȃ��ꍇ�̓p�����ɖ����Ȓl�������Ƃ�...)
    ;   (15�`18)�p�����G���R�[�_ (19)�p�����v�f��? (20)�p�����^ (21)�|�C���^(���I)
    ;   (22�`)�p�����G���R�[�_����J��Ԃ�

    if w==0 | h==0 : ib(5) = 0,0,ginfo_sx,ginfo_sy :else: ib(5) = ginfo_cx,ginfo_cy,w,h ; �g���~���O

    mref bb, 67
    if bb(3)  : ib(9) = PixelFormat8bppIndexed  : else  : ib(9) = PixelFormat24bppRGB   ; �s�N�t�H�}

    if m == 1  : ib(10) = $557CF400, $11D31A04, $0000739A, $2EF31EF8        ; BMP
    if m == 2 {
        ib(22) = p
        ib(10) = $557CF401, $11D31A04, $0000739A, $2EF31EF8                 ; JPG
        ib(14) = 1 ,$1D5BE4B5, $452DFA4A, $B35DDD9C, $EBE70551, 1, 4, varptr(ib(22))
    }
    if m == 3  : ib(10) = $557CF402, $11D31A04, $0000739A, $2EF31EF8        ; GIF
    if m == 4  : ib(10) = $557CF406, $11D31A04, $0000739A, $2EF31EF8        ; PNG

    ImgM_CreateH ImchMode_ImageFromWindow  : ib(3) = stat
    ImgM_CreateH ImchMode_ImageFromImage, ib(3), ib(5), ib(6), ib(7), ib(8), ib(9)  : ib(2) = stat

    ImgM_CreateH ImchMode_StreamWithGM  : ib(1) = stat
    GdipSaveImageToStream ib(2), ib(1), ib(10), ib(14)
    if stat  : ImgM_CloseH  : return 0                  ; ���炩�ȕs�����Ƃ��A�}�W������B

    GetHGlobalFromStream ib(1), ib(4)                   ; �X�g���[���Ǘ���hGlobal��q��
    GlobalSize ib(4)  : ib = stat                       ; ��������
    b = "(C)�ߓ��a"  : memexpand b, ib                  ; �������m��
    GlobalLock ib(4)
    dupptr bb, stat, ib, vartype("str")
    memcpy b, bb, ib
    GlobalUnlock ib(4)

    ImgM_CloseH
    return ib

/*-------------------------------------------------------------------------------------------------------
%index
ImgP_FilterPastel
�摜�t�B���^�[(�P�x�␳)
%prm
Lumin, Width, Height
Lumin  [���l]�␳�l(-256�`256)
Width  [���l]����
Height [���l]�c��
%inst
���݂̉�ʂɑ΂��ċP�x�␳���s���܂��B
Width��Height��0��ȗ��̏ꍇ�A��ʑS�̂��ΏۂƂȂ�܂��BWidth��Height��0�ȊO�̏ꍇ�̓J�����g�|�W�V��������w��͈̔͂��Ώۂł��B

Lumin�ɋP�x�ω��̊������w�肵�܂��B���̒l�ɂ���Ċe�s�N�Z���́A�܂�����(-256�w�莞)����܂�����(256�w�莞)�̊Ԃŕω����܂��B�Ȃ��A0���w�肵�����̋P�x�ω��͂���܂���(�)�B
Lumin�ɐ������w�肷��ƁA�p�X�e�����̔������������悤�Ȃ��炩����ۂɂȂ�܂��B
Lumin�ɕ������w�肷��ƁA�S�̓I�ɈÂ��F�ω��̖R�����摜�ɂȂ�܂��B
%href
ImgP_FilterVivid
%index
ImgP_FilterVivid
�摜�t�B���^�[(�F����)
%prm
Lumin, Width, Height
Lumin  [���l]�␳�l(-256�`256)
Width  [���l]����
Height [���l]�c��
%inst
���݂̉�ʂɑ΂��ċP�x�␳���s���܂��B
Width��Height��0��ȗ��̏ꍇ�A��ʑS�̂��ΏۂƂȂ�܂��BWidth��Height��0�ȊO�̏ꍇ�̓J�����g�|�W�V��������w��͈̔͂��Ώۂł��B

Lumin�ɋP�x�ω��̊������w�肵�܂��B���̒l�ɂ���Ċe�s�N�Z���͐F����������悤�ɕω����܂��B
Lumin�ɐ������w�肷��ƁA�e�s�N�Z���̐F�͔Z���Ȃ�܂��B���ɈÂ��F�قǁA���傫���P�x�������邱�ƂɂȂ�܂��BLumin=256�̎��̖ڈ��͈ȉ��̒ʂ�ł��B
    �P�x = ���P�x - (255 - ���P�x)
    ����) ���P�x��250�̎��A�P�x��245
    ����) ���P�x��130�̎��A�P�x��5
Lumin�ɕ������w�肷��ƁA�e�s�N�Z���̐F�͔��ɋ߂Â��܂��BLumin=-256�̎��A���̋P�x��2�{�̋P�x�ɕω����܂��B
Lumin��0���w�肵�����̋P�x�ω��͂���܂���(�)�B
������̏ꍇ���P�x��0�`255�͈̔͂Ɏ��܂�悤�ɉ������������܂��B
%href
ImgP_FilterPastel
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgM_FilterLight int l, int w, int h, int m    ; ���x�H�P�x�H
    mref bb, 67                                         ; ginfo�ł����\�����邯�ǑS�������
    ib = bb(19), bb(35), bb(33), bb(34), bb(65)         ; �ĕ`��t���O��gmode�̌��ݒl
    if w == 0 | h == 0  : ib(5) = 0, 0, bb(1), bb(2)  : else  : ib(5) = bb(27), bb(28), w, h    ; �͈�
    ib(9) = bb(27), bb(28)                              ; �J�����g�|�W�V����(�Y��Ă�...)
    if m == 0  : gmode 5, , , limit(abs(l), 0, 256)     ; ���[�h�F�r�r�b�h�g�[��
    if m == 1  : gmode 6, , , limit(abs(l), 0, 256)     ; ���[�h�F�p�X�e���g�[��
    redraw 0                                            ; �l�K����gcopy����u����̂ŋ����I�ɃI�t���Ƃ�
    if 0 < l  : BitBlt hdc, ib(5), ib(6), ib(7), ib(8), , , , DSTINVERT     ; �l�K
    pos ib(5), ib(6)  : gcopy bb(18), ib(5), ib(6), ib(7), ib(8)
    if 0 < l  : BitBlt hdc, ib(5), ib(6), ib(7), ib(8), , , , DSTINVERT     ; �|�W

    pos ib(9),ib(10)  : gmode ib(1),ib(2),ib(3),ib(4)   ; �����Č��̈ʒu�ɖ߂�
    if ib & $FFFF0000  : redraw 1                       ; �ĕ`��(�ݒ�̕��������˂�)
    return

    ; �g�ݍ��킹��4�̖��߂��ł������ǁ��ŏI�I��1���ɂ܂Ƃ܂���(��  ���}�N���̌`�Œ�
#define global ImgP_FilterPastel(%1,%2=0,%3=0)  ImgM_FilterLight %1,%2,%3,1
#define global ImgP_FilterVivid(%1,%2=0,%3=0)   ImgM_FilterLight %1,%2,%3,0
    ; �␳�l���������ƃr�r���Ƃ����₩���Ċ����ł͂Ȃ��K���}�Ƃ��R���g���X�g�Ƃ����߂�����

/*-------------------------------------------------------------------------------------------------------
%index
ImgP_FilterNega
�摜�t�B���^�[(�l�K�|�W�A�r���I�_���a=XOR)
%prm
Width, Height
Width  [���l]����
Height [���l]�c��
%inst
���݂̉�ʂɑ΂��ăJ�����g�J���[�Ƃ�XOR���Z���s���܂��B
Width��Height��0��ȗ��̏ꍇ�A��ʑS�̂��ΏۂƂȂ�܂��BWidth��Height��0�ȊO�̏ꍇ�̓J�����g�|�W�V��������w��͈̔͂��Ώۂł��B

XOR�͂���΃r�b�g���]������v�Z�ŁA���Ƃ���
    %11001100 ^ %00001111 �� %11000011
    �� %11001100:�퐔  ^:���Z�q  %00001111:�Ώۃr�b�g�w��
�ƂȂ�܂��B
�ł��̂ŁA�܂�����(255, 255, 255)�Ƃ�XOR�̓l�K�|�W���ʂ��A�܂�����(0, 0, 0)�Ƃ�XOR�͖��Ӗ��ƂȂ�ق��A���܂��܂ȉ摜���ʂ𓾂邱�Ƃ��ł��܂��B
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgP_FilterNega int w, int h
    mref bb, 67
    SelectObject hdc, bb(36)  : ib = stat           ; HSP�����u�����Ă���u���V�I�u�W�F��ݒ�
    if w == 0 | h == 0  : ib(1) = 0, 0, bb(1), bb(2)  : else  : ib(1) = bb(27), bb(28), w, h    ; �n�j
    BitBlt hdc, ib(1), ib(2), ib(3), ib(4), , , , PATINVERT     ; �u���V��XOR           �͂ɂ�!?���͈�
    SelectObject hdc, ib                            ; ���̃u���V�ɖ߂�
    if bb(19) & $FFFF0000  : redraw 1               ; �ĕ`�揈��
    return

/*-------------------------------------------------------------------------------------------------------
%index
ImgP_FilterSubAbs
�摜�t�B���^�[(2�摜�̍��̐�Βl)
%prm
DiffWinID, PosX, PosY, Width, Height
DiffWinID    [���l]�摜B�̃E�B���h�EID
PosX, PosY   [���l]�摜B�̍�����W
Width,Height [���l]�����A�c��
%inst
���݂̉��(�摜A)�ƃp�����[�^�w��̉��(�摜B)�ō����Ƃ肻�̐�Βl�������܂��B���̉摜�͋P�x�̍����������قǈÂ�(����)�_�Ƃ��ĕ\������
    �E�ǂ������Q�̉摜�̑���_�����o�I�Ɏ���
    �E���k�ɂ��掿�̗򉻋�̔���
    �E�F���Z�R�s�[���ɃN�����v����Ă��镔���̎��o��
�Ƃ������p�r�Ɏg�p�\�ł��B

�摜A�ɂ��āAWidth��Height��0��ȗ��̏ꍇ�͌��݂̉�ʑS�̂��ΏۂƂȂ�܂��BWidth��Height��0�ȊO�̏ꍇ�̓J�����g�|�W�V��������w��͈̔͂��Ώۂł��B
�摜B�͎w����W������Ƃ���ʒu����摜A�Ɠ��T�C�Y���ΏۂƂȂ�܂��B���ʉ摜�͉摜A���㏑������`�ŕ`�悳��܂��B
%------------------------------------------------------------------------------------------------------*/
#deffunc ImgP_FilterSubAbs int i, int x, int y, int w, int h
    ; ����Ă��邱�Ƃ�[A-B=C][B-A=D][C+D=E]�̉摜�����R�s�[�ɉ߂��Ȃ����A��ƗpWin�s�v���ŉ�肭�ǂ��B
    ; �摜�X�g�b�N�̃R���p�`�̓R�s�[��Win�ɍ��킹��(�R�s�[���摜(�v�Z��Ɏc���)�̗򉻂�h������)�B
    ; [C+D=E]�́A�����N�����v�ׁ̈A����� 0 �ɂȂ��Ă��� �� �_���a/�r���I�_���a/���Z(���Z)�ǂ�ł�OK!

    ;   ib( 0�` 7)�R�s�[��ݒ�  0:WinID   1:redrawFrag   2-5:gmode   6-7:curPos
    ;   ib( 8�`11)�o�͈ʒu�͈�  8-9:pos   10-11:size
    ;   ib(12�`18)�R�s�[���ݒ�  12:redrawFlag   13-16:gmode   17-18:curPos
    ;   ib(19�`21)�n���h���Y    19:CreateHDC   20:CreatehBitmap   21:hBitmapStock

    mref bb, 67
    ib = bb(18), bb(19), bb(35), bb(33), bb(34), bb(65), bb(27), bb(28)     ; �R�s�[��ݒ�(�T��)
    redraw 0                                                                ; �R�s�[��ĕ`��I�t

    if w == 0 | h == 0 : ib(8) = 0, 0, bb(1), bb(2) :else: ib(8) = bb(27), bb(28), w, h ; �͈͌v�Z

    gsel i                      ; ��������� hdc �̓R�s�[��
    mref bb, 67
    ib(12) = bb(19), bb(35), bb(33), bb(34), bb(65), bb(27), bb(28), 0, 0, 0    ; �R�s�[���T���{hndl��
    redraw 0                                                                    ; �R�s�[���ĕ`��I�t

    ImgM_CreateH ImchMode_CompDC, hdc  : ib(19) = stat                                  ; �f�o�R�����
    ImgM_CreateH ImchMode_CompBitmapObject, hdc, ib(10) * 2, ib(11)  : ib(20) = stat    ; �r�g�}���
    SelectObject ib(19), ib(20)  : ib(21) = stat                                        ; �r�g�}�����ւ�

    BitBlt ib(19), ib(10), 0, ib(10), ib(11), hdc, x, y, SRCCOPY        ; �R�s�[���̉摜���T���Ă���
    gmode 6, ib(10), ib(11), 256  : pos x, y  : gcopy ib, ib(8), ib(9)  ; �܂��R�s�[���Ɍ��Z���s
    BitBlt ib(19), 0, 0, ib(10), ib(11), hdc, x, y, SRCCOPY             ; ���Z���ʂ��T����
    BitBlt hdc, x, y, ib(10), ib(11), ib(19), ib(10), 0, SRCCOPY        ; �R�s�[���͌��Z�O�ɖ߂�

    gsel ib                     ; ��������� hdc �̓R�s�[��
    gmode 6, ib(10), ib(11), 256  : pos ib(8), ib(9)  : gcopy i, x, y   ; ���ɃR�s�[��Ɍ��Z���s
    BitBlt hdc, ib(8), ib(9), ib(10), ib(11), ib(19), 0, 0, SRCPAINT    ; �ӂ��̌��Z���ʂ�����

    SelectObject ib(19), ib(21)                 ; �����ւ��Ă����r�g�}�������߂�
    ImgM_CloseH                                 ; API�t�B�j�b�V���[

    ; �E�B���h�E��CurPos/gmode/RedrawFlag�𕜌�(WinID��v�̉\�����l�����čŌ�ɂ܂Ƃ߂Ďd�グ��)
    gsel i  : pos ib(17),ib(18) : gmode ib(13),ib(14),ib(15),ib(16) : if ib(12)&$FFFF0000 : redraw 1
    gsel ib : pos ib( 6), ib(7) : gmode ib( 2),ib( 3),ib( 4),ib( 5) : if ib( 1)&$FFFF0000 : redraw 1
    return

/*-------------------------------------------------------------------------------------------------------
%index
ImgP_grotate
��`�摜����]���ăR�s�[(GDI+)
%prm
TrimWinID, TrimX, TrimY, Angle, Width, Height
TrimWinID     [���l]���摜�̃E�B���h�EID
TrimX, TrimY  [���l]���摜�̋N�_(����)���W
Angle         [����]��]�p�x(���W�A���A1��=2�΁E���v���)
Width, Height [���l]�`��T�C�Y(�����A�c��)
%inst
HSP�W����grotate���߂�GDI+���g�p���čČ����܂��B�c���قȂ�_�������ł��B�W�����߂����掿���ǂ��Ȃ�܂��B

�`��̓J�����g�|�W�V�����𒆐S�Ƃ����ʒu�ɍs���܂��B
�`���̋�`�T�C�Y��Width��Height�Ɏw�肵�܂��B��]���邽�߉摜�͂��̋�`�ɂ͎��܂�܂���BWidth��Height��0���ȗ������ꍇ�͓��{�R�s�[�A�傫�����w�肵���ꍇ�͊g��E�k���R�s�[�ɂȂ�܂��B
���摜�̃T�C�Y��gmode���߂Őݒ肵���l���g�p���܂��̂ŁA���炩���ߎw�肵�Ă����Ă��������B

gmode�̃R�s�[���[�h��0��1�݂̂ɑΉ����Ă��܂�(�܂�x�^�ʂ�ł�)�B
���摜�͈̔͂ɉ�ʊO�̈悪�܂܂��ꍇ�A���̗̈�͓��߉�f�̈����ɂȂ�܂�(grotate�ł̓��T�C�Y�H�����悤�ŁA�g�k�E�`��ʒu�ɉe�����o�܂�)�B
%href
ImgP_RotateFlip
%------------------------------------------------------------------------------------------------------*/
;   grotate�̍Č��ƌ������A�C�ӊp��]���߂Ƃ��Ă܂Ƃ߂������ȑf�ŗǂ������H
#deffunc ImgP_grotate int i, int x, int y, double r, int w, int h
    mref bb, 67                                     ; ���̏������Ď��̂Ƃ���A�[�g���b�g�Ɂ[�Ł[�łł���
    ib = bb(18), bb(19), bb(35), bb(33), bb(34), bb(65), bb(27), bb(28)
    if w == 0 | h == 0  : ib(8) = ib(3), ib(4)  : else  : ib(8) = w, h      ; �`��T�C�Y
    ;   ib(0-7)�`�����   0:WinID   1:redrawFrag   2-5:gmode   6-7:curPos���g���ĂȂ��ˁH
    ;   ib(8-9)�\��t�����̑傫��     ���Ȃ݂�ib(3-4)�؂���T�C�Y

    ImgM_CreateH ImchMode_Matrix  : ib(10) = stat               ; ib(10) matrix
    GdipTranslateMatrix ib(10), ginfo_cx, ginfo_cy, 0           ; ���W�́A���͎���
    GdipRotateMatrix    ib(10), rad2deg(r), 0                   ; GDI+�ł�rad��deg����
    GdipTranslateMatrix ib(10), -ginfo_cx, -ginfo_cy, 0

    ImgM_CreateH ImchMode_GraphicFromWindow  : ib(11) = stat    ; ib(11) graphic(�`���)
    GdipSetWorldTransform ib(11), ib(10)

    gsel i  : ImgM_CreateH ImchMode_ImageFromWindow  : ib(12) = stat    ; ib(12) image(���摜)
    gsel ib
    GdipDrawImageRectRectI ib(11),ib(12),ginfo_cx-ib(8)/2,ginfo_cy-ib(9)/2,ib(8),ib(9),x,y,ib(3),ib(4),2 

    ImgM_CloseH
    if ib(1) & $FFFF0000  : redraw 1
    return

; http://www.tvg.ne.jp/menyukko/ ; Copyright(C) 2010-2014 �ߓ��a All rights reserved.
#global
#endif