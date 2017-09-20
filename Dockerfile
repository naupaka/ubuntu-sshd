FROM       ubuntu:16.04
MAINTAINER Naupaka Zimmerman "https://github.com/naupaka"

RUN apt-get update
RUN apt-get install -y openssh-server tmux nano git unzip \
    trimmomatic fastqc bison byacc ncbi-blast+ curl wget tar

# there is a problem with normal fastqc installation
# have to fix by downloading config files from source
# http://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc
# and then putting the three files from the Configuration folder
# into /etc/fastq/Configuration

# Download the source and extract to get out config files
RUN curl http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5_source.zip -o /home/fastqc_v0.11.5_source.zip
RUN unzip /home/fastqc_v0.11.5_source.zip

# Make the directory and copy the files into it
RUN mkdir /etc/fastqc/Configuration
RUN cp /home/FastQC/Configuration/*.txt /etc/fastqc/Configuration

# delete unzipped directory and archive source
RUN mv /home/fastqc_v0.11.5_source.zip /home/code/downloaded_src
RUN rm -rf /home/FastQC

# Download newest version of sratoolkit from NCBI
RUN wget --output-document /home/sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz

# un-gnuzip and untar
RUN tar -vxzf /home/sratoolkit.tar.gz

# move to code/tools
RUN mkdir -p /home/code/tools
RUN mv /home/sratoolkit.2.8.2-1-ubuntu64 /home/code/tools

# archive download
RUN mkdir -p /home/code/downloaded_src
RUN mv sratoolkit.tar.gz /home/code/downloaded_src

RUN cd /home/code/tools; git clone git://github.com/lh3/bioawk.git
RUN cd /home/code/tools/bioawk; make

RUN mkdir /var/run/sshd

# RUN echo 'root:root' | chpasswd

# RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^\#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

COPY init.sh /

WORKDIR /home

ENTRYPOINT ["/init.sh"]
