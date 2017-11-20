FROM ubuntu:trusty

ADD backup.sh /scripts/backup.sh
ADD run.sh /run.sh

CMD /run.sh