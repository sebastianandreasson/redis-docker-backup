FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y redis-tools

ADD backup.sh /scripts/backup.sh
ADD run.sh /run.sh

RUN mkdir /log

CMD /run.sh
