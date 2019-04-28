#!/usr/bin/awk -f

function options(cmd) {
  print "cmd=\"" cmd "\" opt=\"" $3 "\" val=\"" $5 "\""
  exit
}

BEGIN {
  FS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
}
arg ~ /^-[^-]/  && arg == "-" $1  { options($1); }
arg ~ /^--[^-]/ && arg == "--" $2 { options($2); }