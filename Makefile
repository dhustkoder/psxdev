PROJNAME=TEST


.PHONY all: clean main cdiso


main: %.cpe
	cpe2x /ce main.cpe

cdiso: %.img
	stripiso s 2352 $(PROJNAME).IMG $(PROJNAME).ISO
	psxlicense /eu /i $(PROJNAME).ISO

%.img:
	buildcd -l -i$(PROJNAME).IMG $(PROJNAME).CTI

%.cpe:
	ccpsx -Wall -Werror -O2 -G0 -Xo$$80010000 src/*.c -omain.cpe


.PHONY clean:
	del *.map
	del *.sym
	del *.cpe
	del *.img
	del *.toc
	del *.exe


