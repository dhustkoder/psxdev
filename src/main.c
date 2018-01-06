#include <stdlib.h>
#include <stdio.h>
#include <libgte.h>
#include <libgpu.h>
#include <libgs.h>
#include <libetc.h>
#include <libpad.h>


#define OT_LENGTH 1       // the ordertable length
#define PACKETMAX 18      // the maximum number of objects on the screen
#define SCREEN_WIDTH  320 // screen width
#define	SCREEN_HEIGHT 256 // screen height (240 NTSC, 256 PAL)

u_long _ramsize   = 0x00200000; // force 2 megabytes of RAM
u_long _stacksize = 0x00004000; // force 16 kilobytes of stack

static GsOT myOT[2];                       // ordering table header
static GsOT_TAG myOT_TAG[2][1<<OT_LENGTH]; // ordering table unit
static PACKET GPUPacketArea[2][PACKETMAX]; // GPU packet data
static u_char paddata[2][34];              // pad 1 and 2 data
static short currrent_buffer = 0;          // holds the current buffer number


static void graphics(void)
{
	SetVideoMode(MODE_PAL);

	// set the graphics mode resolutions (GsNONINTER for NTSC, and GsINTER for PAL)
	GsInitGraph(SCREEN_WIDTH, SCREEN_HEIGHT, GsINTER|GsOFSGPU, 1, 0);

	// tell the GPU to draw from the top left coordinates of the framebuffer
	GsDefDispBuff(0, 0, 0, SCREEN_HEIGHT);
	
	// init the ordertables
	myOT[0].length = OT_LENGTH;
	myOT[1].length = OT_LENGTH;
	myOT[0].org = myOT_TAG[0];
	myOT[1].org = myOT_TAG[1];
	
	// clear the ordertables
	GsClearOt(0, 0, &myOT[0]);
	GsClearOt(0, 0, &myOT[1]);
}

static void display(void)
{
	// refresh the font
	FntFlush(-1);
	
	// get the current buffer
	currrent_buffer = GsGetActiveBuff();
	
	// setup the packet workbase
	GsSetWorkBase((PACKET*)GPUPacketArea[currrent_buffer]);
	
	// clear the ordering table
	GsClearOt(0, 0, &myOT[currrent_buffer]);
	
	// wait for all drawing to finish
	DrawSync(0);
	
	// wait for v_blank interrupt
	VSync(0);
	
	// flip the double buffers
	GsSwapDispBuff();
	
	// clear the ordering table with a background color (R,G,B)
	GsSortClear(0, 0, 0, &myOT[currrent_buffer]);
	
	// draw the ordering table
	GsDrawOt(&myOT[currrent_buffer]);
}


int main(void)
{
	graphics();        // setup the graphics (seen below)
	FntLoad(960, 256); // load the font from the BIOS into the framebuffer

	// screen X,Y | max text length X,Y | autmatic background 
	// clear 0,1 | max characters
	SetDumpFnt(FntOpen(5, 20, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 512));

	PadInitDirect(&paddata[0][0], &paddata[1][0]);

	for (;;) {
		FntPrint("\tHello Playstation 1\n\n\n"
		         "\trafaelmoura.dev@gmail.com\n\n\n"
		         "\tgithub.com/dhustkoder/psprog\n\n\n"
			 "\tpsxdev.net\n\n\n"
			 "\tPad 1 data: %X %X %X",
		         paddata[0][1], paddata[0][2], paddata[0][3]);
		
		PadStartCom();
		display();
		PadStopCom();
	}
}

