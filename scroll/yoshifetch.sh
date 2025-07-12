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
"${reset}${bold}        ___           __"
"${reset}${bold}       / _ | ________/ /"
"${reset}${bold}      / __ |/ __/ __/ _ \\"
"${reset}${bold}     /_/ |_/_/  \__/_//_/"
"${reset}${bold}           "
" ${label}Kernel:${reset}    $(uname -sr)"
"  ${label}Ram:${reset}       $(printf "%s/%s %s (%d%%)" "$RAM_USED" "$RAM_TOTAL" "$UNIT" "$PERC")"
"   ${label}Uptime:${reset}    $(uptime -p | sed 's/up //')"
"    ${label}Packages:${reset}  $(pacman -Q | wc -l)"
""
)



## PRINT OUTPUT

#read -r rows cols < <(stty size)
#echo "Numero di righe: $rows"
#echo "Numero di colonne: $cols"

if [ $(tput lines) -lt 13 ]; then
        for info in "${SYSINFO[@]:0:4}"; do
          echo "  $info"
        done
        exit
fi

if [ $(tput lines) -lt 18 ]; then
        for info in "${SYSINFO[@]:0:8}"; do
          echo "  $info"
        done
        exit
fi

#if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] || [ $(tput cols) -lt 68 ]; then
if [ "$XDG_SESSION_TYPE" = "tty" ] || [ $(tput cols) -lt 68 ]; then
	for info in "${SYSINFO[@]}"; do
	  echo "  $info"
	done
	exit
fi


