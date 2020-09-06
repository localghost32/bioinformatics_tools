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

# htslib 1.10.2 2019-12-19 https://github.com/samtools/htslib/tree/1.10.2
#WORKDIR ${SOFT}/git-htslib 
#RUN git init && git remote add origin https://github.com/samtools/htslib.git && git pull https://github.com/samtools/htslib.git #fd0f89554459b78c07303e2c8a42acacd6851b46 && mkdir ${SOFT}/htslib_1.10.2 && autoreconf && ./configure --with-libdeflate=/usr/local/ --prefix=${SOFT}/htslib_1.10.2 && make && make #install && rm -fr ${SOFT}/git-htslib

# Samtools Release 1.10 2019-12-06 https://github.com/samtools/samtools/tree/1.10
WORKDIR ${SOFT}/git-samtools 
RUN git init && git remote add origin https://github.com/samtools/samtools.git && git pull https://github.com/samtools/samtools.git 76877ea4e41cd9d9a7f045307485535c7da7422b && mkdir ${SOFT}/samtools_1.10 && autoreconf && ./configure --with-htslib=${SOFT}/htslib_1.10.2 --without-curses --prefix=${SOFT}/samtools_1.10 && make && make install && rm -fr ${SOFT}/git-samtools

