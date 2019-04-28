#!/usr/bin/awk -f

BEGIN {
  OFS=ENVIRON["ARGSH_FIELD_SEPERATOR"]
}
{
  match($0, /# argsh\(([^)|]+)?\|?([^)]+)?\)/, args)
  if (args[0]) {
    $0 = substr($0, RSTART + RLENGTH)
    while(match($0, /[:)] +(env|def|val|des)\(([^)]*)/, opt)) {
      args[opt[1]] = opt[2] ? opt[2] : "" # \u0000 - NULL
      $0 = substr($0, RSTART + RLENGTH)
    }
    if (length(args[1]) > 1) {
      args[2] = args[1]
      args[1] = ""
    }
    print args[1], args[2], args["env"], args["def"], args["val"], args["des"]
  }
}
END {
  print "h", "help", "", "", "", "", "Print help."
}