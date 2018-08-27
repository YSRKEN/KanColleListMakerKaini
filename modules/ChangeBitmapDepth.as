/* ChangeBitmapDepth ���W���[��
 * HSP��24bit��bitmap��nbit�ɕϊ�����(n = 8, 24, 32)
 * 24bit�ȊO�̃r�b�h�[�x�͈ꕔ�W�����߂��g�p�s�\(gzoom�Ȃ�)
 */
#module ChangeBitmapDepth
	/* WinAPI */
	#uselib	"user32.dll"
		#func GetDC "GetDC" int
		#func ReleaseDC "ReleaseDC" int, int
	#uselib "gdi32.dll"
		#func CreateDIBSection "CreateDIBSection" int, int, int, int, int, int
		#func CreateCompatibleBitmap "CreateCompatibleBitmap" int, int, int
		#func SelectObject "SelectObject" int, int
		#func DeleteObject "DeleteObject" int
	#const NULL 0
	#define DIB_RGB_COLORS	$0000

	/* ���̑��萔 */
	#const MREF_BMSCR 67

	/**
	 *�J�����g�E�B���h�E��BMSCR�\���̂ɂ��āA�F�[�x��bpp�Ŏw�肵�����̂ɕύX����
	 * @param bpp �F�[�x(8, 24, 32����I���B0�ɂ���ƃ��Z�b�g)
	 */
	#deffunc chgbm int bpp
		mref bm, MREF_BMSCR
		if bpp == 0 {
			GetDC NULL
			hDisp = stat
			CreateCompatibleBitmap hDisp, bm(1), bm(2)
			hnewbm = stat
			ReleaseDC NULL, hdisp
			bm(5) = 0
		} else {
			dupptr bmInfo, bm(6), 40
			wpoke bmInfo, 14, bpp
			bmInfo(5) = 0
			CreateDIBSection NULL, bm(6), DIB_RGB_COLORS, varptr(bm(5)), NULL, 0
			hnewbm = stat
		}
		SelectObject hdc, hnewbm
		DeleteObject bm(7)
		bm(7) = hnewbm
		bm(67) = (bm(1) * bpp + 31) / 32 * 4
		bm(16) = bm(67) * bm(2)
	return
#global
