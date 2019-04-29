#!/usr/bin/awk -f

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
}
$5 {
  printf "val=\"%s\" cmd=\"%s\" opt=\"%s\"\n", $5, $2, $3
}