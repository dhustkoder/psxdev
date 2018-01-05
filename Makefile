
.PHONY all: clean main cdiso


main: %.cpe
	cpe2x /ce main.cpe

cdiso: %.img
	stripiso s 2352 PSXTEST.IMG PSXTEST.ISO
	psxlicense /eu /i PSXTEST.ISO

%.img:
	buildcd -l -iPSXTEST.IMG PSXTEST.CTI

%.cpe:
	ccpsx -Wall -Werror -O2 -G0 -Xo$$80010000 src/*.c -omain.cpe


.PHONY clean:
	del *.map
	del *.sym
	del *.cpe
	del *.img
	del *.toc
	del *.exe


