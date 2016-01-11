#!/bin/bash

/usr/sbin/openvas-nvt-sync
/usr/sbin/openvas-scapdata-sync
/usr/sbin/openvas-certdata-sync
service openvas-scanner restart
service openvas-manager restart
sleep 120
/usr/sbin/openvasmd --rebuild
