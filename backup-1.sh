#!/bin/bash
set -e


ORIGINE="/home/lorenzo/LABS/source"
DESTINAZIONE="/home/lorenzo/LABS/DESTINAZIONE"
CARTELLA_TEMP="/home/lorenzo/LABS/staging"

DATA=$(date +%Y%m%d_%H%M%S)
NOME_FILE="backup_${DATA}.tar.gz"


LOG_DIR="/home/lorenzo/LABS/logs"
LOG_FILE="$LOG_DIR/backup_$(date +%Y%m%d).log"
GIORNI_RETENTION_LOG=30

scrivi_log() {
    printf "%s - %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG_FILE"
}


pulisci_temp() {
    if [ -f "$CARTELLA_TEMP/$NOME_FILE" ]; then
        rm -f "$CARTELLA_TEMP/$NOME_FILE"
        scrivi_log "PULIZIA: Rimosso file temporaneo orfano dopo interruzione."
    fi
}
trap pulisci_temp EXIT

if [ ! -d "$ORIGINE" ]; then
    printf "ERRORE: La cartella di origine %s non esiste.\n" "$ORIGINE" >&2
    exit 1
fi

if [ ! -d "$DESTINAZIONE" ]; then
    mkdir -p "$DESTINAZIONE" || { printf "ERRORE: Impossibile creare %s\n" "$DESTINAZIONE" >&2; exit 1; }
fi

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR" || { printf "ERRORE: Impossibile creare %s\n" "$LOG_DIR" >&2; exit 1; }
fi

if [ ! -d "$CARTELLA_TEMP" ]; then
    mkdir -p "$CARTELLA_TEMP" 2>> "$LOG_FILE" || { printf "ERRORE: Impossibile creare %s\n" "$CARTELLA_TEMP" >&2; exit 1; }
fi

scrivi_log "INIZIO PROCESSO AVANZATO"


find "$LOG_DIR" -name "backup_*.log" -type f -mtime +"$GIORNI_RETENTION_LOG" -delete 2>> "$LOG_FILE"
scrivi_log "Rotazione log: rimossi i log più vecchi di $GIORNI_RETENTION_LOG giorni."

scrivi_log "Verifica spazio su disco in corso..."
SPAZIO_RICHIESTO=$(du -s "$ORIGINE" | awk '{print $1}')
SPAZIO_DISPONIBILE=$(df -P "$DESTINAZIONE" | tail -1 | awk '{print $4}')

if [ "$SPAZIO_RICHIESTO" -gt "$SPAZIO_DISPONIBILE" ]; then
    scrivi_log "ERRORE: Spazio insufficiente sul disco di destinazione."
    exit 1
fi

scrivi_log "Spazio verificato: sufficiente per procedere."

scrivi_log "Creazione archivio in staging..."

DIR_PADRE=$(dirname "$ORIGINE")
NOME_DIR=$(basename "$ORIGINE")

if tar -czf "$CARTELLA_TEMP/$NOME_FILE" -C "$DIR_PADRE" "$NOME_DIR" 2>> "$LOG_FILE"; then
    scrivi_log "SUCCESSO: Archivio creato in staging."

    scrivi_log "Verifica integrità del file tar.gz..."

    if tar -tzf "$CARTELLA_TEMP/$NOME_FILE" > /dev/null 2>> "$LOG_FILE"; then
        scrivi_log "VERIFICA SUPERATA: L'archivio è integro e pronto."

        if mv "$CARTELLA_TEMP/$NOME_FILE" "$DESTINAZIONE/$NOME_FILE" 2>> "$LOG_FILE"; then
            DIMENSIONE=$(du -h "$DESTINAZIONE/$NOME_FILE" | awk '{print $1}')
            scrivi_log "SUCCESSO: Archivio spostato in destinazione (Dimensione: $DIMENSIONE)."
        else
            scrivi_log "ERRORE: Spostamento in destinazione fallito."
            exit 1
        fi
    else
        scrivi_log "ERRORE VERIFICA: L'archivio sembra corrotto!"
        rm -f "$CARTELLA_TEMP/$NOME_FILE"
        exit 1
    fi
else
    scrivi_log "ERRORE: Compressione fallita."
    exit 1
fi

scrivi_log "FINE PROCESSO"

exit 0
