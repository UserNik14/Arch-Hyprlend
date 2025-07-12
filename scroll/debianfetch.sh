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
"${reset}${bold}        ___      __   _"
"${reset}${bold}       / _ \___ / /  (_)__ ____"
"${reset}${bold}      / // / -_) _ \\/ / _ \`/ _ \\"
"${reset}${bold}     /____/\\__/_.__/_/\\_,_/_//_/"
"${reset}${bold}             "
"   ${label}Kernel:${reset}    $(uname -sr)"
"  ${label}Ram:${reset}       $(printf "%s/%s %s (%d%%)" "$RAM_USED" "$RAM_TOTAL" "$UNIT" "$PERC")"
" ${label}Uptime:${reset}    $(uptime -p | sed 's/up //')"
"${label}Packages:${reset}  $(dpkg-query -l | grep '^ii' | wc -l)"
""
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


IMAGE="[?25l[0m       [38;2;167;0;47m🭈🬻[38;2;153;0;43m🮆[38;2;163;0;46m🮆[38;2;158;0;45m▇[38;2;168;0;47m▆[38;2;167;0;47m▆▆[38;2;168;0;47m🬺[38;2;168;0;48m🬭[38;2;167;0;47m🬭[38;2;159;0;44m🬼[39m      [0m
    [38;2;167;0;47m🭉🭁[38;2;164;0;46m▇[48;2;168;0;48m[38;2;168;0;47m𝕓𝕓[48;2;168;0;47m🭇[49m[38;2;164;0;46m🮅[38;2;168;0;47m▀[38;2;163;0;46m▀[38;2;168;0;48m🮃🮃[38;2;166;0;47m▀[38;2;167;0;47m🮄🮅[48;2;167;0;47m🬼[48;2;168;0;48m[38;2;168;0;47m𝕓[48;2;168;0;47m╹[49m[38;2;156;0;44m▆[38;2;167;0;47m🭀[39m    [0m
   [38;2;162;0;46m🭁[48;2;167;0;48m[38;2;167;0;47m▔[48;2;168;0;48m[38;2;168;0;47m[48;2;168;0;47m[38;2;165;0;40m🭇[49m[38;2;153;0;42m▛[38;2;167;0;47m🮂[39m          [38;2;167;0;46m🮃[48;2;166;0;47m[38;2;28;0;7m🬾[48;2;168;0;48m[38;2;168;0;47m𝕓[48;2;167;0;48m[38;2;168;0;48m❜[48;2;89;0;24m[38;2;167;0;47m[49m◣[39m   [0m
 [38;2;167;0;47m🭇[38;2;160;0;45m▟[48;2;167;0;48m[38;2;168;0;49m̛[49m[38;2;160;0;44m🮅[38;2;153;0;43m🮂[39m                [38;2;153;0;43m▜[48;2;167;0;48m[38;2;168;0;48m▆[48;2;167;0;47m[38;2;167;0;47m🭇[48;2;164;0;46m[38;2;77;0;21m[49m[38;2;144;0;40m🬾[39m  [0m
[38;2;168;0;47m🭇[48;2;145;0;40m[38;2;167;0;47m[48;2;167;0;48m🭿[49m[38;2;160;0;45m🮂[39m       [38;2;165;0;44m🭇[38;2;164;0;46m🭄[38;2;167;0;47m🭠[38;2;154;0;43m◚[38;2;143;0;40m◚[38;2;166;0;47m🭹[38;2;167;0;44m🮢[39m    [38;2;158;0;45m▜[48;2;167;0;47m[38;2;168;0;47m▊[49m[38;2;156;0;44m[38;2;170;0;41m⃨[39m  [0m
[38;2;162;0;46m▟[48;2;167;0;47m[38;2;167;0;47m🭇[49m[38;2;135;0;38m▛[39m       [38;2;166;0;46m▗[38;2;141;0;39m▛[38;2;167;0;46m▔[39m         [38;2;167;0;47m🭿[48;2;168;0;48m[38;2;168;0;47m𝕓[48;2;151;0;41m▋[49m[39m  [0m
[38;2;167;0;47m🮋▉[39m       [38;2;148;0;41m🭋[38;2;155;0;44m▛[39m           [38;2;167;0;47m🭿[48;2;167;0;48m[38;2;168;0;48m🬇[48;2;167;0;47m[38;2;167;0;46m[49m[39m  [0m
[38;2;168;0;48m🮋[38;2;167;0;47m▊[39m       [38;2;148;0;42m🮈[38;2;160;0;45m▉[39m       [38;2;167;2;45m⡀[39m   [38;2;167;0;47m[48;2;167;0;47m[38;2;168;0;45m🭋[49m[38;2;162;0;45m▏[39m  [0m
[38;2;167;0;47m🮋[38;2;168;0;47m▉[39m       [38;2;166;0;45m‚[38;2;168;0;46m▜[38;2;142;0;40m▙[38;2;165;0;44m⃮[39m  [38;2;159;0;44m [38;2;166;0;47m🭗[39m   [38;2;168;0;47m🭇[38;2;145;0;40m▟[48;2;165;0;46m[38;2;100;0;27m🭋[49m[38;2;146;0;41m▘[39m    [0m
[38;2;160;0;45m🮉[48;2;168;0;48m[38;2;167;0;47m🭿[49m⎸[39m      [38;2;166;0;43m𝅥[38;2;135;0;37m᪼[38;2;164;0;46m🮊[38;2;158;0;43m🮆[38;2;167;0;47m🭌[38;2;164;0;46m🭑[38;2;167;0;47m🭻[38;2;168;0;47mⅹ[38;2;166;0;47m🭆[38;2;167;0;47m🭄[38;2;164;0;46m▆[38;2;149;0;42m▛[38;2;168;0;46m🮂[39m      [0m
[38;2;167;0;47m▕[48;2;167;0;48m[38;2;166;0;47m🬏[48;2;99;0;27m[38;2;167;0;47m▙[49m🭏[39m        [38;2;160;0;44m▔🮃[38;2;142;0;40m🮃[38;2;146;0;41m🮃🮃[38;2;167;0;47m🮂🮀[39m        [0m
 [38;2;162;0;45m▝[48;2;167;0;47m[38;2;166;0;47m🬼[38;2;167;0;47m▕[49m[38;2;148;0;42m▖[39m                      [0m
  [38;2;159;0;44m▝[48;2;167;0;47m[38;2;117;0;32m🬾[48;2;111;0;31m[38;2;167;0;47m[49m🬾[39m                     [0m
   [38;2;104;0;29m▕[38;2;159;0;44m▜[48;2;160;0;42m[38;2;168;0;47m[49m🬲[38;2;167;0;47mˎ[39m                   [0m
     [38;2;159;0;43m🮀[38;2;165;0;42m🮄[48;2;119;0;33m[38;2;164;0;46m▇[49m[38;2;167;0;47m🭐[38;2;165;0;46m🬼[39m                 [0m
      [38;2;172;0;37m▔[38;2;167;0;47m🮃[38;2;148;0;42m🮅[38;2;167;0;47m🭌◣🬏[39m               [0m[?25h"


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
delay=0.003

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
