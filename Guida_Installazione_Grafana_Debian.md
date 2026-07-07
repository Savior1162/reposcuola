Guida all'Installazione di Grafana Manuale Tecnico Passo-Passo per
Server Debian e Ubuntu

Questo manuale descrive la procedura ufficiale e sicura per installare
Grafana OSS (Open Source Software) su distribuzioni Linux basate su
Debian o Ubuntu. Utilizzeremo il repository APT ufficiale di Grafana in
modo da poter ricevere gli aggiornamenti futuri in modo automatico.

Passo 1: Installare i Prerequisiti di Sistema

Prima di aggiungere i repository esterni, dobbiamo assicurarci che il
sistema supporti le connessioni HTTPS sicure e che disponga dei
pacchetti fondamentali per la gestione delle chiavi GPG.

Apri il tuo terminale Debian e installa i seguenti componenti:

sudo apt-get update sudo apt-get install -y apt-transport-https
software-properties-common wget curl

Passo 2: Importare la Chiave GPG Ufficiale

La chiave GPG permette al gestore dei pacchetti ( apt ) di verificare
l'autenticità e l'integrità del software Grafana che andrai a scaricare,
garantendo che non sia stato manomesso.

Crea la directory per le chiavi di sicurezza (se non esiste già) e
importa la chiave ufficiale con questo blocco di comandi:

sudo mkdir -p /etc/apt/keyrings curl -fsSL
https://apt.grafana.com/gpg.key \| gpg --dearmor \| sudo tee /etc/apt/
keyrings/grafana.gpg \> /dev/null

Passo 3: Aggiungere il Repository APT di Grafana

Aggiungiamo l'indirizzo dei server di Grafana alla lista delle sorgenti
software del sistema operativo, specificando l'utilizzo della chiave di
sicurezza appena scaricata.

Esegui il seguente comando per creare il file delle sorgenti:

echo "deb \[signed-by=/etc/apt/keyrings/grafana.gpg\]
https://apt.grafana.com stable main" \| sudo tee
/etc/apt/sources.list.d/grafana.list

                                                                                              Pagina 1 di 3

Passo 4: Aggiornare i Pacchetti e Installare Grafana

Ora che il sistema conosce il nuovo indirizzo, aggiorna l'indice dei
pacchetti ed esegui l'installazione vera e propria della versione
stabile Open Source (OSS):

sudo apt-get update sudo apt-get install -y grafana

Passo 5: Avviare e Abilitare il Servizio Systemd

L'installazione posiziona i file sul server ma non avvia l'applicazione
automaticamente. Dobbiamo attivare il servizio di sistema ed impostarlo
in modo che si riavvii da solo in caso di spegnimento o riavvio del
server Linux.

1.  Ricarica la configurazione del gestore di sistema:

    sudo systemctl daemon-reload

2.  Avvia il server di Grafana:

    sudo systemctl start grafana-server

3.  Abilita l'avvio automatico al boot:

    sudo systemctl enable grafana-server

🔍 Verifica dello Stato del Servizio

Puoi controllare in qualsiasi momento che Grafana stia girando
correttamente digitando il comando: sudo systemctl status grafana-server
Se tutto è andato a buon fine, vedrai una scritta verde con la dicitura
"active (running)".

Passo 6: Primo Accesso all'Interfaccia Grafica Web

Di default, Grafana si mette in ascolto sulla porta di rete 3000.

1.  Apri il tuo browser web preferito (Chrome, Firefox, Safari) sul tuo
    computer principale.

                                                                                                Pagina 2 di 3

     2. Digita l'indirizzo IP del tuo server Debian seguito dalla
    porta 3000. Ad esempio: http://VISTRO_IP_SERVER:3000 (oppure
    http://localhost:3000 se sei direttamente sulla macchina locale).

2.  Ti apparirà la schermata di login di Grafana. Inserisci le
    credenziali di default standard: • User: admin • Password: admin

3.  Cambio Password Obbligatorio: Al primissimo accesso, Grafana ti
    chiederà immediatamente di digitare una nuova password sicura a tua
    scelta per proteggere l'interfaccia. Sceglila accuratamente e
    conferma.

Fatto! Ora la tua interfaccia di Grafana è completamente operativa e
pronta per essere collegata a Prometheus (o ad Apache tramite l'apposito
exporter) per creare le tue dashboard di controllo.

                                                                                             Pagina 3 di 3


