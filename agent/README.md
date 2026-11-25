# Manutenzione di pastekb

`pastekb` è uno script Bash eseguibile per X11, invocabile da una scorciatoia del desktop. Il file `pastekb` nella radice è il punto di ingresso.

Lo script aspetta con `xinput` che i tasti della scorciatoia siano rilasciati, così `xdotool` evita di ripristinare modificatori che l'utente ha già rilasciato. Se X11 continua a segnalare tasti premuti, lo script termina dopo due secondi con un errore. Legge poi la selezione X11 `CLIPBOARD` con `xclip` e passa il testo su standard input a `xdotool`, che digita nella finestra con il focus. Mantieni il passaggio diretto del testo, compresi i ritorni a capo finali. Il comando lascia intatti gli appunti.

Dalla radice esegui `bash -n pastekb` e `bash tests/test-pastekb.sh`. Per una prova grafica, avvia lo script con una scorciatoia in una sessione X11 e verifica in un editor che un testo copiato con accenti e più righe compaia nel campo attivo.

Aggiorna il README e questa guida se cambiano i requisiti, il comportamento o i comandi di verifica.
