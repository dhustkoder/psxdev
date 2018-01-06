# Before using the Makefile you should download and install GnuMake and PSYQ SDK
# (you can download the PSYQ SDK from www.psxdev.net).
# Then set the PSYQ_DIR in setupenv.bat and in this Makefile and run the setupenv.bat
# now you can use make to build the project

# This Makefile should be run in a Windows XP (or less) System
# This Makefile can also run in Linux using Wine cmd

# Set this to the project name
PROJNAME=TEST

# Set this to the PSYQ directory
PSYQ_DIR=C:\PSYQ

# Set this to this project directory
PROJ_DIR=C:\PSYQ\PROJECTS\PSPROG

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
	del *.cti
	echo Define ProjectPath $(PROJ_DIR)\ >> $(PROJNAME).cti
	echo Define LicensePath $(PSYQ_DIR)\CDGEN\LCNSFILE\ >> $(PROJNAME).cti
	echo Define LicenseFile licensee.dat >> $(PROJNAME).cti
	echo Disc CDROMXA_PSX ;the disk format >> $(PROJNAME).cti
	echo 	CatalogNumber 0000000000000 >> $(PROJNAME).cti
	echo 	LeadIn XA ;lead in track (track 0) >> $(PROJNAME).cti
	echo 		Empty 300 ;defines the lead in size (min 150) >> $(PROJNAME).cti
	echo 		PostGap 150 ;required gap at end of the lead in >> $(PROJNAME).cti
	echo 	EndTrack ;end of the lead in track >> $(PROJNAME).cti
	echo 	Track XA ;start of the XA (data) track >> $(PROJNAME).cti
	echo 		Pause 150 ;required pause in first track after the lead in >> $(PROJNAME).cti
	echo 		Volume ISO9660 ;define ISO 9660 volume >> $(PROJNAME).cti
	echo 			SystemArea [LicensePath][LicenseFile] >> $(PROJNAME).cti
	echo 			PrimaryVolume ;start point of primary volume >> $(PROJNAME).cti
	echo 				SystemIdentifier "PLAYSTATION" ;required indetifier (do not change) >> $(PROJNAME).cti
	echo 				VolumeIdentifier "$(PROJNAME)" ;app specific identifiers (changeable) >> $(PROJNAME).cti
	echo 				VolumeSetIdentifier "$(PROJNAME)" >> $(PROJNAME).cti
	echo 				PublisherIdentifier "SCEE" >> $(PROJNAME).cti
	echo 				DataPreparerIdentifier "SONY" >> $(PROJNAME).cti
	echo 				ApplicationIdentifier "PLAYSTATION" >> $(PROJNAME).cti
	echo 				LPath ;path tables as specified for PlayStation >> $(PROJNAME).cti
	echo 				OptionalLpath >> $(PROJNAME).cti
	echo 				MPath >> $(PROJNAME).cti
	echo 				OptionalMpath >> $(PROJNAME).cti
	echo 				Hierarchy ;start point of root directory definition >> $(PROJNAME).cti
	echo 					XAFileAttributes  Form1 Audio >> $(PROJNAME).cti
	echo 					XAVideoAttributes ApplicationSpecific >> $(PROJNAME).cti
	echo 					XAAudioAttributes ADPCM_C Stereo ;you can also add 'Emphasis_On' before Stereo >> $(PROJNAME).cti
	echo 					File SYSTEM.CNF >> $(PROJNAME).cti
	echo 						XAFileAttributes Form1 Data ;set the attribute to form 1 >> $(PROJNAME).cti
	echo 						Source [ProjectPath]SYSTEM.CNF ;where the file above can be found >> $(PROJNAME).cti
	echo 					EndFile >> $(PROJNAME).cti
	echo 					File MAIN.EXE >> $(PROJNAME).cti
	echo 						XAFileAttributes Form1 Data >> $(PROJNAME).cti
	echo 						Source [ProjectPath]MAIN.EXE >> $(PROJNAME).cti
	echo 					EndFile >> $(PROJNAME).cti
	echo 				EndHierarchy ;ends the root directory definition >> $(PROJNAME).cti
	echo 			EndPrimaryVolume ;ends the primary volume definition >> $(PROJNAME).cti
	echo 		EndVolume ;ends the ISO 9660 definition >> $(PROJNAME).cti
	echo 		Empty 300 >> $(PROJNAME).cti
	echo 		PostGap 150 ;required to change the track type >> $(PROJNAME).cti
	echo 	EndTrack ;ends the track definition (end of the XA track) >> $(PROJNAME).cti
	echo 	LeadOut XA ;note that the leadout track must be the same data type as the last track (IE: AUDIO, XA or MODE1) >> $(PROJNAME).cti
	echo 	Empty 150 >> $(PROJNAME).cti
	echo 	EndTrack >> $(PROJNAME).cti
	echo EndDisc >> $(PROJNAME).cti

%.cnf:
	del *.cnf
	echo BOOT=cdrom:\MAIN.EXE;1 >> system.cnf
	echo TCB=4 >> system.cnf
	echo EVENT=10 >> system.cnf
	echo STACK=801FFFF0 >> system.cnf

.PHONY clean:
	del *.map *.sym *.cpe *.img *.toc *.exe *.cnf *.cti


