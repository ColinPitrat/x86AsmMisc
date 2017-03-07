#############################################################################
# Makefile for building: Echo
#############################################################################

APPNAME  = Echo

####### Compiler, tools and options

ASM      = as
ASMFLAGS = 
CC       = gcc
CFLAGS   = 
INCPATH  = 
LINK     = ld
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
	$(LINK) -o $(TARGET) $(OBJECTS) $(LIBS)

clean:
	rm -f *.o *~

mrproper: clean
	rm -f $(APPNAME)
