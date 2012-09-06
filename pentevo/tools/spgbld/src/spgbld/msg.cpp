
#include "stdafx.h"
#include "defs.h"
#include "msg.h"

void print_help()
{
	printf(STR(SB_VER));
	printf("\n\n");
	printf("Build:	  spgbld.exe -b <input.ini> <output.spg> [-c <pack method>]\n");
	//printf("Info:	  spgbld.exe -i <input.spg>\n");
	//printf("Unpack:	  spgbld.exe -u <input.spg>\n");
	//printf("Re-pack:  spgbld.exe -r <input.spg> <output.spg> [-c <pack method>]\n");
}

#define	ERR(a, b)	case (a): \
			printf(STR(b)); \
			printf("\n"); \
			exit(i);

void error(int i)
{
	switch(i)
	{
		ERR (RC_OK, ER_OK)
		ERR (RC_NOARG, ER_NOARG)
		ERR (RC_NOINI, ER_NOINI)
		ERR (RC_UNK, ER_UNK)
		ERR (RC_ALGN, ER_ALGN)
		ERR (RC_NOFILE, ER_NOFILE)
		ERR (RC_PACK, ER_PACK)
		ERR (RC_0BLK, ER_0BLK)
		ERR (RC_BIG, ER_BIG)
		ERR (RC_ZERO, ER_ZERO)
	}
}