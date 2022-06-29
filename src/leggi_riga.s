# funzione che recupera i campi di una singola riga dal file di input
# scrive nel file di output il tempo e i livelli di rpm, tempo e velocità
# inoltre modifica i valori massimi(vel, temperatura, rpm) se risultano essere maggiori di quelli già presenti
#
# l'indirizzo dell'input deve essere memorizzato in ESI, mentre l'output in EDI
#
# per recuperare i parametri:
# 24(%ebp) -> indirizzo num_righe
# 20(%ebp) -> indirizzo id del pilota
# 16(%ebp) -> indirizzo velocità max
# 12(%ebp) -> indirizzo rpm max
# 8(%ebp) -> indirizzo temperatura max
# 4(%ebp) -> indirizzo velocità media

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

# Lettura del tempo che viene memorizzato nello stack

movl %esp, %ebp  			#ebp punta ora al pc e lo uso anche per puntare ai parametri passati
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
	inc %esi
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

	movl %ebp, %esp  			#faccio puntare esp al valore iniziale per eliminare la stringa appena scritta dallo stack

# i prossimi parametri da leggere sono salvati nello stack
# 8(%esp) -> velocità
# 4(%esp) -> rpm
# (%esp) -> temperatura

lettura_velocita:
	call atoi
	inc %esi
	pushl %eax
lettura_rpm:
	call atoi
	inc %esi
	pushl %eax
lettura_temperatura:
	call atoi
	inc %esi
	pushl %eax

#se questa è la prima riga ad essere letta bisogna inizializzare i valori massimi
movl 24(%ebp), %eax
movl (%eax), %eax
cmpl $0, %eax
jne confronta_velocita

#inizializzazione
movl 8(%esp), %eax  			#valore velocità da inizializzare
movl 16(%ebp), %ecx 			#indirizzo v_max
movl %eax, (%ecx)

movl 4(%esp), %eax  			#valore rpm da inizializzare
movl 12(%ebp), %ecx 			#indirizzo rpm_max
movl %eax, (%ecx)

movl (%esp), %eax  				#valore temperatura da inizializzare
movl 8(%ebp), %ecx 				#indirizzo temp_max
movl %eax, (%ecx)

jmp scrivi_livelli

#confronto dei valori appena letti con quelli massimi
confronta_velocita:
	movl 8(%esp), %eax 			#velocità
	movl 16(%ebp), %ecx 		#indirizzo v_max
	movl (%ecx), %ebx 			#valore v_max
	cmpl %eax, %ebx
	jle confronta_rpm

	movl %eax, (%ecx)

confronta_rpm:
	movl 4(%esp), %eax 			#rpm
	movl 12(%ebp), %ecx 		#indirizzo rpm_max
	movl (%ecx), %ebx 			#valore rpm_max
	cmpl %eax, %ebx
	jle confronta_temperatura

	movl %eax, (%ecx)
	
confronta_temperatura:
	movl (%esp), %eax 			#temperatura
	movl 8(%ebp), %ecx 			#indirizzo temp_max
	movl (%ecx), %ebx 			#valore temp_max
	cmpl %eax, %ebx
	jle scrivi_livelli

	movl %eax, (%ecx)

scrivi_livelli:
	

fine_funzione_leggi_riga:

#ripristino lo stack allo stato iniziale
movl %ebp, %esp 				#ripristino esp alla posizione del program counter

ret
