#!/usr/bin/awk -f

function format() {
  opt = sprintf("  %-23s  %s", ($1 ? "-"$1 : "") ($1 && $2 ? ", " : "") ($2 ? "--"$2 : ""), $6)
  if ($4) {
    opt = opt sprintf("\n%-26s ➜ %s", "", $4)
  }
  return opt
}

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]; OFS="\n"
  cmd=sprintf("basename %s", ENVIRON["ARGSH_SOURCE"])
  cmd | getline filename; close(cmd)

  print \
    "_usage() {",
    "local -r message=\"${1:-}\"",
    "[ -z \"${message}\" ] || echo -e \"\n\033[31m■■\033[0m \033[1m${message}\033[0m\"",
    "cat <<-EOTXT",
    "Usage:"
  printf "  %s [options]\n", filename

  len_options=0
  len_actions=0
}

  $3 { options[len_options++]=format(); }
! $3 { actions[len_actions++]=format(); }

END {
  if (len_options) {
    print "\nOptions:"
    for (i=0; i<len_options; i++) {
      print options[i]
    }
  }

  if (len_actions) {
    print  "\nActions:"
    for (i=0; i<len_actions; i++) {
      print actions[i]
    }
  }

  print "EOTXT", "}"
}