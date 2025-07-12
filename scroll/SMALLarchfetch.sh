#!/bin/bash
#
#
#



## COLORS

if [ -x "$(command -v tput)" ]; then
	bold="$(tput bold 2> /dev/null)"
	black="$(tput setaf 0 2> /dev/null)"
	red="$(tput setaf 1 2> /dev/null)"
	green="$(tput setaf 2 2> /dev/null)"
	yellow="$(tput setaf 3 2> /dev/null)"
	blue="$(tput setaf 4 2> /dev/null)"
	magenta="$(tput setaf 5 2> /dev/null)"
	cyan="$(tput setaf 6 2> /dev/null)"
	white="$(tput setaf 7 2> /dev/null)"
	reset="$(tput sgr0 2> /dev/null)"
fi

label="${reset}${bold}${blue}"



## RAM

# il primo argomento dello script può essere MiB oppure GiB
UNIT="${1:-MiB}"  # se non viene passato nulla, usa MiB di default

read RAM_USED RAM_TOTAL <<< $(free -m | awk '/^Mem:/ {print $3, $2}')

# calcola la percentuale
PERC=$(( RAM_USED * 100 / RAM_TOTAL ))

# converte da MiB a GiB
if [[ "$UNIT" == "GiB" ]]; then
    RAM_USED=$(printf '%.2f\n' $((10**2*$RAM_USED/1024))e-2)
    RAM_TOTAL=$(printf '%.2f\n' $((10**2*$RAM_TOTAL/1024))e-2)
fi



## SYSTEM INFO

SYSINFO=(
""
"${label}Kernel:${reset}    $(uname -sr)"
" ${label}Ram:${reset}       $(printf "%s/%s %s (%d%%)" "$RAM_USED" "$RAM_TOTAL" "$UNIT" "$PERC")"
"  ${label}Uptime:${reset}    $(uptime -p | sed 's/up //')"
)



## PRINT OUTPUT

#read -r rows cols < <(stty size)
#echo "Numero di righe: $rows"
#echo "Numero di colonne: $cols"

#if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] || [ $(tput cols) -lt 68 ]; then
if [ "$XDG_SESSION_TYPE" = "tty" ]; then
    echo
    printf "   %b\n" "${SYSINFO[@]}"
    exit
fi


IMAGE="[?25l[0m
              [0m
       █      [0m
     ████     [0m
    ███     [0m
   ███  ███   [0m[?25h"



# conta le righe dell'immagine
IMAGE_HEIGHT=$(echo "$IMAGE" | wc -l)
SYSINFO_COUNT=${#SYSINFO[@]}

# calcola l'offset per centrare le specifiche
OFFSET=$(( (IMAGE_HEIGHT - SYSINFO_COUNT) / 2 ))

# inizializza array FETCH
FETCH=()

# accumula in FETCH
i=0
while IFS= read -r line; do
  if [ $i -ge $OFFSET ] && [ $i -lt $((OFFSET + SYSINFO_COUNT)) ]; then
    FETCH+=("$line${SYSINFO[$((i - OFFSET))]}")
  else
    FETCH+=("$line")
  fi
  i=$((i + 1))
done <<< "$IMAGE"



# nascondi cursore
printf '\e[?25l'

# ritardo
delay=0.004

cursor=$'\e[0m░░▒▓'

# tokenizza una riga in escape CSI + caratteri singoli
tokenize() {
  local s=$1; local -n T=$2
  T=()
  while [[ -n $s ]]; do
    if [[ $s =~ ^(\[[0-9;]*m)(.*) ]]; then
      T+=( "${BASH_REMATCH[1]}" )
      s=${BASH_REMATCH[2]}
    else
      T+=( "${s:0:1}" )
      s=${s:1}
    fi
  done
}

print_with_cursor() {
  local line=$1
  local -a tokens
  local prefix=""  # qui accumulo in ordine escape+testo
  tokenize "$line" tokens

  for tok in "${tokens[@]}"; do
    prefix+="$tok"
    # se è carattere visibile (non inizio con ESC[), faccio il frame
    if [[ ! $tok =~ ^\[ ]]; then
      printf '\r%s%s\e[K' "$prefix" "$cursor"
      read -t "$delay"
    fi
  done

  # frame finale (tutta la riga senza cursor)
  printf '\r%s\e[K\n' "$prefix"
}

# stampa a schermo
for L in "${FETCH[@]}"; do
  print_with_cursor "$L"
done

# ripristina cursore
printf '\e[?25h'
