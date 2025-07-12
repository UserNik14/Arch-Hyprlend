#!/bin/bash


# nascondi cursore
printf '\e[?25l'

# ritardo
delay=0.007

cursor=$'\e[0m░░▒▓'


lines=(
    $'         \e[0;34m.\e[0m  '
    $'        \e[0;34m/ \\\e[0m   '
    $'       \e[0;34m/   \\    \e[0m\e[1;37m         #     \e[1;34m| *\e[0m'
    $'      \e[0;34m/^.   \\   \e[0m\e[1;37m#%" a#"e 6##%  \e[0m\e[1;34m| | |-^-. |   | \\ /\e[0m'
    $'     \e[0;34m/  .-.  \\  \e[0m\e[1;37m#   #    #  #  \e[0m\e[1;34m| | |   | |   |  X\e[0m'
    $'    \e[0;34m/  (   ) _\\ \e[0m\e[1;37m#   %#e" #  #  \e[0m\e[1;34m| | |   | ^._.| / \\\e[0m'
    $'   \e[0;34m/ _.~   ~._^\\\e[0m'
    $'  \e[0;34m/.^         ^.\\ \e[0m\e[0;37mTM\e[0m'
)


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
for L in "${lines[@]}"; do
  print_with_cursor "$L"
done

# ripristina cursore
printf '\e[?25h'
