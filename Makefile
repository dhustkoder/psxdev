# Before using the Makefile you should download and install GnuMake and PSYQ SDK
# (you can download the PSYQ SDK from www.psxdev.net).
# Then set the PSYQ_DIR in setupenv.bat and in this Makefile and run the setupenv.bat
# now you can use make to build the project

# This Makefile should run on Windows XP (or less).
# This Makefile can also run on Linux with wine and dosbox installed.

# Set this to the project name
PROJNAME=TEST

# Set this to the PSYQ directory
PSYQ_DIR=C:\PSYQ

# Set this to this project directory
PROJ_DIR=C:\PSYQ\PROJECTS\PSPROG

LIBS=-llibpad

.PHONY all: clean main cdiso

.PHONY clean:
	del *.MAP *.SYM *.CPE *.IMG *.TOC *.EXE *.CNF *.CTI


main: %.CPE
	cpe2x /ce MAIN.CPE

%.CPE:
	ccpsx -Wall -Werror -O2 -G0 -Xo$$80010000 $(LIBS) src/*.c -oMAIN.CPE

cdiso: %.IMG
	stripiso s 2352 $(PROJNAME).IMG $(PROJNAME).ISO
	psxlicense /eu /i $(PROJNAME).ISO

%.IMG: %.CTI
	buildcd -l -i$(PROJNAME).IMG $(PROJNAME).CTI

%.CTI: %.CNF
	del *.CTI
	echo Define ProjectPath $(PROJ_DIR)\ >> $(PROJNAME).CTI
	echo Define LicensePath $(PSYQ_DIR)\CDGEN\LCNSFILE\ >> $(PROJNAME).CTI
	echo Define LicenseFile licensee.dat >> $(PROJNAME).CTI
	echo Disc CDROMXA_PSX ;the disk format >> $(PROJNAME).CTI
	echo 	CatalogNumber 0000000000000 >> $(PROJNAME).CTI
	echo 	LeadIn XA ;lead in track (track 0) >> $(PROJNAME).CTI
	echo 		Empty 300 ;defines the lead in size (min 150) >> $(PROJNAME).CTI
	echo 		PostGap 150 ;required gap at end of the lead in >> $(PROJNAME).CTI
	echo 	EndTrack ;end of the lead in track >> $(PROJNAME).CTI
	echo 	Track XA ;start of the XA (data) track >> $(PROJNAME).CTI
	echo 		Pause 150 ;required pause in first track after the lead in >> $(PROJNAME).CTI
	echo 		Volume ISO9660 ;define ISO 9660 volume >> $(PROJNAME).CTI
	echo 			SystemArea [LicensePath][LicenseFile] >> $(PROJNAME).CTI
	echo 			PrimaryVolume ;start point of primary volume >> $(PROJNAME).CTI
	echo 				SystemIdentifier "PLAYSTATION" ;required indetifier (do not change) >> $(PROJNAME).CTI
	echo 				VolumeIdentifier "$(PROJNAME)" ;app specific identifiers (changeable) >> $(PROJNAME).CTI
	echo 				VolumeSetIdentifier "$(PROJNAME)" >> $(PROJNAME).CTI
	echo 				PublisherIdentifier "SCEE" >> $(PROJNAME).CTI
	echo 				DataPreparerIdentifier "SONY" >> $(PROJNAME).CTI
	echo 				ApplicationIdentifier "PLAYSTATION" >> $(PROJNAME).CTI
	echo 				LPath ;path tables as specified for PlayStation >> $(PROJNAME).CTI
	echo 				OptionalLpath >> $(PROJNAME).CTI
	echo 				MPath >> $(PROJNAME).CTI
	echo 				OptionalMpath >> $(PROJNAME).CTI
	echo 				Hierarchy ;start point of root directory definition >> $(PROJNAME).CTI
	echo 					XAFileAttributes  Form1 Audio >> $(PROJNAME).CTI
	echo 					XAVideoAttributes ApplicationSpecific >> $(PROJNAME).CTI
	echo 					XAAudioAttributes ADPCM_C Stereo ;you can also add 'Emphasis_On' before Stereo >> $(PROJNAME).CTI
	echo 					File SYSTEM.CNF >> $(PROJNAME).CTI
	echo 						XAFileAttributes Form1 Data ;set the attribute to form 1 >> $(PROJNAME).CTI
	echo 						Source [ProjectPath]SYSTEM.CNF ;where the file above can be found >> $(PROJNAME).CTI
	echo 					EndFile >> $(PROJNAME).CTI
	echo 					File MAIN.EXE >> $(PROJNAME).CTI
	echo 						XAFileAttributes Form1 Data >> $(PROJNAME).CTI
	echo 						Source [ProjectPath]MAIN.EXE >> $(PROJNAME).CTI
	echo 					EndFile >> $(PROJNAME).CTI
	echo 				EndHierarchy ;ends the root directory definition >> $(PROJNAME).CTI
	echo 			EndPrimaryVolume ;ends the primary volume definition >> $(PROJNAME).CTI
	echo 		EndVolume ;ends the ISO 9660 definition >> $(PROJNAME).CTI
	echo 		Empty 300 >> $(PROJNAME).CTI
	echo 		PostGap 150 ;required to change the track type >> $(PROJNAME).CTI
	echo 	EndTrack ;ends the track definition (end of the XA track) >> $(PROJNAME).CTI
	echo 	LeadOut XA ;note that the leadout track must be the same data type as the last track (IE: AUDIO, XA or MODE1) >> $(PROJNAME).CTI
	echo 	Empty 150 >> $(PROJNAME).CTI
	echo 	EndTrack >> $(PROJNAME).CTI
	echo EndDisc >> $(PROJNAME).CTI

%.CNF:
	del *.CNF
	echo BOOT=cdrom:\MAIN.EXE;1 >> SYSTEM.CNF
	echo TCB=4 >> SYSTEM.CNF
	echo EVENT=10 >> SYSTEM.CNF
	echo STACK=801FFFF0 >> SYSTEM.CNF


