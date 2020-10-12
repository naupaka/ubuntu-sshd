# README for Dockerfile to make RStudio Server and SSH Server for Bioinformatics Class

### University of San Francisco

* Naupaka Zimmerman
* October 11, 2020

The files in this directory create a Docker image that allows for simultaneous configuration of users, ports, and passwords for containers for student use. They go along with a bash script that reads a delimited configuration file and creates one container for every student, each with a different username, password, and port. The ports should be adjacent for RStudio Server and SSH access.

The logic for this approach of configuration draws from [EcoHealth Alliance's 'Reservoir' container](https://github.com/ecohealthalliance/reservoir) and from the imput and support of Noam Ross.
