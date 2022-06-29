# eax = valore da convertire
# edi = indirizzo dove salvare la stringa

.section .data
.section .text
    .global itoa

.type itoa, @function

itoa:
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl   $0, %ecx     # carica il numero 0 in %ecx


continua_a_dividere:

    cmpl   $10, %eax    # confronta 10 con il contenuto di %eax

    jge dividi          # salta all'etichetta dividi se %eax e'
                        # maggiore o uguale a 10

    pushl %eax          # salva nello stack il contenuto di %eax
    incl   %ecx         # incrementa di 1 il valore di %ecx per
                        # contare quante push eseguo;
                        # ad ogni push salvo nello stack una cifra 
                        # del numero (a partire da quella meno
                        # significativa)

    movl  %ecx, %ebx    # copia in %ebx il valore di %ecx
                        # il numero di cifre che sono state 
                        # caricate nello stack

    jmp stampa          # salta all'etichetta stampa


dividi:

    movl  $0, %edx
    movl $10, %ebx
    divl  %ebx
    pushl  %edx
    incl   %ecx
    jmp continua_a_dividere 

stampa:

    cmpl   $0, %ebx
    je fine_itoa        # se %ebx=0 ho stampato tutto salto alla 
                        # fine della funzione

    popl  %eax          # preleva l'elemento da stampare dallo stack

    movb  %al, (%edi)
    addb  $48, (%edi)
    inc %edi

    decl   %ebx
    jmp   stampa


fine_itoa:

    popl %edx
    popl %ecx
    popl %ebx

    ret
    