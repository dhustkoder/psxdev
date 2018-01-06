PROJNAME=TEST
PSYQ_DIR=C:/PSYQ
PROJ_DIR=C:/PSYQ/PROJECTS/PSPROG

.PHONY all: clean main cdiso


main: %.cpe
	cpe2x /ce main.cpe

cdiso: %.img
	stripiso s 2352 $(PROJNAME).IMG $(PROJNAME).ISO
	psxlicense /eu /i $(PROJNAME).ISO

%.img: %.cti
	buildcd -l -i$(PROJNAME).IMG $(PROJNAME).CTI

%.cpe:
	ccpsx -Wall -Werror -O2 -G0 -Xo$$80010000 src/*.c -omain.cpe

%.cti: %.cnf
	echo "Define ProjectPath "$(PROJ_DIR)"\n" >> $(PROJNAME).cti
	echo "Define LicensePath "$(PSYQ_DIR)"/CDGEN/LCNSFILE/\n" >> $(PROJNAME).cti
	echo "Define LicenseFile licensee.dat\n\n" >> $(PROJNAME).cti
	echo "Disc CDROMXA_PSX ;the disk format\n\n" >> $(PROJNAME).cti
	echo "\tCatalogNumber 0000000000000\n\n" >> $(PROJNAME).cti
	echo "\tLeadIn XA ;lead in track (track 0)\n" >> $(PROJNAME).cti
	echo "\t\tEmpty 300 ;defines the lead in size (min 150)\n" >> $(PROJNAME).cti
	echo "\t\tPostGap 150 ;required gap at end of the lead in\n" >> $(PROJNAME).cti
	echo "\tEndTrack ;end of the lead in track\n\n" >> $(PROJNAME).cti
	echo "\tTrack XA ;start of the XA (data) track\n\n" >> $(PROJNAME).cti
	echo "\t\tPause 150 ;required pause in first track after the lead in\n\n" >> $(PROJNAME).cti
	echo "\t\tVolume ISO9660 ;define ISO 9660 volume\n\n" >> $(PROJNAME).cti
	echo "\t\t\tSystemArea [LicensePath][LicenseFile]\n\n" >> $(PROJNAME).cti
	echo "\t\t\tPrimaryVolume ;start point of primary volume\n" >> $(PROJNAME).cti
	echo "\t\t\t\tSystemIdentifier \"PLAYSTATION\" ;required indetifier (do not change)\n" >> $(PROJNAME).cti
	echo "\t\t\t\tVolumeIdentifier \"Test\" ;app specific identifiers (changeable)\n" >> $(PROJNAME).cti
	echo "\t\t\t\tVolumeSetIdentifier \"Test\"\n" >> $(PROJNAME).cti
	echo "\t\t\t\tPublisherIdentifier \"DeVine\"\n" >> $(PROJNAME).cti
	echo "\t\t\t\tDataPreparerIdentifier \"SONY\"\n" >> $(PROJNAME).cti
	echo "\t\t\t\tApplicationIdentifier \"PLAYSTATION\"" >> $(PROJNAME).cti
	echo "\t\t\t\tLPath ;path tables as specified for PlayStation\n" >> $(PROJNAME).cti
	echo "\t\t\t\tOptionalLpath\n" >> $(PROJNAME).cti
	echo "\t\t\t\tMPath\n" >> $(PROJNAME).cti
	echo "\t\t\t\tOptionalMpath\n\n" >> $(PROJNAME).cti
	echo "\t\t\t\tHierarchy ;start point of root directory definition\n\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tXAFileAttributes  Form1 Audio\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tXAVideoAttributes ApplicationSpecific\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tXAAudioAttributes ADPCM_C Stereo ;you can also add 'Emphasis_On' before Stereo\n\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tFile SYSTEM.CNF\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\t\tXAFileAttributes Form1 Data ;set the attribute to form 1\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\t\tSource [ProjectPath]SYSTEM.CNF ;where the file above can be found\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tEndFile\n\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tFile MAIN.EXE\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\t\tXAFileAttributes Form1 Data\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\t\tSource [ProjectPath]MAIN.EXE\n" >> $(PROJNAME).cti
	echo "\t\t\t\t\tEndFile\n\n" >> $(PROJNAME).cti
	echo "\t\t\t\tEndHierarchy ;ends the root directory definition\n\n" >> $(PROJNAME).cti
	echo "\t\t\tEndPrimaryVolume ;ends the primary volume definition\n\n" >> $(PROJNAME).cti
	echo "\t\tEndVolume ;ends the ISO 9660 definition\n\n" >> $(PROJNAME).cti
	echo "\t\tEmpty 300\n" >> $(PROJNAME).cti
	echo "\t\tPostGap 150 ;required to change the track type\n" >> $(PROJNAME).cti
	echo "\tEndTrack ;ends the track definition (end of the XA track)\n\n" >> $(PROJNAME).cti
	echo "\tLeadOut XA ;note that the leadout track must be the same data type as the last track (IE: AUDIO, XA or MODE1)\n" >> $(PROJNAME).cti
	echo "\tEmpty 150\n" >> $(PROJNAME).cti
	echo "\tEndTrack\n\n" >> $(PROJNAME).cti
	echo "EndDisc" >> $(PROJNAME).cti

%.cnf:
	echo "BOOT=cdrom:\\MAIN.EXE;1" >> system.cnf
	echo "TCB=4" >> system.cnf
	echo "EVENT=10" >> system.cnf
	echo "STACK=801FFFF0" >> system.cnf

.PHONY clean:
	rm -rf *.map *.sym *.cpe *.img *.toc *.exe *.cnf *.cti


