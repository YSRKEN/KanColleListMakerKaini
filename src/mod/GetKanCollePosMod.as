#ifndef ChangeBitmapDepth
	#include "../lib/ChangeBitmapDepth.as"
#endif

#module getKanCollePosMod

//CompArrays 配列同士を比較し全て一致すれば真を返す
#define CompArrays(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) != %3(cnt){%1 = FALSE: break}: loop
//CompArrays2 配列同士を比較し全て一致しなければ真を返す
#define CompArrays2(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) == %3(cnt){%1 = FALSE: break}: loop
//CompArrayAndValue 配列と値を比較し全て一致すれば真を返す
#define CompArrayAndValue(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) != %3{%1 = FALSE: break}: loop
//CompArrayAndValue2 配列と値を比較し全て一致しなければ真を返す
#define CompArrayAndValue2(%1, %2, %3) %1 = TRUE: foreach %2: if %2(cnt) == %3{%1 = FALSE: break}: loop

#define ctype getCol(%1, %2) vram((%1)+(scrH-1-(%2))*scrW)

#define TRUE 1
#define FALSE 0

//==================================================================
//
// getKanCollePosAuto
//
//==================================================================
#deffunc getKanCollePosAuto int imageid, array sscap, int bufid

	selID = ginfo_sel

	gsel imageid
	scrH = ginfo_winy
	scrW = ginfo_winx

	buffer bufid, scrW, scrH
	chgbm 32
	mref vram, 66
	gcopy imageid, 0, 0, scrW, scrH

	gsel selID

	sizeX = 0
	sizeY = 0

	contNum = 0 //見つかった対象の個数

	//探し出す対象の最小幅、高さ(MinimumContentWidth)
	minContW = int(1.0*BASE_SIZE_W * ZOOM_MIN)
	minContH = int(1.0*BASE_SIZE_H * ZOOM_MIN)

	//探索幅(最低でも矩形に対して3回以上点で当たる間隔)
	sachW = (minContW-1)/3
	sachH = (minContH-1)/3

	//探索する回数
	vSachNum = scrW/sachW

	dim vArrUp, vSachNum
	dim vArrBtm, vSachNum
	dim posArr, 2 //startX(SX), posX
	dim posYArr, 1 //startX(SX), posX
	//posArrに入る数値は普通にピクセル数なので注意

	posArrNum = 0 //検出された線分の個数

	//最初の0行目を走査
	repeat vSachNum
		posX = cnt
		vArrUp(cnt) = getCol( posX*sachW, 0)
	loop

	//横方向に矩形の境界線を探すブロック
	repeat scrH-minContH-1, 1
		posY = cnt

		//取得と比較を同時に行うため先にx=0の色をを取得
		vArrBtm(0) = getCol( 0, posY)
		sameCnt = 0
		//0行目を上、1行目を下側と見て、比較
		repeat vSachNum-1
			posX = cnt
			//配列に順次代入していく
			vArrBtm(cnt+1) = getCol( (posX+1)*sachW, posY)

			//上側が同じ色　かつ 上側と下側は異なる色 かつ下側は異なる色
			if ( vArrUp(cnt) == vArrUp(cnt+1) && vArrUp(cnt) != vArrBtm(cnt) && vArrUp(cnt+1) != vArrBtm(cnt+1) && vArrBtm(cnt) != vArrBtm(cnt+1)){
				//一致したらその座標を左側座標(StartX)として記録
				if (sameCnt == 0): posSX = posX
				sameCnt++
			} else {
				//さっきの条件が不一致の時、前に2回以上連続していたら矩形の境界線と判断し記録
				if (sameCnt >= 2){
					posYArr(posArrNum) = posY
					posArr(0, posArrNum) = posSX*sachW, posX*sachW
					posArrNum++
				}
				sameCnt = 0
			}
		loop
		//何度も同じ配列を参照するのはもったいないので下側として見ていた行を上側に持ってくる
		memcpy vArrUp, vArrBtm, (4*vSachNum)
	loop

	logmes "PHASE1 posArrNum "+posArrNum
