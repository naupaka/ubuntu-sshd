FROM       rocker/geospatial
MAINTAINER Naupaka Zimmerman "https://github.com/naupaka"

RUN apt-get update
RUN apt-get install -y openssh-server tmux nano git unzip \
    trimmomatic fastqc bison byacc ncbi-blast+ curl wget tar \
    make gcc libz-dev shellcheck


###### R Packages ######

# https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file
# install packages and check installation success, install.packages itself does not report fails
RUN R -e "install.packages('BiocManager');     if (!library(BiocManager, logical.return = TRUE)) quit(status = 10)" \
 && R -e "install.packages('vegan'); if (!library(vegan, logical.return = TRUE)) quit(status = 10)" \
 && R -e "install.packages('ggpubr'); if (!library(ggpubr, logical.return = TRUE)) quit(status = 10)" \
 && R -e "install.packages('ggmap'); if (!library(ggmap, logical.return = TRUE)) quit(status = 10)"


###### fastqc ######

# there is a problem with normal fastqc installation
# have to fix by downloading config files from source
# http://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc
# and then putting the three files from the Configuration folder
# into /etc/fastq/Configuration

# Download the source and extract to get out config files
RUN curl https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip -o /home/fastqc_v0.11.9.zip \
 && unzip /home/fastqc_v0.11.9.zip -d /home

# Make the directory and copy the files into it
RUN mkdir -p /etc/fastqc/Configuration \
 && cp /home/FastQC/Configuration/adapter_list.txt \
    /home/FastQC/Configuration/limits.txt  \
    /home/FastQC/Configuration/contaminant_list.txt \
    /etc/fastqc/Configuration

# delete unzipped directory and archive source
RUN mkdir -p /home/code/downloaded_src \
 && mv /home/fastqc_v0.11.9.zip /home/code/downloaded_src \
 && rm -rf /home/FastQC


##### sratoolkit #####

# Download newest version of sratoolkit from NCBI
RUN wget --output-document /home/sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz \
 && tar -vxzf /home/sratoolkit.tar.gz -C /home \
 && mv /home/sratoolkit.tar.gz /home/code/downloaded_src

# move to code/tools
RUN mkdir -p /home/code/tools \
 && mv /home/sratoolkit.2.11.1-ubuntu64 /home/code/tools


##### bioawk #####

RUN cd /home/code/tools; git clone git://github.com/lh3/bioawk.git \
 && cd /home/code/tools/bioawk; make


##### mothur #####
RUN curl -L https://github.com/mothur/mothur/releases/download/v1.39.5/Mothur.linux_64_static.zip -o /home/Mothur.linux_64_static.zip \
 && unzip /home/Mothur.linux_64_static.zip -d /home


##### Other misc #####

COPY markdown.nanorc /usr/share/nano/
COPY init_docker.sh /

WORKDIR /home

RUN echo "export PATH=${PATH}:/home/code/tools/sratoolkit.2.11.1-ubuntu64/bin/:/home/code/tools/bioawk/:/home/mothur" >> /home/.profile
RUN echo "export BLASTDB=/blast-db" >> /home/.profile
RUN echo "git config --global core.editor nano" >> /home/.profile
RUN echo "/usr/bin/bash" >> /home/.profile

CMD ["/init_docker.sh"]

# mosh 3838
EXPOSE 22 8787
