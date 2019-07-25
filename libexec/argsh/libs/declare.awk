#!/usr/bin/env awk -f

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
}
$3 {
  printf "export %s\n", $3
  if ($4 && $4 != "") {
    printf ": \"${%s:=\"%s\"}\"\n", $3, $4
  }
}
$4 ~ /^!!/ {
  $4 = substr($4, 3)
  call = call sprintf("! command -v \"%s\" &>/dev/null || \"%s\" \"%s\" \"%s\"\n", $4, $4, $2, $3)
}
END {
  print call
}
