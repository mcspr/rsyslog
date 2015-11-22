#!/bin/bash

# rsyslog.input.journal.gz is generated on system running journald:
# # echo "Compress=no" > /etc/systemd/journald.conf
# # echo "RateLimitBurst=10000" >> /etc/systemd/journald.conf
# # systemctl restart systemd-journald
# # useradd -m rsyslog-test
# # su - rsyslog-test
# $ seq -f "msgnum:%08.f:" 0 4999 | systemd-cat -t test
# $ exit
# # systemctl restart systemd-journald
# # gzip -c /var/log/journal/*/user-$(id -u rsyslog-test).journal > rsyslog.input.journal.gz

echo \[imjournal-basic.sh\]: read directory with journal file
. $srcdir/diag.sh init
gunzip -c rsyslog.input.journal.gz > rsyslog.input.journal
ls -l rsyslog.input.journal
. $srcdir/diag.sh startup imjournal-basic.conf
sleep 1
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
. $srcdir/diag.sh seq-check 0 4999
. $srcdir/diag.sh exit

