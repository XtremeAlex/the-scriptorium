#!/bin/bash

# Set Dominio
echo " - - -   - - -   - - -"
echo "JavaCertSnatcher v1.0 By XtremeAlex "
echo "GitHub: https://github.com/XtremeAlex/the-scriptorium JavaCertSnatcher.sh v1.0 By XtremeAlex"
echo " - - -   - - -   - - -"
echo "Inserisci il nome del dominio (es. bubume.it):"
read DOMAIN


# Set variabili
CERTIFICATE_FILE="${DOMAIN}.pem"
CHAIN_FILE="${DOMAIN}_catena.pem"
KEYSTORE_FILE="${DOMAIN}.jks"
KEYSTORE_CHAIN_FILE="${DOMAIN}_catena.jks"
KEYSTORE_PASSWORD=$(echo | openssl rand -base64 6)
LOG="_info.log"
DATE=$(date +%Y%m%d%H%M)
FOLDER_NAME="${DATE}_${DOMAIN}"
FOLDER_NAME_CATENA="_catena_cert"

# Crea la cartella se non esiste gia', questo serve per dare una fattezza di ordine.
if [ ! -d "${FOLDER_NAME}" ]; then
    mkdir "${FOLDER_NAME}"
fi
# Entra nella cartella appena creata
cd "${FOLDER_NAME}"

# Esegui openssl e salva l'output in una variabile da usare sotto
CERTIFICATES=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" -showcerts 2>>$LOG)

# TODO: da sistemare poi i log e i commenti
echo " - - - - - - - - - "

# Controlla se la connessione e' riuscita
if grep -q 'connect:errno=' "$LOG"; then
    echo "Errore: Impossibile connettersi a $DOMAIN o il dominio non esiste." | tee -a >> $LOG
else
    # Salva il certificato principale del server
    echo "$CERTIFICATES" | openssl x509 > "$CERTIFICATE_FILE"
    echo "Certificato del server salvato in $CERTIFICATE_FILE"

    # Salva l'intera catena di certificati del server
    echo "$CERTIFICATES" | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$CHAIN_FILE"
    echo "Catena di certificati salvata in $CHAIN_FILE"
	
	echo " - - - - - - - - - - - - - - - - - - "
    # Crea il keystore per il certificato del server
    if [ -f "$CERTIFICATE_FILE" ]; then
        keytool -import -trustcacerts -file "$CERTIFICATE_FILE" -alias "$DOMAIN" -keystore "$KEYSTORE_FILE" -storepass "$KEYSTORE_PASSWORD" -noprompt
        echo "Keystore per il certificato del server creato in $KEYSTORE_FILE"
    fi

	#  Se il file esiste, crea il keystore per i certificati della catena di
	if [ -f "$CHAIN_FILE" ]; then
		# Per trovare i nomi dei certificati eseguo il seguente comando:
		openssl crl2pkcs7 -nocrl -certfile "$CHAIN_FILE" | openssl pkcs7 -print_certs -noout | grep "subject=" | awk -F ' CN = ' '{print $2}' | awk -F '/' '{print $1}' > "_catena_cert_hierarchy_pkcs7.txt"

		# Divide il file catena in file separati per ogni certificato, da aggiungere dopo nella catena
		csplit -z "$CHAIN_FILE" '/-----BEGIN CERTIFICATE-----/' '{*}'

		# Processa ciascun file di certificato per rinominarlo
		for CERT in xx*; do
			# Estrai il CN dal certificato
			CN=$(openssl x509 -in "$CERT" -noout -subject | sed -n '/^subject/s/^.* CN =//p' | sed 's/\/.*$//')
			
			echo "Verifico il CN: $CN" >> $LOG
			
			# Se il CN non è stato trovato, utilizza un nome generico
			if [ -z "$CN" ]; then
				echo "--Certificato_sconosciuto, controllare il file temporaneo $CERT.error.pem" >> $LOG
				mv "$CERT" "$CERT.error.pem"
				exit
			fi

			# Rimuovi caratteri non validi nel nome del file (in caso ci sia *.bubume.it  non puoi salvarlo)
			CN_FOR_FILE=$(echo "$CN" | sed 's/[\/:*?"<>|\]//g')

			# Crea la cartella interna della catena non esiste già
			if [ ! -d "${FOLDER_NAME_CATENA}" ]; then
				mkdir "${FOLDER_NAME_CATENA}"
			fi

			# Rinominare il file del certificato con il CN
			mv "$CERT" "${FOLDER_NAME_CATENA}/${CN_FOR_FILE}.pem"
			echo "--Salvo" >> $LOG
			
			keytool -import -trustcacerts -file "${FOLDER_NAME_CATENA}/${CN_FOR_FILE}.pem" -alias "${CN}" -keystore "$KEYSTORE_CHAIN_FILE" -storepass "$KEYSTORE_PASSWORD" -noprompt
		done

		echo "Certificati estratti e salvati con il nome del CN"  >> $LOG
		echo "Keystore per la catena di certificati creato in $KEYSTORE_CHAIN_FILE usando la password: [$KEYSTORE_PASSWORD] " >> $LOG
		echo "PASSWORD: [$KEYSTORE_PASSWORD]" >> $LOG
		echo "PASSWORD: [$KEYSTORE_PASSWORD]"
	fi

fi
echo " - - - - - - - - - - - - - - - - - - "
echo "By XtremeAlex -> https://github.com/XtremeAlex/the-scriptorium v1.0"
echo "By XtremeAlex -> https://github.com/XtremeAlex/the-scriptorium " >> $LOG

read -p "Premi un tasto per uscire..." key
