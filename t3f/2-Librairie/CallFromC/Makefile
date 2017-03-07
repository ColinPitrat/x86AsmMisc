all:
	gcc -o InlineFromC InlineFromC.c
# On peut builder en une seule commande un executable créé à partir de fichiers C et assembleur
	gcc -o CallFromC CallFromC.c Function.S
	g++ -o CallFromCpp CallFromCpp.cc Function.S
# Si l'on ne précise pas extern "C" en C++, les symboles sont manglés. On peut le constater en faisant nm WrongCallFromCpp.o
	g++ -c -o WrongCallFromCpp.o WrongCallFromCpp.cc

clean:
	rm -f *.o

mrproper: clean
	rm -f InlineFromC CallFromC CallFromCpp
