
all: bin/telemetry

obj/main.o: src/main.c
	gcc -m32 -c -g src/main.c -o obj/main.o

obj/telemetry.o: src/telemetry.s
	gcc -m32 -c -g src/telemetry.s -o obj/telemetry.o

obj/copia_stringa.o: src/copia_stringa.s
	gcc -m32 -c -g src/copia_stringa.s -o obj/copia_stringa.o

obj/atoi.o: src/atoi.s
	gcc -m32 -c -g src/atoi.s -o obj/atoi.o

obj/confronta_valori.o: src/confronta_valori.s
	gcc -m32 -c -g src/confronta_valori.s -o obj/confronta_valori.o

obj/leggi_riga.o: src/leggi_riga.s
	gcc -m32 -c -g src/leggi_riga.s -o obj/leggi_riga.o

bin/telemetry: obj/telemetry.o obj/copia_stringa.o obj/main.o obj/confronta_valori.o obj/atoi.o obj/leggi_riga.o
	gcc -m32 -g obj/telemetry.o obj/copia_stringa.o obj/main.o obj/confronta_valori.o obj/atoi.o obj/leggi_riga.o -o bin/telemetry

clean:
	rm -f obj/*.o bin/telemetry
