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
	
# Samtools Release 1.10 2019-12-06  
WORKDIR ${SOFT}/tar-samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 \
	&& mkdir ${SOFT}/samtools_1.10 \
	&& tar -xvjf ${SOFT}/tar-samtools/samtools-1.10.tar.bz2 \
	&& cd ${SOFT}/tar-samtools/samtools-1.10 \
	&& ./configure --without-curses --prefix=${SOFT}/samtools_1.10 \
	&& make all all-htslib \
	&& make install install-htslib \
	&& rm -fr ${SOFT}/tar-samtools

ENV SAMTOOLS ${SOFT}/samtools_1.10/bin/samtools

# libmaus2 release 2.0.750 2020-09-02
WORKDIR ${SOFT}/tar-libmaus2
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.750-release-20200903115526/libmaus2-2.0.750-release-20200903115526.tar.bz2 \
	&& mkdir ${SOFT}/libmaus2_2.0.750 \
	&& tar -xvjf ${SOFT}/tar-libmaus2/libmaus2-2.0.750-release-20200903115526.tar.bz2 \
	&& cd ${SOFT}/tar-libmaus2/libmaus2-2.0.750-release-20200903115526 \
	&& apt -y install build-essential \
	&& ./configure --prefix=${SOFT}/libmaus2_2.0.750 \
#	&& ./configure CPPFLAGS=-I/usr/include LIBS=-lz/usr/lib/x86_64-linux-gnu/pkgconfig/zlib.pc --prefix=${SOFT}/libmaus2_2.0.750 \
	&& make \
	&& rm -fr ${SOFT}/tar-libmaus2



# libmaus2 release 2.0.750 2020-09-02 
#WORKDIR ${SOFT}/git-libmaus2
#RUN git init \
#	&& git remote add origin https://gitlab.com/german.tischler/libmaus2.git \
#	&& git pull https://gitlab.com/german.tischler/libmaus2.git e8f60a3759a5134bf35ddcc659337d74324efc7f \
#	&& mkdir ${SOFT}/libmaus2_2.0.750 \
#	&& libtoollze \
#	&& aclocal \
#	&& autoreconf -i -f \
#	&& ./configure --prefix=${SOFT}/libmaus2_2.0.750 \
##	&& ./configure CPPFLAGS=-I{SOFT}/zlib_1.2.11/include  LDFLAGS=-L{SOFT}/zlib_1.2.11/lib  --prefix=${SOFT}/libmaus2_2.0.750 \
#	&& make  all all-htslib \
#	&& rm -fr ${SOFT}/git-libmaus2

# biobambam2 2.0.175 2020-08-29  
WORKDIR ${SOFT}/git-biobambam2
RUN git init \
	&& git remote add origin https://gitlab.com/german.tischler/biobambam2.git \
	&& git pull https://gitlab.com/german.tischler/biobambam2.git 45e4c6db8c9d7763c4e51875ee98048ee2f41223 \
	&& autoreconf -i -f \
	&& ./configure --with-libmaus2=${SOFT}/libmaus2_2.0.750 --prefix=${SOFT}/biobambam2_2.0.175 \
	&& make install \
	&& rm -fr ${SOFT}/git-biobambam2

ENV BIOBAMBAM2 ${SOFT}/biobambam2_2.0.175/bin/

CMD ["bash"]
