#############################################################################
# Makefile for building: Show
#############################################################################

APPNAME  = Show

####### Compiler, tools and options

ASM      = as
ASMFLAGS = --32
CC       = gcc
CFLAGS   = 
INCPATH  = 
LINK     = ld
LDFLAGS  = -m elf_i386
LIBS     = 

####### Output directory

OUTDIR = ./

####### Files

HEADERS = 
SOURCES = $(APPNAME).asm
OBJECTS = $(APPNAME).o
TARGET   = $(APPNAME) 

first: all
####### Implicit rules

.SUFFIXES: .asm

.asm.o:
	$(ASM) $(ASMFLAGS) $(INCPATH) -o $@ $<

####### Build rules

all: Makefile $(TARGET)

$(TARGET):  $(UICDECLS) $(OBJECTS)
	$(LINK) $(LDFLAGS) -o $(TARGET) $(OBJECTS) $(LIBS)

.PHONY: clean mrproper
clean:
	rm -f *.o *~

mrproper: clean
	rm -f $(APPNAME)
