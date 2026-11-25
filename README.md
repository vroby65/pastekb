# pastekb

`pastekb` legge il testo degli appunti e lo digita nel campo attivo simulando la tastiera. Richiede una sessione X11, Bash, `xclip`, `xdotool` e `xinput`.

## Dipendenze

Su Linux Mint, Ubuntu e Debian installa le dipendenze e `curl` per il download.

```bash
sudo apt update
sudo apt install curl xclip xdotool xinput
```

## Download rapido

[Scarica lo script](https://raw.githubusercontent.com/vroby65/pastekb/main/pastekb) oppure installalo in `~/.local/bin` con un comando.

```bash
mkdir -p "$HOME/.local/bin" && curl -fsSL https://raw.githubusercontent.com/vroby65/pastekb/main/pastekb -o "$HOME/.local/bin/pastekb" && chmod +x "$HOME/.local/bin/pastekb"
```

## Scorciatoia globale

Nelle impostazioni delle scorciatoie di MATE o del tuo desktop, assegna `Ctrl+Alt+V` al percorso assoluto di `pastekb`. Se hai usato il comando qui sopra, ottieni il percorso con `printf '%s\n' "$HOME/.local/bin/pastekb"`.

Copia il testo con `Ctrl+C` oppure con `Ctrl+Maiusc+C` nel terminale. Metti il cursore nel campo di destinazione e premi `Ctrl+Alt+V`. La digitazione parte quando rilasci i tasti. Ogni ritorno a capo viene inviato come pressione di Invio.

## Test

Dalla directory del progetto esegui `bash tests/test-pastekb.sh`. Il test verifica il rilascio della scorciatoia, l'uscita se X11 continua a segnalare tasti premuti e il passaggio del testo multilinea al comando di digitazione.
