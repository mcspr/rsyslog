#!/bin/bash

# rsyslog.input.journal.gz - read imjournal-basic.sh

echo \[imjournal-shutdown-state-file.sh\]: testing state file creation during shutdown
. $srcdir/diag.sh init
gunzip -c rsyslog.input.journal.gz > rsyslog.input.journal
ls -l rsyslog.input.journal

# Run first instance. It will record state after shutdown
. $srcdir/diag.sh startup imjournal-shutdown-state-file1.conf
. $srcdir/diag.sh wait-startup
. $srcdir/diag.sh shutdown-immediate

. $srcdir/diag.sh startup imjournal-shutdown-state-file2.conf 2
. $srcdir/diag.sh wait-startup 2
. $srcdir/diag.sh shutdown-when-empty 2

cat rsyslog2.out.log >> rsyslog.out.log

# Resulting rsyslog.out.log should have all messages
. $srcdir/diag.sh seq-check 0 4999
