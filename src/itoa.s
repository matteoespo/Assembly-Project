#
# Questa funzione converte <num> in stringa.
# La stringa viene scritta in <output>.
# 
# <num> deve essere contenuto in eax mentre <output> in edi
#

.data

itoa_is_negative:  # flag: indica che <num> e' negativo quando vale 0
    .byte 0

.text
    .global itoa

itoa:
    # Memorizza nello stack i valori dei registri usati
    pushl %ebp
    movl %esp, %ebp

    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx

    # inizia algoritmo per convertire intero in stringa
    movl 8(%ebp), %eax            # EAX = <num>
    movl 12(%ebp), %edi           # EDI = <output>
    movb $0, itoa_is_negative     # itoa_is_negative = 0 (<num> e' negativo)
                                  # (utile quando un programma usa un ciclo:
                                  # ogni volta che la funzione viene richiamata itoa_is_negative NON viene impostato a 1 automaticamente)
    movl $0, %ecx                 # ECX = 0 (contatore numero cifre memorizzate nello stack)

    cmpl $0, %eax                 # se EAX < 0
    jl itoa_continua_a_dividere   # salta a itoa_continua_a_dividere()

    movb $1, itoa_is_negative     # itoa_is_negative = 1 (False)
    neg %eax                      # EAX = -EAX (cambia segno)


itoa_continua_a_dividere:
    # Richiama itoa_dividi() per dividere per 10 EAX
    # finche' EAX <= -10, poi inserisci nello stack l'ultima
    # cifra e se il numero e' negativo imposta EDI[0] = '-'

    cmpl $-10, %eax             # se EAX <= -10
    jle itoa_dividi             # salta a itoa_dividi()

    # -- tutte le cifre meno l'ultima sono nello stack

    neg %eax                    # cambia segno all'ultima cifra
    pushl %eax                  # salva nello stack l'ultima cifra
    incl %ecx                   # ECX++

    xorl %ebx, %ebx             # EBX = 0 (usato per scorrere EDI)

    movb itoa_is_negative, %al  # AL = itoa_is_negative
    cmpb $0, %al                # se AL != 0 (<num> positivo)
    jne itoa_scrivi             # salta a itoa_scrivi()

    # numero negativo, metti meno in prima posizione
    # e sposta gli indici per scorrere EDI

    movb $45, (%edi, %ebx)      # EDI[EBX] = '-' (EDI[0] = '-')
    incl %ebx                   # EBX++
    incl %ecx                   # ECX++
    jmp itoa_scrivi             # salta a itoa_scrivi()


itoa_dividi:
    # Ricava l'ultima cifra da EAX (EAX % 10),
    # la inserisce nello stack e impone EAX /= 10.

    movl $10, %ebx      # EBX = 10 (divisore)
    cdq                 # estendo il segno di EAX su EDX
    idivl %ebx          # EAX = EDX:EAX / EBX | EDX = EDX:EAX % EBX (EBX = 10)
    neg %edx            # EDX = -EDX (risultato di -x/10 con x positivo e' -y)
    pushl %edx          # memorizza cifra nello stack
    incl %ecx           # ECX++ (incrementa contatore cifre)
    jmp	itoa_continua_a_dividere


itoa_scrivi:
    # Tutte le cifre sono nello stack,
    # questa funzione recupera dallo stack le cifre,
    # le converte in carattere e le inserisce in EDI

    cmpl %ecx, %ebx         # se EBX == ECX non ho piu' cifre nello stack
    je itoa_fine            # salta a itoa_fine()

    popl %eax               # EAX = cifra nello stack
    addb $48, %al           # EAX += 48 (converto intero in cifra)
    movb %al, (%edi, %ebx)  # EDI[EBX] = EAX (aggiungo cifra alla stringa)
    incl %ebx               # incrementa di 1 l'indice

    jmp itoa_scrivi         # ritorna all'etichetta itoa_scrivi per stampare
                            # il prossimo carattere.


itoa_fine:
    # Fine algoritmo: metti \0 a fine stringa,
    # ripristina i valori dei registri e ritorna al chiamante

    movb $0, (%edi, %ecx)  # EDI[ECX] = '\0'

    # Ripristina valori originali dei registri usati
    # e restituisci il controllo al chiamante
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    popl %ebp
    ret