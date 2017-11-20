FROM ubuntu:trusty

ADD backup.sh /scripts/backup.sh
ADD run.sh /run.sh

RUN mkdir /log

CMD /run.sh
