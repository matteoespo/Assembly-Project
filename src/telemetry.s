.section .data

pilot_0_str:
    .string   "Pierre Gasly\n"
pilot_1_str:
    .string   "Charles Leclerc\n"
pilot_2_str:
    .string   "Max Verstappen\n"
pilot_3_str:                       
    .string   "Lando Norris\n"
pilot_4_str:
    .string   "Sebastian Vettel\n"
pilot_5_str:
    .string   "Daniel Ricciardo\n"
pilot_6_str: 
    .string   "Lance Stroll\n"
pilot_7_str:
    .string   "Carlos Sainz\n"
pilot_8_str:
    .string   "Antonio Giovinazzi\n"
pilot_9_str:
    .string   "Kevin Magnussen\n"
pilot_10_str:
    .string  "Alexander Albon\n"
pilot_11_str:
    .string  "Nicholas Latifi\n"
pilot_12_str:
    .string  "Lewis Hamilton\n"
pilot_13_str:
    .string  "Romain Grosjean\n"
pilot_14_str:
    .string  "George Russell\n"
pilot_15_str:
    .string  "Sergio Perez\n"
pilot_16_str:
    .string  "Daniil Kvyat\n"
pilot_17_str:
    .string  "Kimi Raikkonen\n"
pilot_18_str:
    .string  "Esteban Ocon\n"
pilot_19_str:
    .string  "Valtteri Bottas\n"

#calcolo la lunghezza perchè mi serve l'indirizzo dell'ultimo carattere
len_last_pilot:
    .long . - pilot_19_str

invalid_pilot_str:
.string "Invalid\n"

pilot_id:
    .long 0

v_max:              #velocità massima trovata
    .long 0
rpm_max:            #numero di giri massimo
    .long 0
temp_max:           #temperatura massima
    .long 0
v_media:            #velocità media
    .long 0
num_righe:          #numero di righe corrispondenti al pilota da analizzare
    .long 0

.section .text
.global telemetry

telemetry:

movl 4(%esp), %esi                  #puntatore al file di input
movl 8(%esp), %edi                  #puntatore al file di output

#salvataggio dei registri generali nello stack
push %eax
push %ebx
push %ecx
push %edx

#xorl %edx, %edx                     #offset per il nome del pilota da cercare

#RICERCA ID DEL PILOTA

push %esi

leal pilot_0_str, %eax              #puntatore al primo carattere del vettore
leal pilot_19_str, %ebx             #puntatore all'ultimo carattere
addl len_last_pilot, %ebx

ciclo_stringhe_piloti:

    ciclo_stringa:
    movb (%eax), %cl                #carattere del pilota da confrontare
    movb (%esi), %ch          #carattere del pilota di input
    cmp %cl, %ch                    #controllo se i caratteri sono uguali
    jnz stringhe_diverse

    #se i caratteri sono uguali e siamo arrivati allo "\n"(fine stringa) allora vuol dire che le stringhe sono uguali
    cmp $10, %ch
    jz pilota_trovato

    #altrimenti andiamo al prossimo carattere
    inc %esi
    inc %eax
    jmp ciclo_stringa

    #se sono diverse incremento il puntatore fino al prossimo pilota da confrontare
    stringhe_diverse:
        cmp $0, %cl
        jz fine_stringa
        incl %eax
        movb (%eax), %cl
        jmp stringhe_diverse


    #siamo arrivati alla fine della stringa
    fine_stringa:
    incl pilot_id
    movl (%esp), %esi #reset di esi al valore iniziale
    inc %eax
    
cmpl %eax, %ebx
jnz ciclo_stringhe_piloti

#se arriviamo alla fine senza saltare a pilota_trovato allora non è stato trovato il pilota
pop %esi

#stampa invalid
leal invalid_pilot_str, %esi
call copia_stringa
jmp fine_programma

pilota_trovato:
addl $4, %esp               #elimino il vecchio valore di esi dallo stack
movb pilot_id, %al#
addb $48, %al#
movb %al, (%edi)#
inc %edi
inc %esi

#LETTURA DELLE RIGHE DEL FILE

fine_programma:

#backup dei registri generali
pop %edx
pop %ecx
pop %ebx
pop %eax

ret
