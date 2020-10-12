# README for Dockerfile to make RStudio Server and SSH Server for Bioinformatics Class

### University of San Francisco

* Naupaka Zimmerman
* October 11, 2020

The files in this directory create a Docker image that allows for simultaneous configuration of users, ports, and passwords for containers for student use. They go along with a bash script that reads a delimited configuration file and creates one container for every student, each with a different username, password, and port. The ports should be adjacent for RStudio Server and SSH access.

The logic for this approach of configuration draws from [EcoHealth Alliance's 'Reservoir' container](https://github.com/ecohealthalliance/reservoir) and from the input and support of Noam Ross.

An example bash script to start up the containers might look something like this:

``` bash
#!/bin/bash

## for rstudio server with ssh

# field1 = email, field2 = username, field3 = password, field4 = port1, field5 = dirname, field6 = hostname, field7 = port2
while read -r field1 field2 field3 field4 field5 field6 field7; do
  # process the fields
  # if the line has less than three fields, the missing fields will be set to an empty string
  # if the line has more than three fields, `field3` will get all the values, including the third field plus the delimiter(s)
    echo "Creating container $field6 for $field2..."
    docker run --rm -d -P -p $field4:8787 -p $field7:22\
           -v /home/USERNAME/blast-db/:/blast-db:ro -v /mnt/raid/bioinformatics/2020F/$field5:/data -e ROOT=true \
           --name="$field6" --hostname="$field6" -e PASSWORD=$field3 -e USER=$field2 rstudio-ssh-local:latest
done < $1

```
