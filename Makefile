# before doing make do
# export NACL_TOOLCHAIN_ROOT=...nacl_sdk/pepper_17/toolchain/mac_x86/x86_64-nacl

CC	= $(NACL_TOOLCHAIN_ROOT)/bin/gcc
CXX     = $(NACL_TOOLCHAIN_ROOT)/bin/g++
LD      = $(NACL_TOOLCHAIN_ROOT)/bin/g++
CFLAGS	+= -O0 -g -ggdb3 -fno-inline -Wall -m32
OBJS	= sdltest.o
CXXOBJS	= plugin.o

SDL_ROOT = $(HOME)/Sites/nacl_sdk/SDL
SDL_CFLAGS = `$(SDL_ROOT)/bin/sdl-config --cflags`
SDL_LIBS = `$(SDL_ROOT)/bin/sdl-config --libs`
CFLAGS	+= -I$(NACL_TOOLCHAIN_ROOT)/include $(SDL_CFLAGS)
# Uncomment the following line for static linking with GLibC
LIBS += -static -L$(NACL_TOOLCHAIN_ROOT)/lib32 -T $(NACL_TOOLCHAIN_ROOT)/lib/ldscripts/elf_nacl.x.static
LIBS += -m32 $(SDL_LIBS) \
-lppruntime \
-lppapi_cpp \
-lplatform \
-lgio \
-lpthread \
-lsrpc \
-limc_syscalls \
-limc

all: sdltest

sdltest: $(OBJS) $(CXXOBJS)
	$(LD) -o $@ $^ $(LIBS)

$(OBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(CXXOBJS): %.o: %.cc
	$(CXX) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJS) $(CXXOBJS) sdltest
