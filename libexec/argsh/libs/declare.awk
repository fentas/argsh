#!/usr/bin/awk -f

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
}
$3 {
  printf "export %s\n", $3
  if ($4 && $4 != "") {
    printf ": \"${%s:=\"%s\"}\"\n", $3, $4
  }
}