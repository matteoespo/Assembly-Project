# converte un valore intero positivo in una stringa
# parametri:
# eax = valore da convertire
# edi = indirizzo di memoria dove salvare la stringa

.section .data
.section .text
.global itoa

.type itoa, @function

itoa:
    
    #salvo i registri che verranno usati dalla funzione
    pushl %ebx
    pushl %ecx
    pushl %edx

    xorl %ecx, %ecx     #lunghezza stringa

continua_a_dividere:

    cmpl   $10, %eax    # confronta 10 con il contenuto di %eax

    jge dividi          # salta a dividi se eax >= 10

    pushl %eax
    incl   %ecx
    movl  %ecx, %ebx

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
    je fine_itoa        # se %ebx=0 è stato stampato tutto e si salta alla fine della funzione

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
    