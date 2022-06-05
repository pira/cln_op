# cln_op
some core lightning operator script snippets

## suez_compare.sh
Compares previous suez output to the current one; emphasis on routing node operation, showing latest moving channels

```
**Prereq:** suez (https://github.com/prusnak/suez)
**Usage:** run suez_compare.sh after editing suez dir (default $HOME/suez)
**Outputs:** creates _'statuses'_ directory with previous suez outputs stored in plain ascii, stores current status there, shows a diff between the last two statuses
```

## onchain-balance.sh
Displays currently available onchain funds for creating channels; just parses listfunds output

## clnrc
Some cln aliases; to have them loaded add "source PATH/TO/clnrc" to your ~/.bashrc file, replacing the path
