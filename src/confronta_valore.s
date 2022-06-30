# funzione che mette a confronto un valore passato come parametro con il rispettivo minimo e massimo sempre passati come parametro.
#
# Descrizione variabili e parametri:
#
# Parametri input: 
#	• ebx --> valore da confrontare;
#	• ecx --> valore minimo dell'intervallo;
#	• edx --> valore massimo dell'intervallo;
#
# Valore di ritorno:	
#	• eax --> risultato del confronto, vale 0 se il valore in ebx è > del minimo (ecx) e <= del massimo (edx),
#		-1 se il valore è <= rispetto al minimo (ecx), 1 se maggiore del massimo (edx).

.section .data
.section .text
.global confronta_valori

.type confronta_valori, @function
confronta_valori:

xorl %eax, %eax   # azzero il registro eax il quale conterrà l'esito del confronto
cmpl %ecx, %ebx	  # confronto il valore passato come parametro con il minimo
jle LESS_EQUAL       
jmp GREATER_THAN_MIN     

LESS_EQUAL:		# ebx <= ecx
	movl $-1, %eax
	jmp FINE_CONFRONTA_VALORI
	
GREATER_THAN_MIN:	# ebx > ecx
	cmpl %edx, %ebx
	jg GREATER_THAN_MAX 
	jmp WITHIN_THE_RANGE

GREATER_THAN_MAX: 	# ebx > edx > ecx
	movl $1, %eax
	jmp FINE_CONFRONTA_VALORI

WITHIN_THE_RANGE: 	# ebx > ecx && ebx <= edx
	movl $0, %eax

FINE_CONFRONTA_VALORI:
	ret
