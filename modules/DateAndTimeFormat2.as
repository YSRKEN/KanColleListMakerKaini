#module "DateAndTimeFormat2_Mod"

#uselib "kernel32.dll"
#func GetLocalTime "GetLocalTime" int

#deffunc DateAndTimeFormat2_Init

	dim localTime, 4

	eMonthFullArr = "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"	//MMMM
	eMonthAbbreviationsArr = "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"									//MMM

	eDayOfWeekFullArr = "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"											//edddd
	eDayOfWeekAbbreviationsArr = "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"																//eddd

	jDayOfWeekFullArr = "���j��", "���j��", "�Ηj��", "���j��", "�ؗj��", "���j��", "�y�j��"													//jdddd		
	jDayOfWeekAbbreviationsArr = "��", "��", "��", "��", "��", "��", "�y"																		//jddd
	
	eTimeDivisionArr = "AM","PM"		//ett
	jTimeDivisionArr = "�ߑO","�ߌ�"	//jtt
	
return

#defcfunc DateAndTimeFormat2 str _st

	sdim st
	st = _st

	GetLocalTime varptr(localTime)

	year4 = ""+ wpeek(localTime(0), 0)					//yyyy
	year2 = strf("%02d", wpeek(localTime(0), 0)\100)	//yy
	year1 = ""+ wpeek(localTime(0), 0) \ 100			//y		

	month2 = strf("%02d", wpeek(localTime(0), 2))		//MM
	month1 = ""+ wpeek(localTime(0), 2)					//M

	mouhtNum = wpeek(localTime(0), 2) -1
	dayOfWeekNum = wpeek(localTime(1), 0)
	timeDivisionNum = wpeek(localTime(2), 0) / 12

	day2 = strf("%02d", wpeek(localTime(1), 2)) 		//dd
	day1 = ""+ wpeek(localTime(1), 2)					//d

	hour242 = strf("%02d", wpeek(localTime(2), 0))		//HH
	hour241 = ""+ wpeek(localTime(2), 0)				//H

	hour122 = strf("%02d", wpeek(localTime(2), 0) \ 12)	//hh
	hour121 = ""+ wpeek(localTime(2), 0) \ 12			//h

	min2 = strf("%02d", wpeek(localTime(2), 2))			//mm
	min1 = ""+ wpeek(localTime(2), 2)					//m

 	sec2 = strf("%02d", wpeek(localTime(3), 0))			//ss
 	sec1 = ""+ wpeek(localTime(3), 0)					//s

 	msec = strf("%03d", wpeek(localTime(3), 2))			//ms

	strrep st, "<yyyy>", year4
	strrep st, "<yy>", year2
	strrep st, "<y>", year1
	strrep st, "<MMMM>", eMonthFullArr(mouhtNum)
	strrep st, "<MMM>", eMonthAbbreviationsArr(mouhtNum)
	strrep st, "<MM>", month2
	strrep st, "<M>", month1
	strrep st, "<edddd>", eDayOfWeekFullArr(dayOfWeekNum)
	strrep st, "<eddd>", eDayOfWeekAbbreviationsArr(dayOfWeekNum)
	strrep st, "<jdddd>", jDayOfWeekFullArr(dayOfWeekNum)
	strrep st, "<jddd>", jDayOfWeekAbbreviationsArr(dayOfWeekNum)
	strrep st, "<dd>", day2
	strrep st, "<d>", day1
	strrep st, "<hh>", hour122
	strrep st, "<h>", hour121
	strrep st, "<ett>", eTimeDivisionArr(timeDivisionNum)
	strrep st, "<jtt>", jTimeDivisionArr(timeDivisionNum)
	strrep st, "<HH>",hour242
	strrep st, "<H>", hour241
	strrep st, "<mm>", min2
	strrep st, "<m>", min1
	strrep st, "<ss>", sec2
	strrep st, "<s>", sec1
	strrep st, "<ms>", msec

return st

#deffunc isValidFileName str _filename, local filename 

	filename = _filename

	if instr(filename, 0, "<") != -1: return 0
	if instr(filename, 0, ">") != -1: return 0
	if instr(filename, 0, "\\") != -1: return 0
	if instr(filename, 0, "/") != -1: return 0
	if instr(filename, 0, ":") != -1: return 0
	if instr(filename, 0, "*") != -1: return 0
	if instr(filename, 0, "?") != -1: return 0
	if instr(filename, 0, "!") != -1: return 0
	if instr(filename, 0, "\"") != -1: return 0
	if instr(filename, 0, "|") != -1: return 0

return 1


#global
	
	DateAndTimeFormat2_Init

#if 0

	st =  "�N�@�@�@�@<yyyy>-<yy>-<y>\n"
	st += "���@�@�@�@<MMMM>-<MMM>-<MM>-<M>\n"
	st += "�j���@�@�@<edddd>-<jdddd>-<eddd>-<jddd>\n"
	st += "���@�@�@�@<dd>-<d>\n"
	st += "�ߑO�ߌ�@<ett>-<jtt>\n"
	st += "12���ԁ@�@<hh>-<h>\n"
	st += "24���ԁ@�@<HH>-<H>\n"
	st += "���@�@�@�@<mm>-<m>\n"
	st += "�b�@�@�@�@<ss>-<s>\n"
	st += "�~���b�@�@<ms>"

	mes DateAndTimeFormat2(st)

	isValidFileName "d"
	mes stat

	isValidFileName "<>"
	mes stat
	
	stop

#endif


#module

#defcfunc cnvMilliSecondToMMSSMS int _ms
	ms = limit(_ms, 0, 5999999)
return strf("%02d:%02d.%03d", (ms/1000/60), (ms/1000\60), (ms\1000))

#global