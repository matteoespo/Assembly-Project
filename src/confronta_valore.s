# funzione che mette a confronto un valore passato come parametro con il rispettivo minimo e massimo sempre passati come parametro.
# Parametri input: ebx (valore da confrontare), ecx (valore minimo), edx (valore massimo)
# Parametri output:	eax --> risultato confronto 
# La funzione ritorna 0 se i il valore è > del minimo e <= del massimo, -1 se il valore è <= rispetto al minimo, 1 se maggiore del massimo)

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
