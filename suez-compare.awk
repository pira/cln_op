#!/usr/bin/awk -f
# Compare two suez outputs and list differences sorted by channel changes between two snapshots
# channel change is defined as change in our balance plus 1000x change in satoshi income from the channel
# called from a wrapper shell
#
BEGIN {
}

# Function definitions
function abs(x) { return x < 0 ? -x : x }
function sanitize(x) {
  gsub(/,/, "", x)
  return (x ~ /^[0-9]+(\.[0-9]+)?$/) ? x+0 : 0
}

# Read file1: store each line by its key (first column is channel short id)
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
      # column 5 is our balance, column 10 is satoshi income
      v1 = sanitize(f1[5])
      v2 = sanitize(f2[5])
      v3 = sanitize(f1[10])
      v4 = sanitize(f2[10])
      diff = abs(v1 - v2) + 1000 * abs(v3 - v4)
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

