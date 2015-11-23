#!/bin/bash

# rsyslog.input.journal.gz - read imjournal-basic.sh

# $ journalctl --file rsyslog.input.journal -o export 'MESSAGE=msgnum:00004998:' | sed -n -e 's|__CURSOR=\(.*\)|JOURNAL_CURSOR_4998="\1"|p'
JOURNAL_CURSOR_4998="s=795ffb379d224f44a54d710b48f61efc;i=184b0;b=10b9a1c21dc84b0c868b18805c0c1ebf;m=1fe69bc2e7;t=52528f3e00281;x=7fa76e53b932b97d"

echo \[imjournal-runtime-state-file.sh\]: testing state file creation during runtime
. $srcdir/diag.sh init
gunzip -c rsyslog.input.journal.gz > rsyslog.input.journal
ls -l rsyslog.input.journal

# First instance will record penultimate cursor
. $srcdir/diag.sh startup imjournal-runtime-state-file1.conf
. $srcdir/diag.sh wait-startup
. $srcdir/diag.sh wait-queueempty
. $srcdir/diag.sh custom-content-check "${JOURNAL_CURSOR_4998}" ./test-spool/imjournal.state

# Second instance will start from saved cursor
. $srcdir/diag.sh startup imjournal-runtime-state-file2.conf 2
. $srcdir/diag.sh wait-startup 2
. $srcdir/diag.sh shutdown-when-empty 2
. $srcdir/diag.sh shutdown-immediate

# Resulting rsyslog.out.log should have all messages
. $srcdir/diag.sh seq-check 0 4999
# Resulting rsyslog2.out.log should only have last message
. $srcdir/diag.sh custom-content-check 00004999 ./rsyslog2.out.log
