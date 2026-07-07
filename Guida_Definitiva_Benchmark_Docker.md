                 Guida Definitiva al Benchmark Docker
                           Versione Revisionata e Verificata per WRK Client-Server

1.  Flusso di Rete e Architettura Il test di carico richiede che un
    client esterno punti correttamente all'IP pubblico/locale della
    macchina Host che ospita Docker, sfruttando il meccanismo di NAT e
    Port Forwarding.

\[ Client con WRK \] │ ▼ (Richiesta HTTP su porta 3000) \[ Host Windows
\] ──► IP Locale Reale: 172.31.190.137 │ ▼ (Port Forwarding -p
3000:3000) \[ Container Debian \] ──► IP Interno Docker: 172.17.0.2

2.  Configurazione dell'Host Windows (Inbound Rule) Per consentire le
    connessioni TCP in ingresso sulla porta 3000, eseguire questo
    comando all'interno di una sessione di PowerShell aperta come
    Amministratore sull'Host Windows:

New-NetFirewallRule -DisplayName "Porta 3000 Docker" -Direction Inbound
-Action Allow -Protocol TCP -LocalPort 3000

3.  Verifica Preventiva della Connessione (Cruciale) Prima di avviare il
    benchmark pesante con wrk, è caldamente consigliato effettuare un
    test di handshake per accertarsi che i pacchetti passino il
    firewall.

⚠️ Attenzione agli errori di sintassi comuni Il comando standard ping
NON accetta i numeri di porta (es. ping 172.31.190.137/3000 fallirà
sistematicamente). Inoltre, il prompt dei comandi classico (CMD) non
riconosce le cmdlet avanzate di rete.

Dalla macchina client (se Windows), aprire PowerShell (anche non
amministratore) ed eseguire:

Test-NetConnection -ComputerName 172.31.190.137 -Port 3000

Il canale è correttamente configurato e pronto al benchmark solo quando
l'output restituisce il valore:

TcpTestSucceeded : True  4. Esecuzione del Benchmark con WRK Una volta
ottenuta la conferma di connessione riuscita, spostarsi sul terminale
del client Linux (o macchina abilitata a wrk) ed eseguire il test di
stress puntando all'endpoint validato:

wrk -t12 -c400 -d30s http://172.31.190.137:3000/

Significato dei Parametri di Carico:

• -t12: Alloca 12 thread concorrenti sul client per massimizzare la
generazione di traffico.

• -c400: Mantiene aperte 400 connessioni concorrenti simultanee verso
l'Host Windows.

• -d30s: Forza la durata complessiva del test a esattamente 30 secondi.

5.  Lettura e Interpretazione dei Risultati Al termine dei 30 secondi,
    wrk mostrerà un riepilogo delle performance del container Debian:

• Requests/sec (RPS): Indica la quantità totale di richieste gestite al
secondo dal container. Più il valore è alto, maggiore è l'efficienza del
server.

• Latency: Il tempo medio di risposta (es. in millisecondi). Un server
ottimizzato mantiene latenze basse anche sotto stress.

• Errors (Connect/Read/Timeout): Se questo contatore rimane a 0,
significa che il container Docker ha assorbito il carico di 400
connessioni senza subire crash o perdite di pacchetti. 
