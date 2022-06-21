
all: bin/telemetry

obj/main.o: src/main.c
	gcc -m32 -c -g src/main.c -o obj/main.o

obj/telemetry.o: src/telemetry.s
	gcc -m32 -c -g src/telemetry.s -o obj/telemetry.o

obj/copia_stringa.o: src/copia_stringa.s
	gcc -m32 -c -g src/copia_stringa.s -o obj/copia_stringa.o

bin/telemetry: obj/telemetry.o obj/copia_stringa.o obj/main.o
	gcc -m32 -g obj/telemetry.o obj/copia_stringa.o obj/main.o -o bin/telemetry

clean:
	rm -f obj/*.o bin/telemetry
