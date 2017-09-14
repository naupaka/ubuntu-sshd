FROM       ubuntu:13.04
MAINTAINER Naupaka Zimmerman "https://github.com/naupaka"

RUN apt-get update

RUN apt-get install -y tmux nano git

CMD    ["tail -F /var/log/kern.log"]