#if 0
	gsel imageid
	color 255, 0, 0
	repeat posArrNum
		//logmes ""+posArr(1, cnt)+" "+posYArr(cnt)+ " "+posArr(0, cnt)+ " "+ posYArr(cnt)
		line posArr(1, cnt), posYArr(cnt), posArr(0, cnt), posYArr(cnt)
	loop
	stop
#endif

	//左側の線分が領域をはみ出していた時にそれを引っ込める処理
	repeat posArrNum
		topCnt = cnt
		posY = posYArr(cnt)
		posLeft = posArr(0, cnt)
		posRight = posArr(1, cnt)

		x1Col = getCol(posLeft, posY)
		x2Col = getCol(posLeft+1, posY)

		repeat sachW

			x3Col = getCol(posLeft+cnt+2, posY)

			if (x1Col != x2Col && x1Col != x3Col){
				posYArr(topCnt) = posY
				posArr(0, topCnt) = posLeft+cnt+1, posRight
				break
			}
			x1Col = x2Col
			x2Col = x3Col
		loop
	loop

	logmes "PHASE2 posArrNum "+posArrNum
#if 0
	gsel imageid
	color 255, 0, 0
	repeat posArrNum
		//logmes ""+posArr(1, cnt)+" "+posYArr(cnt)+ " "+posArr(0, cnt)+ " "+ posYArr(cnt)
		line posArr(1, cnt), posYArr(cnt), posArr(0, cnt), posYArr(cnt)
	loop
	stop
#endif

	//線分が単色の連続か確かめ、そうでないなら消す
	posArrNum_ = posArrNum
	posArrNum = 0
	repeat posArrNum_

		posY = posYArr(cnt)
		posLeft = posArr(0, cnt)
		posRight = posArr(1, cnt)

		baseCol = getCol( posLeft+1, posY-1)
		repeat (posRight-posLeft)-3, 2
			offsetX = cnt
			if getCol( posLeft+offsetX, posY-1) != baseCol: break
		loop
		if (offsetX == (posRight-posLeft)-2){
			posYArr(posArrNum) = posY
			posArr(0, posArrNum) = posLeft, posRight
			posArrNum++
		}
	loop

	logmes "PHASE3 posArrNum "+posArrNum
#if 0
	gsel imageid
	color 255, 0, 0
	repeat posArrNum
		line posArr(1, cnt), posYArr(cnt), posArr(0, cnt), posYArr(cnt)
	loop
	stop
#endif

	//矩形の境界線から左上座標を算出するブロック
	posArrNum_ = posArrNum
	posArrNum = 0
	repeat posArrNum_

		posY = posYArr(cnt)
		posLeft = posArr(0, cnt)
		posRight = posArr(1, cnt)
		repeat limit( sachW, 0, posLeft-1) //探索幅になるか左側にぶつかるまで
			offsetX =  cnt

			CCCol = getCol( posLeft-offsetX  , posY) //座標そのもの
			TCCol = getCol( posLeft-offsetX  , posY-1)
			TRCol = getCol( posLeft-offsetX+sachW-1, posY-1)
			LCCol = getCol( posLeft-offsetX-1, posY)
			LBCol = getCol( posLeft-offsetX-1, posY+sachH-1)

			if (TCCol == TRCol && LCCol == LBCol && CCCol != TCCol && CCCol != LCCol){
				posYArr(posArrNum) = posY
				posArr(0, posArrNum) = posLeft-offsetX, posRight
				posArrNum++
				break
			}
		loop
	loop

	logmes "PHASE4 posArrNum "+posArrNum
#if 0
	gsel imageid
	color 255, 255, 0
	repeat posArrNum
		line posArr(1, cnt), posYArr(cnt), posArr(0, cnt), posYArr(cnt)
	loop
	stop
