.section .data

virgola:
	.ascii ","
line_feed:
	.ascii "\n"
low:
	.ascii "LOW"
medium:
	.ascii "MEDIUM"
high:
	.ascii "HIGH"

.section .text
.global leggi_riga

.type leggi_riga, @function

leggi_riga:

# per recuperare i parametri:
# 20(%ebp) -> indirizzo id del pilota
# 16(%ebp) -> indirizzo velocità max
# 12(%ebp) -> indirizzo rpm max
# 8(%ebp) -> indirizzo temperatura max
# 4(%ebp) -> indirizzo velocità media

# Lettura del tempo che viene memorizzato nello stack

movl %esp, %ebp  			#uso ebp per puntare ai parametri passati
xorl %ebx, %ebx 			#in ebx memorizzo la lunghezza della stringa del tempo

lettura_stringa_tempo:
	movb (%esi), %dl
	incl %esi
	cmp virgola, %dl
	jz stringa_tempo_finita

	push %dx
	inc %bl
	jmp lettura_stringa_tempo

stringa_tempo_finita:
	pushw $0
	inc %bl

	#calcolo della lunghezza effettiva della stringa del tempo, data da: (numero di caratteri)*2 perchè ogni carattere è salvato su due byte
	movl %ebx, %eax 			#sposto la lunghezza della stringa in eax per fare la moltiplicazione
	mov $2, %bl
	mulb %bl 					#moltiplico la lunghezza della stringa per 4
	push %eax 					#salvo la lunghezza nello stack

# Lettura dell'id del pilota e controllo che sia quello che cerchiamo
lettura_id:
	call atoi 					#in eax c'è l'id letto dal file di input
	movl 20(%ebp), %ecx 		#carico in ecx l'indirizzo della variabile che contiene l'id
	cmpl (%ecx), %eax  			#confronto con il valore che c'è nel file di input
	jz scrivi_stringa_tempo

# Se l'id è diverso, incremento esi fino a farlo puntare alla prossima riga
id_diverso:
	incl %esi
	movb (%esi), %dl
	cmp %dl, line_feed
	jnz id_diverso
	incl %esi
	jmp fine_funzione_leggi_riga

scrivi_stringa_tempo:
	popl %ecx 					#recupero dallo stack la lunghezza della stringa
	subl $2, %ecx

	scrivi_carattere_stringa_tempo:
		movw (%esp, %ecx), %ax
		movb %al, (%edi)
		incl %edi
		subl $2, %ecx
		cmpw $0, (%esp, %ecx)
		jnz scrivi_carattere_stringa_tempo

	movl %ebp, %esp  			#faccio puntare esp a dove si trovano i parametri per eliminare la stringa appena scritta


fine_funzione_leggi_riga:

#ripristino lo stack allo stato iniziale
movl %ebp, %esp 				#ripristino esp alla posizione del pc

ret
