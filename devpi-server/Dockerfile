FROM ubuntu:12.04
MAINTAINER Michael Merickel <michael@merickel.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y -q install python2.7 python-pip python-virtualenv
RUN pip install -q -U devpi

ENV DEBIAN_FRONTEND dialog

VOLUME /data
EXPOSE 3141
ENTRYPOINT ["devpi-server", "--serverdir=/data", "--host=0.0.0.0"]
