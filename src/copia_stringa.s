# funzione che copia una stringa da un indirizzo sorgente ad uno destinazione fino al carattere di terminazione "\0"
# l'indirizzo sorgente deve essere contenuto in EAX mentre la destinazione in EDI
#
# dato che bisogna copiare anche stringhe dallo stack, in questo caso l'indirizzo
# va decrementato. Quindi nel registro EBX mettiamo un altro parametro che indica
# come prelevare la stringa dall'indirizzo EAX, se vale 0 bisogna incrementare,
# altrimenti bisogna decrementare.

.section .data
.section .text
.global copia_stringa
.type copia_stringa, @function
copia_stringa:

push %ecx  					#salvo ecx perchè vado a modificarlo in seguito

ciclo:
cmp $0, (%eax)
jz fine_funzione

movb (%eax), %cl
movb %cl, (%edi)

cmpl $0, %ebx
jz incrementa

#decrementa
dec %eax
jmp continua

incrementa:
inc %eax

continua:
inc %edi
jmp ciclo


fine_funzione:

pop %ecx

ret
