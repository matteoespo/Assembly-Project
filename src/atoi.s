# funzione che converte una stringa in numero
# Parametri di input:
#   ESI - Stringa da convertire
# Parametri di output:
#   EAX - Valore convertito

.section .data
.section .text
.global atoi

.type atoi, @function

atoi:
	# Salviataggio dei registri generali da usare
	pushl %ebx

	xorl %eax, %eax   # azzero il registro EAX per contenere il risultato
	xorl %ebx, %ebx   # azzero EBX
	movl $10, %ecx    # sposto 10 in ECX che conterrà il valore moltiplicativo

_atoi_loop:
	xorl %ebx, %ebx
	movb (%esi), %bl  # sposto un byte dalla stringa in BL
	subb $48, %bl     # sottraggo il valore ASCII dello 0 a BL, per avere un valore intero

	cmpb $0, %bl      # Se il numero è minore di 0
	jl _atoi_end      # allora esco dal ciclo
	cmpb $10, %bl     # Se il numero è maggiore o uguale a 10
	jge _atoi_end     # esco dal ciclo

	mull %ecx         # altrimenti moltiplico EAX per 10 (10 messo precedentemente in ECX)
	addl %ebx, %eax   # aggiungo a EAX il valore attuale
	incl %esi         # incremento ESI

	jmp _atoi_loop    # rieseguo il ciclo

_atoi_end:
	popl %ebx

	ret
