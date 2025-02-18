#!/usr/bin/awk -f
# compare_files.awk

BEGIN {
  # column number to check differences on - 10 for sats income, 5 for our balance
  if (!col) col = 5
}

# Function definitions
function abs(x) { return x < 0 ? -x : x }
function sanitize(x) {
  gsub(/,/, "", x)
  return (x ~ /^[0-9]+(\.[0-9]+)?$/) ? x+0 : 0
}

# Read file1: store each line by its key (first column)
FNR==NR { a[$1]=$0; next }

# Read file2 similarly
{ b[$1]=$0 }

END {
  changedCount = 0
  # Collect changed pairs
  for (k in a) {
    if ((k in b) && (a[k] != b[k])) {
      split(a[k], f1, " ")
      split(b[k], f2, " ")
      v1 = sanitize(f1[col])
      v2 = sanitize(f2[col])
      diff = abs(v1 - v2)
      changed[k] = diff
      changed1[k] = a[k]
      changed2[k] = b[k]
      keys[++changedCount] = k
    }
  }

  # Simple selection sort on keys array by descending diff
  for (i = 1; i <= changedCount; i++) {
    for (j = i + 1; j <= changedCount; j++) {
      if (changed[keys[i]] < changed[keys[j]]) {
         tmp = keys[i]; keys[i] = keys[j]; keys[j] = tmp
      }
    }
  }

  # Print output in three sections
  print "CHANGED:"
  for (i = 1; i <= changedCount; i++) {
    k = keys[i]
    print changed1[k]
    print changed2[k]
    print ""
  }

  print "REMOVED:"
  for (k in a)
    if (!(k in b))
      print a[k]

  print ""  # empty line before ADDED section
  print "ADDED:"
  for (k in b)
    if (!(k in a))
      print b[k]
}

