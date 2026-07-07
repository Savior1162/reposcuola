Guida Grafana Completa Configurazione passo-passo: Connessioni Attive e
Latenza di Risposta (Per Meno Esperti)

Questa guida unificata ti accompagna passo dopo passo nella creazione
dei due pannelli principali per monitorare il comportamento del tuo
server Nginx durante gli stress test. Vedremo esattamente cosa inserire
e come configurare i parametri per evitare errori di visualizzazione.

Fase 1: Preparare la Dashboard Vuota

1.  Apri Grafana nel browser.

2.  Nel menu a sinistra, clicca sull'icona delle Dashboard (il simbolo
    con i quattro quadratini a griglia).

3.  In alto a destra, clicca sul pulsante blu New e seleziona New
    Dashboard.

4.  Al centro della schermata, clicca sul pulsante + Add visualization.

5.  Scegli Prometheus (l'icona con la fiamma arancione) come sorgente
    dei dati.

Fase 2: Pannello 1 - Connessioni Attive (Quanti utenti sul sito)

Questo grafico conta il numero puro di connessioni simultanee aperte sul
server in tempo reale.

1.  La Query (Box "A" in basso): Sulla destra della riga "A", assicurati
    che sia selezionata la modalità Code (e non Builder). Nel campo di
    testo nero, cancella tutto e incolla:

    nginx_connections_active

2.  Il Titolo (A destra, sezione "Panel options"): Trova il campo Title
    nella colonna di destra, cancella il valore predefinito e inserisci:

    Nginx - Connessioni Attive

3.  L'Unità di Misura (A destra, sezione "Standard options"): Scorri
    verso il basso nella colonna di destra fino a Standard options.
    Clicca nella casella Unit, scrivi short sulla tastiera e seleziona
    dall'elenco la voce Misc / short. Perché "short"? Perché stiamo
    contando un numero puro di connessioni (es. 500 utenti), non tempi o
    pesi.

                                                                                               Pagina 1 di 3

     4. Conferma: Clicca sul pulsante blu Apply in alto a destra. Il
    primo grafico è pronto sulla bacheca.

Fase 3: Pannello 2 - Latenza / Tempo di Risposta (La sofferenza del
server)

Questo grafico misura la velocità di reazione del server. Sotto stress
test vedrai questa linea salire indicando il tempo di evasione delle
richieste.

1.  Aggiungi un nuovo grafico: Sulla dashboard principale, in alto a
    destra, clicca sul pulsante Add (l'icona con il simbolo + ) e
    seleziona nuovamente Visualization. Scegli ancora Prometheus.

2.  La Query (Box "A" in basso): Assicurati che sia attiva la modalità
    Code. Nel campo di testo nero della riga "A", cancella tutto e
    incolla la formula di misurazione del tempo di ciclo:

    scrape_duration_seconds{job="nginx"}

3.  Il Titolo (A destra, sezione "Panel options"): Nel campo Title nella
    colonna di destra, inserisci il nome del grafico:

    Nginx - Latenza di Risposta

4.  L'Unità di Misura (A destra, sezione "Standard options"): Scorri in
    basso nella colonna di destra fino a Standard options. Clicca nella
    casella Unit, scendi nel menu fino alla sezione Time e seleziona
    Seconds (s) oppure Milliseconds (ms). Perché i secondi/millisecondi?
    Perché stiamo misurando una durata temporale. Questo eviterà che
    Grafana mostri l'errore delle "Hours" (ore).

5.  Conferma: Clicca sul pulsante blu Apply in alto a destra. Anche il
    secondo grafico è posizionato.

Fase 4: Organizzazione e Salvataggio

1.  Spostamento: Puoi cliccare sul titolo di un pannello e trascinarlo
    per affiancarlo all'altro in modo da averli vicini.

2.  Ridimensionamento: Cliccando e trascinando l'angolo in basso a
    destra di ogni pannello, puoi allargarlo o restringerlo a
    piacimento.

3.  Salvataggio Definitivo: Clicca sull'icona del Floppy Disk in alto a
    destra, assegna un nome alla dashboard (es. Monitoraggio Nginx) e
    clicca su Save.

                                                                                             Pagina 2 di 3

    🔄 Riepilogo delle Differenze (Per non confondersi): • Grafico
    Connessioni: Misura QUANTI utenti ci sono. L'asse Y usa Misc / short
    (numeri puri: 1, 10, 500).

• Grafico Latenza: Misura QUANTO TEMPO ci mette il server. L'asse Y usa
Time / Seconds (s) o millisecondi.

💡 Consiglio pratico per i test: Quando lanci wrk con molte connessioni
contemporanee, tieni d'occhio entrambi i grafici. Il grafico delle
Connessioni salirà di colpo posizionandosi sul numero di utenti
impostato, mentre il grafico della Latenza si alzerà leggermente
mostrando in millisecondi quanto il server Debian stia faticando a
gestire il carico.

                                                                                           Pagina 3 di 3


