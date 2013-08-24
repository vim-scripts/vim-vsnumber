
vim plugin to change the make value of number sorted in select text,
rargo.m@gmail.com

It's useful when you has the following text, and you want to correct the suqenuce
	1. line1
	2. line2
	7. line3
	6. line4
to:
	1. line1
	2. line2
	3. line3
	4. line4

also, useful when you want to make a large suqenuce numbers like below:
	enum const_logic {
		int value0 = 0,
		int value1 = 1,
		int value2 = 2,
		int value3 = 3,
		int value4 = 4,
		int value5 = 5,
		int value6 = 6,
		int value7 = 7,
		int value8 = 8,
		int value9 = 9,
		...
	};


Usage: use ctrl-v V v to select text,and call vsnumber to make it's value change

for example:
origin text:
		=1--1--3=====9=
		=5--4--6=====9=

select text using ctrl-v( '|' repersents select position):
		=|1--1--3|=====9=
		=|5--4--6|=====9=

if call :'<,'>VsNumber 9 1
the result is:
		=9--10--11=====9=
		=12--13--14=====9=
		that is the number in select text became sort start from 9, increase by 1

if call :'<,'>VsNumber . -1  ("." mean's change uppon on current value)
the result is:
		=0--0--2=====9=
		=4--3--5=====9=
		that is each number in select text sub by 1

