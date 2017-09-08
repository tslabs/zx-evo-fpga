
{
  ft_ccmd((9UL << 24) | ((func & 7L) << 8) | ((ref & 255L) << 0));
}

{
  ft_ccmd((31UL << 24) | prim);
}

{
  ft_ccmd((5UL << 24) | handle);
}

{
  ft_ccmd((0x28UL << 24) | ((linestride >> 8) & 12L) | ((height >> 9) & 3L));
  ft_ccmd((7UL << 24) | ((format & 31L) << 19) | ((linestride & 1023L) << 9) | ((height & 511L) << 0));
}
void ft_BitmapSize(u8 filter, u8 wrapx, u8 wrapy, u16 width, u16 height)
{
  u8 fxy = (filter << 2) | (wrapx << 1) | (wrapy);
  ft_ccmd((0x29UL << 24) | ((width >> 7) & 12L) | ((height>> 9) & 3L));
  ft_ccmd((8UL << 24) | ((u32)fxy << 18) | ((width & 511L) << 9) | ((height & 511L) << 0));
}
void ft_BitmapSource(u32 addr)
{
  ft_ccmd((1UL << 24) | ((addr & 0x3FFFFFL) << 0));
}

{
  ft_ccmd((21UL << 24) | ((a & 131071L) << 0));
}

{
  ft_ccmd((22UL << 24) | ((b & 131071L) << 0));
}

{
  ft_ccmd((23UL << 24) | ((c & 16777215L) << 0));
}

{
  ft_ccmd((24UL << 24) | ((d & 131071L) << 0));
}

{
  ft_ccmd((25UL << 24) | ((e & 131071L) << 0));
}

{
  ft_ccmd((26UL << 24) | ((f & 16777215L) << 0));
}

{
  ft_ccmd((11UL << 24) | ((src & 7L) << 3) | ((dst & 7L) << 0));
}

{
  ft_ccmd((29UL << 24) | ((dest & 2047L) << 0));
}

{
  ft_ccmd((6UL << 24) | ((cell & 127L) << 0));
}

{
  ft_ccmd((15UL << 24) | ((alpha & 255L) << 0));
}

{
  ft_ccmd((2UL << 24) | ((red & 255L) << 16) | ((green & 255L) << 8) | ((blue & 255L) << 0));
}

{
  ft_ccmd((2UL << 24) | (rgb & 0xffffffL));
}

{
  u8 m = (c << 2) | (s << 1) | t;
  ft_ccmd((38UL << 24) | m);
}

{
  ft_ccmd((38UL << 24) | 7);
}

{
  ft_ccmd((17UL << 24) | ((s & 255L) << 0));
}

{
  ft_ccmd((18UL << 24) | ((s & 255L) << 0));
}

{
  ft_ccmd((16UL << 24) | ((alpha & 255L) << 0));
}

{
  ft_ccmd((32UL << 24) | ((r & 1L) << 3) | ((g & 1L) << 2) | ((b & 1L) << 1) | ((a & 1L) << 0));
}

{
  ft_ccmd((4UL << 24) | ((red & 255L) << 16) | ((green & 255L) << 8) | ((blue & 255L) << 0));
}

{
  ft_ccmd((4UL << 24) | (rgb & 0xffffffL));
}

{
  ft_ccmd(0UL << 24);
}

{
  ft_ccmd(33UL << 24);
}

{
  ft_ccmd((30UL << 24) | ((dest & 2047L) << 0));
}

{
  ft_ccmd((14UL << 24) | ((width & 4095L) << 0));
}

{
  ft_ccmd((37UL << 24) | ((m & 1L) << 0));
}

{
  ft_ccmd((13UL << 24) | ((size & 8191L) << 0));
}

{
  ft_ccmd(35UL << 24);
}

{
  ft_ccmd(36UL << 24);
}

{
  ft_ccmd(34UL << 24);
}

{
  ft_ccmd((28UL << 24) | ((width & 1023L) << 10) | ((height & 1023L) << 0));
}

{
  ft_ccmd((27UL << 24) | ((x & 511L) << 9) | ((y & 511L) << 0));
}

{
  ft_ccmd((10UL << 24) | ((func & 7L) << 16) | ((ref & 255L) << 8) | ((mask & 255L) << 0));
}

{
  ft_ccmd((19UL << 24) | ((mask & 255L) << 0));
}

{
  ft_ccmd((12UL << 24) | ((sfail & 7L) << 3) | ((spass & 7L) << 0));
}

{
  ft_ccmd((20UL << 24) | ((mask & 1L) << 0));
}

{
  ft_ccmd((3UL << 24) | s);

void ft_Vertex2f(s16 x, s16 y)
  ft_ccmd((1UL << 30) | ((x & 32767L) << 15) | ((y & 32767L) << 0));
}

void ft_Vertex2ii(u16 x, u16 y, u8 handle, u8 cell)
}

void ft_VertexFormat(u8 f)
  ft_ccmd((0x27UL << 24) | (f & 7L));