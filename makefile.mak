# ----------------------------
# PlayStation 1 Psy-Q MAKEFILE
# ----------------------------

all:
	ccpsx -Wall -Werror -O3 -Xo$80010000 src\*.c -omain.cpe,main.sym,mem.map
	cpe2x /ce main.cpe


clean:
	del mem.map
	del main.sym
	del main.exe
	del main.cpe
	cls