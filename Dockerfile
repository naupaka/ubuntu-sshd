FROM       rocker/geospatial:4.5.3
LABEL maintainer="Naupaka Zimmerman https://github.com/naupaka"

RUN apt-get update -o Acquire::Retries=3 \
 && apt-get install -y --no-install-recommends \
      openssh-server tmux nano git unzip \
      trimmomatic fastqc bison byacc ncbi-blast+ \
      curl wget tar make gcc libz-dev shellcheck \
 && rm -rf /var/lib/apt/lists/*

# Install FastQC config files manually — the Debian/Ubuntu package
# ships without them. See https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
RUN mkdir -p /etc/fastqc/Configuration /home/code/downloaded_src \
 && curl -fL https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip \
        -o /home/code/downloaded_src/fastqc_v0.12.1_source.zip \
 && unzip -q /home/code/downloaded_src/fastqc_v0.12.1_source.zip -d /tmp \
 && cp /tmp/FastQC/Configuration/adapter_list.txt \
       /tmp/FastQC/Configuration/limits.txt \
       /tmp/FastQC/Configuration/contaminant_list.txt \
       /etc/fastqc/Configuration/ \
 && rm -rf /tmp/FastQC

# sratoolkit (latest from NCBI) and bioawk (built from source)
RUN mkdir -p /home/code/tools /home/code/downloaded_src \
 && curl -fL https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz \
        -o /home/code/downloaded_src/sratoolkit.tar.gz \
 && tar -xzf /home/code/downloaded_src/sratoolkit.tar.gz -C /home/code/tools \
 && mv /home/code/tools/sratoolkit.*-ubuntu64 /home/code/tools/sratoolkit \
 && git clone https://github.com/lh3/bioawk.git /home/code/tools/bioawk \
 && make -C /home/code/tools/bioawk

COPY markdown.nanorc /usr/share/nano/
COPY init_docker.sh /

WORKDIR /home

RUN echo "export PATH=${PATH}:/home/code/tools/sratoolkit/bin/:/home/code/tools/bioawk/" >> /home/.profile
RUN echo "export BLASTDB=/blast-db" >> /home/.profile
RUN echo "git config --global core.editor nano" >> /home/.profile
RUN echo "/usr/bin/bash" >> /home/.profile

CMD ["/init_docker.sh"]

# mosh 3838
EXPOSE 22 8787
