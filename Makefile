LIB_XZ = libxz.a

EE_CFLAGS =
EE_OBJS = xz_crc32.o xz_dec_lzma2.o xz_dec_stream.o lzma2.o
EE_LIB = $(LIB_XZ)

EE_INCS  = -I.

all: $(EE_LIB)

install: all
	mkdir -p $(DESTDIR)$(PS2SDK)/ports/include
	mkdir -p $(DESTDIR)$(PS2SDK)/ports/lib
	cp -f $(LIB_XZ) $(DESTDIR)$(PS2SDK)/ports/lib
	cp -f xz.h $(DESTDIR)$(PS2SDK)/ports/include
	cp -f lzma2.h $(DESTDIR)$(PS2SDK)/ports/include

clean:
	rm -f $(EE_LIB) $(EE_OBJS) 

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
