#pragma once
#include "emul.h"

void wnd_resize(int scale);
void correct_exit();

void main_mouse();
void main_reset();
void main_debug();
void main_visuals();
void main_fullscr();
void main_pause();
void main_selectfix();
void main_selectsnd();
void main_incfix();
void main_decfix();
void main_incfix10();
void main_decfix10();
void main_leds();
void main_status();
void main_maxspeed();
void main_selectfilter();
void main_selectdriver();
void main_poke();
void main_starttape();
void main_reset128();
void main_resetsys();
void main_reset48();
void main_resetbas();
void main_resetdos();
void main_resetcache();
void main_nmi();
void main_nmidos();
void main_nmicache();
void main_tapebrowser();
void savesnap();
void opensnap();
void qsave1();
void qsave2();
void qsave3();
void qload1();
void qload2();
void qload3();
void main_keystick();
void main_autofire();
void main_save_ram();
void main_save();
void main_pastetext();
void main_size1();
void main_size2();
void main_sizem();
void main_help();
void main_flictoggle();
void mon_help();
void m_nmi(rom_mode page);
