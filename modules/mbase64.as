/**
 * マシン語でBase64へのエンコード・デコードを行うモジュール
 * 元作者：kanahironさん
 */
#module machine_base64
	/* WinAPI */
	#uselib "kernel32.dll"
		#func VirtualProtect "VirtualProtect" var, int, int, var
	#const PAGE_EXECUTE_READWRITE $40

	/**
	 * dim命令で領域を確保すると同時に、VirtualProtectでアクセス保護を変更する
	 * (PAGE_EXECUTE_READWRITEを設定した領域では、アセンブラを読み書きおよび実行できる)
	 */
	#define xdim(%1, %2) dim %1, %2: VirtualProtect %1, %2 * 4, PAGE_EXECUTE_READWRITE, AZSD

	/**
	 * Base64エンコードを行う
	 * @param src 変換対象となる、文字列の変数
	 * @param size srcのバイト数
	 * @param dest Base64にエンコードされた文字列をここに返す
	 */
	#deffunc Base64Encode var src, int size, var dest
		base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		xdim base64enc, 54
		base64enc.0 = 0x51EC8B55, 0x10558B51, 0xC9335653, 0x33F63357, 0x0C4D39FF, 0x89FC4D89
		base64enc.6 = 0x8E0FF84D, 0x000000AC, 0x8B08458B, 0xB60FF85D, 0xE3C10704, 0x89C30B08
		base64enc.12 = 0xF983F845, 0x6A377502, 0x458B5912, 0x145D8BF8, 0xE083F8D3, 0x18048A3F
		base64enc.18 = 0xFF420288, 0x8346FC45, 0x0E754CFE, 0x420D02C6, 0x420A02C6, 0x4583F633
		base64enc.24 = 0xE98302FC, 0x33D37906, 0xF84D89C9, 0x474101EB, 0x7C0C7D3B, 0x01F983AB
		base64enc.30 = 0x036A527C, 0x2BC78B5F, 0x0C4589C1, 0x097EC085, 0x65C1C88B, 0x754908F8
		base64enc.36 = 0x59126AF9, 0x7F0C7D39, 0xF8458B12, 0xD3145D8B, 0x3FE083F8, 0x8818048A
		base64enc.42 = 0xC603EB02, 0xFF423D02, 0x8346FC45, 0x0E754CFE, 0x420D02C6, 0x420A02C6
		base64enc.48 = 0x4583F633, 0x834F02FC, 0xC87906E9, 0x5FFC458B, 0x0002C65E, 0x10C2C95B
		prm.0 = varptr(src), size, varptr(dest), varptr(base64)
	return callfunc(prm, varptr(base64enc), 4)

	/**
	 * Base64デコードを行う
	 * @param src 変換対象となる、Base64にエンコードされた文字列の変数
	 * @param size srcのバイト数
	 * @param dest Base64からデコードされた文字をここに返す
	 */
	#deffunc Base64Decode var src, int size, var dest
		base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		xdim base64dec, 56
		base64dec.0 = 0x51EC8B55, 0x8B565351, 0xC0331075, 0x33D23357, 0x0C4539FF, 0x89F84589
		base64dec.6 = 0x8E0FFC45, 0x0000008A, 0x8A084D8B, 0xD98A0F0C, 0xC141EB80, 0xFB8006E2
		base64dec.12 = 0x0F087719, 0xE983C9BE, 0x8A22EB41, 0x61EB80D9, 0x7719FB80, 0xC9BE0F08
		base64dec.18 = 0xEB47E983, 0x80D98A10, 0xFB8030EB, 0x0F0A7709, 0xC183C9BE, 0xEBD10B04
		base64dec.24 = 0x2BF9801C, 0xCA830575, 0x8012EB3E, 0x05752FF9, 0xEB3FCA83, 0x3DF98008
		base64dec.30 = 0x45FF2375, 0x03F883F8, 0x45011875, 0x59106AFC, 0xF8D3C28B, 0x83460688
		base64dec.36 = 0xF47908E9, 0xC033D233, 0xEB4006EB, 0x06FAC103, 0x0C7D3B47, 0xFF768C0F
		base64dec.42 = 0x046AFFFF, 0x85C82B59, 0xC1067EC9, 0x754906E2, 0xFC458BFA, 0x8359106A
		base64dec.48 = 0xDA8B03C0, 0x1E88FBD3, 0x08E98346, 0x452BF479, 0x06C65FF8, 0xE8835E00
		base64dec.54 = 0xC2C95B03, 0x00000010
		prm.0 = varptr(src), size, varptr(dest), varptr(base64)
	return callfunc(prm, varptr(base64dec), 4)
#global
