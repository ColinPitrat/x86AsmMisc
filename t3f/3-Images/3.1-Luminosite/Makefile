#############################################################################
# Makefile for building: Ex2
#############################################################################

APPNAME  = Ex2

####### Compiler, tools and options

CC       = gcc
CFLAGS   = -pipe -Wall -Wno-unused-parameter -std=gnu11 -O2  -DQT_NO_DEBUG
INCPATH  = -I$(QTDIR)/mkspecs/default -I. -I. -I$(QTDIR)/include
LINK     = gcc
LIBS     = $(SUBLIBS)  -Wl,-rpath,/usr/lib -L/usr/lib -L/usr/X11R6/lib -lXext -lX11 -lm -lSDL

####### Output directory

OUTDIR = ./

####### Files

HEADERS = 
SOURCES = $(APPNAME).c
OBJECTS = $(APPNAME).o
TARGET   = $(APPNAME) 

first: all
####### Implicit rules

.SUFFIXES: .c

.c.o:
	$(CC) -c $(CFLAGS) $(INCPATH) -o $@ $<

####### Build rules

all: Makefile $(TARGET)

$(TARGET):  $(UICDECLS) $(OBJECTS)
	$(LINK) -o $(TARGET) $(OBJECTS) $(LIBS)

clean:
	rm -f *.o *~

mrproper: clean
	rm -f $(APPNAME)
