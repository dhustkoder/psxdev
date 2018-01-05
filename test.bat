
ccpsx -Wall -Werror -O2 -G0 -Xo$80010000 src/*.c -omain.cpe,main.sym,mem.map
cpe2x /ce main.cpe
buildcd -l -iPSXTEST.IMG PSXTEST.CTI
stripiso s 2352 PSXTEST.IMG PSXTEST2.ISO
psxlicense /eu /i PSXTEST2.ISO
