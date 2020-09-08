################
# Dockerfile with htslib, libdeflate, samtools, biobambam2
# Based on Ubuntu 18.04
################

#базовый образ - Ubuntu 18.04
FROM ubuntu:18.04

MAINTAINER Boris Belyaev <belbor1@gmail.com>

ENV SOFT /soft

RUN apt-get update && apt-get install -y \
	apt-utils \
	git \
	autoconf \
	automake \
	make \
	gcc \
	perl \
	zlib1g-dev \
	libbz2-dev \
	liblzma-dev  \
	libcurl4-gnutls-dev \
	libssl-dev \
	libncurses5-dev \
	libtool \
	autotools-dev \
	wget
	
# libdeflate v1.6 2020-05-13  
WORKDIR ${SOFT}/git-libdeflate
RUN git init \
	&& git remote add origin https://github.com/ebiggers/libdeflate.git \
	&& git pull https://github.com/ebiggers/libdeflate.git 753d4a1a625efb478f845f1c4d3869a41f710ae5 \
	&& mkdir ${SOFT}/libdeflate_1.6 \
	&& make --makefile=${SOFT}/git-libdeflate/Makefile \
	&& make install PREFIX=${SOFT}/libdeflate_1.6\
	&& rm -fr ${SOFT}/git-libdeflate

# htslib 1.10.2 2019-12-19  
#WORKDIR ${SOFT}/git-htslib
#RUN git init \
#	&& git remote add origin https://github.com/samtools/htslib.git \
#	&& git pull https://github.com/samtools/htslib.git fd0f89554459b78c07303e2c8a42acacd6851b46 \
#	&& mkdir ${SOFT}/htslib_1.10.2 \
#	&& autoheader \
#	&& autoconf \
#	&& ./configure --with-libdeflate=${SOFT}/libdeflate_1.6 CPPFLAGS=-I${SOFT}/libdeflate_1.6/include LDFLAGS=-L${SOFT}/libdeflate_1.6/lib --prefix=${SOFT}/htslib_1.10.2 \
#	&& make \
#	&& make install \
#	&& rm -fr ${SOFT}/git-htslib

# Samtools Release 1.10 2019-12-06  
WORKDIR ${SOFT}/tar-samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 \
	&& mkdir ${SOFT}/samtools_1.10 \
	&& tar -xvjf ${SOFT}/tar-samtools/samtools-1.10.tar.bz2
WORKDIR ${SOFT}/tar-samtools/samtools-1.10
RUN ./configure --with-libdeflate=yes CPPFLAGS=-I${SOFT}/libdeflate_1.6/include LDFLAGS=-L${SOFT}/libdeflate_1.6/lib --without-curses --prefix=${SOFT}/samtools_1.10 \
	&& make \
	&& make install install-htslib

# Samtools Release 1.10 2019-12-06
#WORKDIR ${SOFT}/git-samtools
#RUN git init \
#	&& git remote add origin https://github.com/samtools/samtools.git \
#	&& git pull https://github.com/samtools/samtools.git 76877ea4e41cd9d9a7f045307485535c7da7422b \
#	&& autoheader \
#	&& autoconf -Wno-syntax \
#	&& ./configure --with-htslib=${SOFT}/htslib_1.10.2 --prefix=${SOFT}/samtools_1.10 \
#	&& make \
#	&& make install \
#	&& rm -fr ${SOFT}/git-samtools
ENV SAMTOOLS ${SOFT}/samtools_1.10/bin/samtools
#samtools: error while loading shared libraries: libhts.so.3: cannot open shared object file: No such file or directory

# zlib 1.2.11
#WORKDIR ${SOFT}/git-zlib 
#RUN git init \
#	&& git remote add origin https://github.com/madler/zlib.git \
#	&& git pull https://github.com/madler/zlib.git cacf7f1d4e3d44d871b605da3b647f07d718623f \
#	&& mkdir ${SOFT}/zlib_1.2.11 \
#	&& make distclean \
#	&& ./configure  --prefix=${SOFT}/zlib_1.2.11 \
#	&& make \
#	&& make install \
#	&& rm -fr ${SOFT}/git-zlib

# libmaus2 release 2.0.750 2020-09-02 (нужен для установки biobambam2)
WORKDIR ${SOFT}/git-libmaus2
RUN git init \
	&& git remote add origin https://gitlab.com/german.tischler/libmaus2.git \
	&& git pull https://gitlab.com/german.tischler/libmaus2.git e8f60a3759a5134bf35ddcc659337d74324efc7f \
	&& mkdir ${SOFT}/libmaus2_2.0.750 \
	&& libtoollze \
	&& aclocal \
	&& autoreconf -i -f \
	&& ./configure --prefix=${SOFT}/libmaus2_2.0.750 \
#	&& ./configure CPPFLAGS=-I{SOFT}/zlib_1.2.11/include  LDFLAGS=-L{SOFT}/zlib_1.2.11/lib  --prefix=${SOFT}/libmaus2_2.0.750 \
	&& make  all all-htslib \
	&& rm -fr ${SOFT}/git-libmaus2

# biobambam2 2.0.175 2020-08-29  
WORKDIR ${SOFT}/git-biobambam2
RUN git init /
	&& git remote add origin https://gitlab.com/german.tischler/biobambam2.git /
	&& git pull https://gitlab.com/german.tischler/biobambam2.git 45e4c6db8c9d7763c4e51875ee98048ee2f41223 /
	&& autoreconf -i -f /
	&& ./configure --with-libmaus2=${SOFT}/libmaus2_2.0.750 --prefix=${SOFT}/biobambam2_2.0.175 /
	&& make install /
	&& rm -fr ${SOFT}/git-biobambam2
