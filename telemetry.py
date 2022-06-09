import pandas as pd
import numpy as np
import sys

#Recupero i parametri 
INPUT_FILENAME=sys.argv[1]
OUTPUT_FILENAME=sys.argv[2]

# Definisco le soglie
RPM_LOW = 5000
RPM_MEDIUM = 10000

SPEED_LOW = 100
SPEED_MEDIUM = 250

TEMPERATURE_LOW = 90 
TEMPERATURE_MEDIUM = 110

LISTA_PILOTI=["Pierre Gasly",
"Charles Leclerc",
"Max Verstappen",
"Lando Norris",
"Sebastian Vettel",
"Daniel Ricciardo",
"Lance Stroll",
"Carlos Sainz",
"Antonio Giovinazzi",
"Kevin Magnussen",
"Alexander Albon",
"Nicholas Latifi",
"Lewis Hamilton",
"Romain Grosjean",
"George Russell",
"Sergio Perez",
"Daniil Kvyat",
"Kimi Raikkonen",
"Esteban Ocon",
"Valtteri Bottas"]


if __name__=="__main__":

	# apro il file di input
	input_file = open(INPUT_FILENAME)
	
	#recupero il nume del pilota leggendo la prima riga
	nome_pilota=input_file.readline().split("\n")[0]

	try:
		# recupero posizione di pilota all'interno della lista. 
		numero_pilota=LISTA_PILOTI.index(nome_pilota)
	
		# leggo il file come un csv saltando la prima riga relativa al nome pilota
		df = pd.read_csv(INPUT_FILENAME,skiprows=1)
	
		# setto il file con nomi colonne per usare al meglio pandas e fare ricerche per nome colonna
		df.columns = ['time','pilot','speed','rpm','temperature']
		
		# ritorna nel dataframe solo le occorrenze del pilota in input
		df=df.loc[df['pilot'] == numero_pilota]
		
		# sommo tutti i valori di speed
		somma_speed=df['speed'].sum()
		
		#recupero numero campioni
		n_campioni=len(df.index)
		
		# Calcolo velocità media come divisione intera
		speed_avg=int(somma_speed/n_campioni)
		
		# Massimi di ogni misura
		rpm_max=df['rpm'].max()
		speed_max=df['speed'].max()
		temperature_max=df['temperature'].max()
	
		# Variabili stringa soglia
		speed_level=""
		temperature_level=""
		rpm_level=""
		riga=""
		
		# leggo riga per riga nel frame del solo pilota richiesto e calcolo i valori delle soglie 
		with open(OUTPUT_FILENAME, 'w') as f:
			for index, row in df.iterrows():
			
				tempo=row['time']
				speed=row['speed']
				rpm=row['rpm']
				temperature=row['temperature']						
	
				if speed <= SPEED_LOW:			# Calcolo livello velocità
					speed_level= "LOW"
				elif speed <= SPEED_MEDIUM:
					speed_level="MEDIUM"
				else:
					speed_level="HIGH"
			
				if rpm <= RPM_LOW:				# Calcolo livello RPM
					rpm_level= "LOW"
				elif rpm <= RPM_MEDIUM:
					rpm_level="MEDIUM"
				else:
					rpm_level="HIGH"
			
				if temperature <= TEMPERATURE_LOW:			# Calcolo livello Temperatura
					temperature_level= "LOW"
				elif temperature <= TEMPERATURE_MEDIUM:
					temperature_level="MEDIUM"
				else:
					temperature_level="HIGH"
	
				# sistemo la riga da scrivere 
				riga=str(tempo)+","+rpm_level+","+temperature_level+","+speed_level+"\n"
				# scrivo la riga nel file
				f.write(riga)
	
			# Ultima riga del file 
			ultima_riga=str(rpm_max)+","+str(temperature_max)+","+str(speed_max)+","+str(speed_avg)+"\n"
			# Scrivo la riga
			f.write(ultima_riga)
	
	except ValueError:
		with open(OUTPUT_FILENAME, 'w') as f:
			f.write("Invalid") 	
