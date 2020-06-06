FROM ubuntu:18.04
RUN apt update && apt install -y gnupg2
RUN apt install -y ca-certificates

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' > /etc/apt/sources.list.d/rstuff.list
RUN apt update && apt install -y r-base
RUN echo "install.packages('rjson')" | R --no-save
RUN echo "install.packages('ggplot2')" | R --no-save
RUN echo "install.packages('zoo')" | R --no-save