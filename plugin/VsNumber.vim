"vim plugin to change the order of number in select text
"
" rargo.m@gmail.com
"
" further consider c format %03d, not sure yet 
"
"ie:
"before( '*' repersents select position):
"		=*1--1===2----3*=====9=
"		=*5--4===5----6*=====9=
"		=*1--1===2----3*=====9=
"		=*5--4===5----6*=====9=
"after :VsNumberChange 9 1
"		=*9--10===11----12*=====9=
"		=*13--14===15----16*=====9=
"		=*17--18===19----20*=====9=
"		=*21--22===23----24*=====9=
"after :VsNumberChange . -1
"		=*0--0===1----2*=====9=
"		=*4--3===4----5*=====9=
"		=*0--0===1----2*=====9=
"		=*4--3===4----5*=====9=
"		that is each number in select text adds by 1

command! -range -nargs=+ VsNumber call VsNumber(<q-args>)

function! VsNumber(args)
	let usage = "Usage: VsNumberOrder [ '.' | startNum ] [step]"

	"XXX not working!!!
	"let mode = mode()
	"echo "mode:" . mode
	"if mode != "v" &&  mode != "V" && mode != "CTRL-V"
	"	echo "Not in visual mode"
	"	return 
	"endif

	let spaceByte = match(a:args,"\\s\\+",0)
	let spaceStr = matchstr(a:args,"\\s\\+",0)
	if spaceByte == -1
		echo usage
	endif

	let startNum = strpart(a:args,0,spaceByte)
	"echo "spaceByte:" . spaceByte
	"echo spaceStr
	"echo startNum
	let spaceByte += len(spaceStr)
	let step = strpart(a:args,spaceByte)
	if len(step) == 0
		echo usage
	endif

	if startNum != "."
		let startNum = eval(startNum)
		"echo startNum
	endif
	let step = eval(step)
	call VsNumberOrder(startNum, step)
endfunc

"change number order
"startNumber == ".":
"	new number = old number + step
"startNumber != "."
"	new number = startNum + i*step
"before: '*' repersents select position
"		=*1--1===2----3*======
"		=*5--4===5----6*======
"		=*1--1===2----3*======
"		=*5--4===5----6*======
"after call NumSort(999,1):
"		=999--1000===1001----1002======
"		=1003--1004===1005----1006======
"		=1007--1008===1009----1010======
"		=1011--1012===1013----1014======
"after call NumSort("",3):
"		=*4--4===5----6*======
"		=*8--7===8----9*======
"		=*4--4===5----6*======
"		=*8--7===8----9*======
function! VsNumberOrder(startNum,step)
	let [lnum1, col1] = [line("'<"),col("'<")]
	let [lnum2, col2] = [line("'>"),col("'>")]

	"echo "a:startNum:" . a:startNum
	let lines = getline(lnum1, lnum2)
	let newlines = []

	let searchLength = col2
	"blockwise mode, adjust searchLength to the max line length
	if visualmode() == "V"
		for line in lines
			if strlen(line) > searchLength
				let searchLength = strlen(line)
			endif
		endfor
	endif

	"echo "===================="
	"find number position,change it
	let i = 0
	for line in lines

		let startByte = col1 - 1
		"echo "searchLength" . searchLength
		let line_new = strpart(line,0,startByte)
		while 9 
			let matchByte = match(line,"[0-9]\\+",startByte)
			"echo "matchByte:" . matchByte
			if matchByte != -1

				"echo "matchByte:" . matchByte
				let matchstr = matchstr(line,"[0-9]\\+", matchByte)
				let matchstr_len = len(matchstr)
				"echo "startByte:" . startByte
				"echo "matchstr:" . matchstr
				"echo "matchstr_len:" . matchstr_len

				if (matchByte + matchstr_len) > searchLength
					"echo "break"
					let line_new .= strpart(line,startByte)
					break
				endif

				let line_new .= strpart(line,startByte,matchByte-startByte)
				"echo a:startNum
				if type(a:startNum) == type(0)
					"sort the number start by startNum
					"echo a:startNum + i*a:step
					let line_new .= "" . (a:startNum + i*a:step)
				else  " '.'
					"new number = old number + step
					let line_new .= "" . eval(matchstr) + a:step
				endif
				"echo "line_new" . line_new

				let startByte = matchByte + matchstr_len
				let i += 1
			else
				let line_new .= strpart(line,startByte)
				break
			endif
		endwhile
		call add(newlines,line_new)
	endfor

	let startLine = lnum1
	"set new line
	for line in newlines
		call setline(startLine, line)
		let startLine += 1
	endfor
endfunc
