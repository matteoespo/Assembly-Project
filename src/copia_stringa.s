#funzione che copia una stringa da un indirizzo sorgente ad uno destinazione fino al carattere di terminazione "\0"
#l'indirizzo sorgente deve essere contenuto in esi mentre la destinazione di edi

.section .data
.section .text
.global copia_stringa
.type copia_stringa, @function
copia_stringa:

push %eax

ciclo:
cmp $0, (%esi)
jz fine_funzione

movb (%esi), %ah
movb %ah, (%edi)
inc %esi
inc %edi

jmp ciclo


fine_funzione:

pop %eax

ret
