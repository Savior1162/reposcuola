                            Guida Tecnica di Benchmark
                                Configurazione di WRK e Docker NAT con IP Host

1.  Architettura e Flusso di Rete Quando un computer esterno avvia un
    test di carico tramite wrk, le richieste attraversano diversi
    livelli di astrazione di rete prima di raggiungere il servizio
    all'interno del container Docker Debian. Di seguito viene illustrato
    il percorso dettagliato dei dati:

\[ PC Esterno con WRK \] │ ▼ (Richiesta HTTP inviata a
http://172.31.190.137:3000/) \[ PC Windows Host \] (IP locale reale:
172.31.190.137) │ ▼ (Docker Port Forwarding / NAT) \[ Container Debian
\] (IP interno privato: 172.17.0.2) │ ▼ \[ Servizio in ascolto sulla
porta 3000 \] (es. Grafana / Web Server)

Poiché l'IP 172.17.0.2 fa parte di una sottorete privata isolata interna
a Docker, gli altri PC della rete locale non possono interfacciarsi
direttamente con esso. Devono necessariamente inviare le richieste
all'IP dell'host Windows (172.31.190.137) sulla porta pubblicata 3000.

2.  Fase 1: Configurazione dell'Host Windows (Firewall) Per impostazione
    predefinita, il Firewall di Windows blocca le connessioni TCP in
    entrata sulle porte non standard provenienti da altri PC della rete.
    È fondamentale istruire il sistema per consentire il traffico sulla
    porta 3000.

3.  Sul PC Windows Host, fare clic su Start e cercare PowerShell.

4.  Fare clic con il tasto destro su PowerShell e selezionare Esegui
    come Amministratore.

5.  Eseguire il seguente comando per creare una regola di ingresso
    esplicita:

New-NetFirewallRule -DisplayName "WRK Benchmark Docker" -Direction
Inbound -Action Allow -Protocol TCP -LocalPort 3000

3.  Fase 2: Configurazione e Avvio del Container Docker Il container
    deve essere avviato eseguendo correttamente il mapping della porta
    dall'host al container (-p 3000:3000). Se il container è già attivo
    ed è stato creato con tale flag, il port forwarding è pienamente
    operativo.

Comando di creazione (Esempio):

docker run -d -p 3000:3000 --name mio_debian debian:latest Gestione dei
Servizi Interni (NetworkManager / D-Bus):

Se all'interno del container Debian si ha la necessità di utilizzare
strumenti come nmcli, ricordare che l'ambiente minimale di Docker non
avvia i demoni di sistema in automatico. La sequenza corretta di comandi
da eseguire nel terminale del container è la seguente:

\# Aggiorna i pacchetti e installa le dipendenze vitali apt update &&
apt install -y network-manager dbus

\# Inizializza e avvia il demone D-Bus in background mkdir -p
/var/run/dbus dbus-daemon --system --fork

\# Avvia NetworkManager in background NetworkManager &

Nota di Sicurezza Per utilizzare appieno nmcli e vedere le interfacce
reali dell'host, il container deve essere avviato originariamente con i
flag --privileged --net=host. Tuttavia, l'uso di questi flag bypassa
l'isolamento nativo di Docker.

4.  Fase 3: Esecuzione del Benchmark dall'Altro PC Spostarsi sul secondo
    computer (il client che genererà il carico), assicurandosi che sia
    connesso alla stessa sottorete del PC Windows.

Installazione di WRK (se basato su Debian/Ubuntu):

sudo apt update && sudo apt install -y wrk

Esecuzione del test di carico:

Lanciare il benchmark puntando direttamente all'IP dell'host Windows
configurato sulla porta 3000:

wrk -t12 -c400 -d30s http://172.31.190.137:3000/

Analisi dei parametri del comando:

• -t12: Configura l'utilizzo di 12 thread paralleli per ottimizzare
l'uso della CPU del client.

• -c400: Mantiene un totale di 400 connessioni concorrenti simultanee
aperte durante il test.

• -d30s: Specifica che la durata totale del benchmark sarà di
esattamente 30 secondi.  5. Risoluzione dei Problemi (Troubleshooting)

Errore: Connection Timeout

Se l'altro PC restituisce errori di timeout, verificare che:

• Il comando PowerShell nella Fase 1 sia stato eseguito correttamente
come Amministratore.

• I due computer siano effettivamente in grado di comunicare a livello
di rete (eseguire ad esempio un ping 172.31.190.137 dal PC client).

Errore: 404 Not Found o Connessione Rifiutata

Significa che il traffico raggiunge correttamente Windows, ma il
container Docker o il servizio interno (es. Grafana) non è attivo o non
è in ascolto sulla porta 3000 all'interno del container stesso. 
