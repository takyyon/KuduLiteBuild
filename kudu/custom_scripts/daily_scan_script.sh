#!/bin/bash

LOGFILE="$2";
DIRTOSCAN="$1";

#TODAY=$(date +%u);

clamscan -r $DIRTOSCAN >> $LOGFILE;

echo "The script has finished.";

exit 0
