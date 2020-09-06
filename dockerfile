#samtools
#htslib
#libdeflate
#biobambam

#базовый образ - Ubuntu 18.04
FROM ubuntu:18.04

MAINTAINER Boris Belyaev <belbor1@gmail.com>

ENV SOFT /soft

RUN apt-get update && apt-get install -y apt-utils git autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev  libcurl4-gnutls-dev libssl-dev libncurses5-dev libtool autotools-dev
	
# libdeflate v1.6 2020-05-13 https://github.com/ebiggers/libdeflate/tree/v1.6
WORKDIR ${SOFT}/git-libdeflate
RUN	git init && git remote add origin https://github.com/ebiggers/libdeflate.git && git pull https://github.com/ebiggers/libdeflate.git 753d4a1a625efb478f845f1c4d3869a41f710ae5 && mkdir ${SOFT}/libdeflate_1.6 && make && make install && rm -fr ${SOFT}/git-libdeflate
