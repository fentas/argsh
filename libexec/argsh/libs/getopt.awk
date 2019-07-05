#!/usr/bin/env awk -f

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
  o = ""
}
$1 { o = o (o ? "," $1 : $1) ($5 ? ":" : "") }
$2 { l = l (l ? "," $2 : $2) ($5 ? ":" : "") }
END {
  print "getopt -o \"" o "\" -l \"" l "\""
}