#endif

	//縦方向に単色が連続しているか確認する処理
	posArrNum_ = posArrNum
	posArrNum = 0
	repeat posArrNum_

		posY = posYArr(cnt)
		posLeft = posArr(0, cnt)
		posRight = posArr(1, cnt)

		baseCol = getCol( posLeft-1, posY)
		repeat minContH-1, 1
			offsetY = cnt
			if (baseCol != getCol( posLeft-1, posY+offsetY) ): break
		loop
		if (offsetY+1 == minContH){
			posYArr(posArrNum) = posY
			posArr(0, posArrNum) = posLeft, posRight
			posArrNum++
		}
	loop
	logmes "PHASE5 posArrNum "+posArrNum
#if 0
	gsel imageid
	color 255, 255, 0
	repeat posArrNum
		line posArr(1, cnt), posYArr(cnt), posArr(0, cnt), posYArr(cnt)
	loop
	stop
#endif

	repeat posArrNum
		posY = posYArr(cnt)
		posLeft = posArr(0, cnt)
		posRight = posArr(1, cnt)
		SearchFromPoint@getKanCollePosMod posLeft, posY, sizeX, sizeY, (posRight-posLeft)+sachW
		if ( stat == 0){
			sscap(0, contNum) = posLeft, posY, sizeX, sizeY
			contNum++
		}
	loop

	logmes "Finish"
return contNum

//==================================================================
//
// SearchFromPoint
//
//==================================================================
#deffunc local SearchFromPoint int _posX, int _posY, var _sizeX, var _sizeY, int _limitX

	dim tccX, 5
	dim tccY, 5
	dim po, 2
	ddim ratio, 5
	ratio = 0.9, 0.82, 0.73, 0.5, 0.12

	po = _posX, _posY
	pccX = 0
	pccY = 0
	flagX = 0
	flagY = 0
	as = 0.0
	topCnt = 0
	success = FALSE

	if (po(0) < 0 || po(1) < 0):return (success)^1

	//最小検索幅の少し手前からスタートする
	repeat _limitX-int(ZOOM_MIN*BASE_SIZE_W)-2, int(ZOOM_MIN*BASE_SIZE_W)-2
		x = cnt
		y = int(BASE_ASPECT_RATIO * cnt + 0.5)

		if (scrW <= (po(0)+x) || scrH <= (po(1)+y)): break

		pccX = getCol( po(0)+x-1, po(1)+ratio(0)*y )
		pccY = getCol( po(0)+ratio(0)*x, po(1)+y-1 )

		repeat 5
			ex =  cnt
			tccX(cnt) = getCol( po(0)+x, po(1)+ratio(cnt)*y )
			tccY(cnt) = getCol( po(0)+ratio(cnt)*x, po(1)+y )
		loop

		CompArrayAndValue flagX, tccX, tccX(0)
		CompArrayAndValue flagY, tccY, tccY(0)

		if ( flagX && flagY ){
			if ( pccX != tccX(0) && pccY != tccY(0)){
				as = absf( BASE_ASPECT_RATIO - 1.0*(y)/(x))
				if (as <= 0.007){
					_sizeX = x+po(0)
					_sizeY = y+po(1)
					success = TRUE
					break
				}
			}
		}
	loop

return (success)^1

#global

#if 0
	#include "winmm.as"

	screen 2
	picload "Sample1.png"
	color 255, 96, 96
	gsel 2, -1

	dim sscap, 4, 1

	st = timeGetTime()
	getKanCollePosAuto3 2, sscap, 1
	en = timeGetTime()

	screen 0
	repeat length2(sscap)
		mes strf("%5d,%5d %5dx%5d", sscap(0, cnt), sscap(1, cnt), sscap(2, cnt)-sscap(0, cnt), sscap(3, cnt)-sscap(1, cnt))
		//gsel 2: boxf sscap(0, cnt), sscap(1, cnt), sscap(2, cnt), sscap(3, cnt): gsel 0
	loop
	mes ""+(en-st)+"ms"

	title "fin"
	stop

#endif
