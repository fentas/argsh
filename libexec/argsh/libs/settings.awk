#!/usr/bin/awk -f

BEGIN {
  OFS="\n"
}
$0 ~ "# argsh " {
  $0 = substr($0, 7)
  for (i=2; i <= NF; i++) {
    print $i
  }
}