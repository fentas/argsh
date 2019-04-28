#!/usr/bin/awk -f

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
}
$3 {
  printf "export %s%s\n", $3, $4 ? "=\"" ($4 == "" ? "" : $4) "\"" : ""
}