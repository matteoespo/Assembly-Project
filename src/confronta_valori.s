# funzione che confronta due valori passati come parametro alla funzione
# Parametri input: ebx, ecx --> valori da confrontare
# Parametri output:	eax --> risultato confronto (0 se i due numeri sono uguali, 1 se il valore contenuto in ebx è maggiore rispetto a quello contenuto in ecx, -1 viceversa)

.section .data
.section .text
.global confronta_valori

.type confronta_valori, @function
confronta_valori:


xorl %eax, %eax   # azzero il registro eax il quale conterrà l'esito del confronto
cmpl %ebx, %ecx
je EQUAL       # ebx = ecx
jg GREATER     # ebx > ecx
jmp LESS       # ebx < ecx

EQUAL:
	movl $0, %eax
	jmp FINE_CONFRONTA_VALORI
	
GREATER:
	movl $1, %eax
	jmp FINE_CONFRONTA_VALORI
	
LESS:
	movl $-1, %eax

FINE_CONFRONTA_VALORI:
	ret