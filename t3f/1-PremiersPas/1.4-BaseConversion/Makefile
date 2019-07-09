#############################################################################
# Makefile for building: BaseConversion
#############################################################################

APPNAME  = BaseConversion

####### Compilateur, outils et options

ASM      = as
ASMFLAGS = --32
INCPATH  = 
LINK     = ld
LDFLAGS  = -m elf_i386
LIBS     = 

####### Fichiers

OBJECTS = $(APPNAME).o
TARGET   = $(APPNAME) 

####### Regles implicites

.SUFFIXES: .S

.S.o:
	$(ASM) $(ASMFLAGS) $(INCPATH) -o $@ $<

####### Regles de construction

first: all
all: $(TARGET)

$(TARGET): $(OBJECTS) 
	$(LINK) $(LDFLAGS) -o $(TARGET) $(OBJECTS) $(LIBS)

.PHONY: clean mrproper
clean:
	rm -f *.o *~

mrproper: clean
	rm -f $(TARGET)