IMAGE="[?25l[0m [38;2;0;0;0m             ▄[38;2;179;228;0;48;2;0;0;0m▄▄[0m[38;2;0;0;0m▄[38;2;179;228;0;48;2;0;0;0m▄▄[0m[38;2;0;0;0m▄      [0m
 [38;2;0;0;0m         ▄▄▄[48;2;0;0;0m [38;2;179;228;0;48;2;0;164;50m▄[38;2;254;254;254;48;2;179;228;0m▄[48;2;254;254;254m [38;2;0;0;0m▄ ▄[38;2;254;254;254;48;2;179;228;0m▄[48;2;0;0;0m [0m[38;2;254;254;254m     [0m
 [38;2;0;0;0m        [48;2;0;0;0m [38;2;220;0;0;48;2;254;72;0m▄[48;2;254;109;7m▄[38;2;0;0;0m▄[48;2;0;0;0m [48;2;179;228;0m [48;2;254;254;254m  [48;2;0;0;0m [48;2;254;254;254m [48;2;0;0;0m [48;2;254;254;254m [48;2;0;0;0m [0m[38;2;0;0;0m▄▄   [0m
 [38;2;0;0;0m       ▄[38;2;254;109;7;48;2;0;0;0m▄ [38;2;0;164;50m▄[38;2;179;228;0;48;2;0;164;50m▄[48;2;179;228;0m   [48;2;254;254;254m▄▄[38;2;0;164;50m▄[38;2;179;228;0;48;2;0;164;50m▄▄[48;2;179;228;0m   [48;2;0;0;0m▄[0m[38;2;0;0;0m▄ [0m
 [38;2;0;0;0m      [48;2;0;0;0m [38;2;220;0;0;48;2;254;72;0m▄[48;2;220;0;0m [48;2;0;0;0m [48;2;0;164;50m [38;2;254;254;254;48;2;179;228;0m▄[48;2;254;254;254m   [48;2;179;228;0m▄[48;2;0;164;50m [48;2;179;228;0m    [38;2;179;228;0;48;2;0;0;0m▄[48;2;179;228;0m [48;2;0;0;0m▄[48;2;179;228;0m [48;2;0;0;0m [0m
 [38;2;0;0;0m       [48;2;0;0;0m [38;2;254;72;0m▄ [48;2;0;164;50m [38;2;225;225;225;48;2;254;254;254m▄   ▄[38;2;0;0;0;48;2;0;164;50m▄[48;2;179;228;0m        [48;2;0;0;0m [0m
 [38;2;0;0;0m        [7m▄[0m[38;2;0;0;0;48;2;220;0;0m▄[48;2;0;0;0m [48;2;0;164;50m▄[38;2;0;164;50;48;2;225;225;225m▄[38;2;225;225;225;48;2;254;254;254m▄ [38;2;254;254;254;48;2;0;0;0m▄▄[38;2;0;0;0;48;2;0;164;50m▄[38;2;0;164;50;48;2;179;228;0m▄    ▄[38;2;0;0;0;48;2;0;164;50m▄[0m[7m[38;2;0;0;0m▄[0m
 [38;2;0;0;0m    ▄[38;2;254;109;7;48;2;0;0;0m▄[38;2;220;0;0m▄▄[0m[38;2;0;0;0m▄[48;2;0;0;0m [48;2;220;0;0m▄[38;2;179;228;0;48;2;0;0;0m▄[48;2;179;228;0m [48;2;225;225;225m▄[38;2;225;225;225;48;2;254;254;254m▄  [38;2;0;0;0m▄[48;2;0;0;0m [48;2;0;164;50m▄▄▄▄[0m[7m[38;2;0;0;0m▄[0m[38;2;0;0;0m  [0m
 [38;2;0;0;0m▄▄ [48;2;0;0;0m [38;2;254;72;0;48;2;254;109;7m▄[38;2;220;0;0;48;2;254;72;0m▄[38;2;254;254;254;48;2;220;0;0m▄[38;2;0;0;0;48;2;254;254;254m▄[48;2;0;0;0m [38;2;179;228;0m▄[48;2;179;228;0m  [38;2;0;164;50m▄[48;2;254;254;254m   [48;2;0;0;0m ▄[38;2;179;228;0m▄[0m[38;2;0;0;0m▄      [0m
[7m[38;2;0;0;0m▄[0m[38;2;0;0;0;48;2;179;228;0m▄ [38;2;179;228;0;48;2;0;0;0m▄▄[38;2;0;0;0;48;2;254;254;254m▄▄[38;2;0;164;50;48;2;0;0;0m▄[38;2;179;228;0;48;2;0;164;50m▄[48;2;179;228;0m   [38;2;0;0;0;48;2;0;164;50m▄[38;2;254;254;254;48;2;0;0;0m▄[48;2;254;254;254m   [48;2;0;0;0m  [38;2;0;0;0;48;2;0;164;50m▄[48;2;179;228;0m [48;2;0;0;0m [0m[38;2;0;0;0m     [0m
 [7m[38;2;0;0;0m▄[0m[38;2;0;0;0;48;2;0;0;0m [38;2;254;254;254;48;2;0;164;50m▄[38;2;0;164;50;48;2;179;228;0m▄[48;2;0;0;0m [48;2;179;228;0m    [48;2;254;254;254m  [38;2;0;0;0;48;2;0;164;50m▄[48;2;0;0;0m [48;2;254;254;254m   [48;2;0;0;0m [38;2;0;164;50m▄[38;2;179;228;0;48;2;0;164;50m▄[48;2;179;228;0m [48;2;0;0;0m [0m[38;2;179;228;0m     [0m
 [38;2;0;0;0m  [7m▄[0m[38;2;0;0;0;48;2;254;254;254m▄[38;2;254;254;254;48;2;0;0;0m▄[38;2;0;0;0;48;2;0;164;50m▄[38;2;0;164;50;48;2;179;228;0m▄   ▄[38;2;0;0;0;48;2;0;164;50m▄[38;2;254;254;254;48;2;0;0;0m▄[48;2;254;254;254m [38;2;225;225;225m▄[48;2;0;0;0m [0m[7m[38;2;0;0;0m▄[0m[38;2;0;0;0;48;2;0;164;50m▄[48;2;179;228;0m▄▄[0m[7m[38;2;0;0;0m▄[0m[38;2;0;0;0m     [0m
 [38;2;0;0;0m   ▄[38;2;254;72;0;48;2;0;0;0m▄[38;2;254;109;7m▄▄[38;2;254;144;0m▄▄ [38;2;225;225;225m▄[48;2;254;254;254m▄[38;2;0;0;0m▄[48;2;225;225;225m▄[48;2;0;0;0m [0m[38;2;0;0;0m           [0m
 [38;2;0;0;0m  ▄[38;2;254;72;0;48;2;0;0;0m▄[48;2;254;72;0m  [38;2;254;109;7m▄[38;2;254;144;0;48;2;254;109;7m▄[38;2;254;254;254;48;2;254;144;0m▄[38;2;254;144;0;48;2;0;0;0m▄ [38;2;254;72;0m▄[48;2;254;72;0m [48;2;254;109;7m▄[38;2;254;109;7;48;2;254;144;0m▄[38;2;254;254;254;48;2;0;0;0m▄[38;2;254;144;0m▄[0m[38;2;0;0;0m▄        [0m
 [38;2;0;0;0m  [7m▄[0m[38;2;0;0;0;48;2;254;72;0m▄▄[48;2;254;109;7m▄[48;2;254;144;0m▄▄▄▄[0m[7m[38;2;0;0;0m▄[0m[38;2;0;0;0;48;2;254;72;0m▄▄[48;2;254;109;7m▄[48;2;254;144;0m▄▄▄[0m[7m[38;2;0;0;0m▄[0m[38;2;0;0;0m        [0m[?25h"



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
    FETCH+=("$line  ${SYSINFO[$((i - OFFSET))]}")
  else
    FETCH+=("$line")
  fi
  i=$((i + 1))
done <<< "$IMAGE"



# nascondi cursore
printf '\e[?25l'

# ritardo
delay=0.002

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
