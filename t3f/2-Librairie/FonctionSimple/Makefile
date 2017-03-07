#############################################################################
# Makefile for building: FonctionSimple
#############################################################################

APPNAME  = FonctionSimple

####### Compilateur, outils et options

ASM      = as
ASMFLAGS = 
INCPATH  = 
LINK     = ld
LDFLAGS  = 
LIBS     = 

####### Fichiers

OBJECTS = $(APPNAME).o diff_mul_add.o
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

.PHONY: clean
clean:
	rm -f *.o *~

mrproper: clean
	rm -f $(TARGET)
