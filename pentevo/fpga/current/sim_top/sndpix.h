/* MTI_DPI */

/*
 * Copyright 2002-2010 Mentor Graphics Corporation.
 *
 * Note:
 *   This file is automatically generated.
 *   Please do not edit this file - you will lose your edits.
 *
 * Settings when this file was generated:
 *   PLATFORM = 'linux'
 */
#ifndef INCLUDED_SNDPIX
#define INCLUDED_SNDPIX

#ifdef __cplusplus
#define DPI_LINK_DECL  extern "C" 
#else
#define DPI_LINK_DECL 
#endif

#include "svdpi.h"


DPI_LINK_DECL DPI_DLLESPEC
int
sndpix(
    int hcoord,
    int vcoord,
    int rrggbb,
    int hperiod,
    int vperiod);

#endif 
