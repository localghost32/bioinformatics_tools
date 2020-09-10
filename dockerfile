################
# Dockerfile with samtools (htslib, libdeflate) & biobambam2 (libmaus2)
# Based on Ubuntu 18.04
################

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
	wget \
	build-essential \
	pkg-config

# libdeflate v1.6 2020-05-13 https://github.com/ebiggers/libdeflate/tree/v1.6
WORKDIR ${SOFT}/git-libdeflate
RUN git init \
	&& git remote add origin https://github.com/ebiggers/libdeflate.git \
	&& git pull https://github.com/ebiggers/libdeflate.git 753d4a1a625efb478f845f1c4d3869a41f710ae5 \
	&& mkdir ${SOFT}/libdeflate_1.6 \
	&& make --makefile=${SOFT}/git-libdeflate/Makefile \
	&& make install PREFIX=${SOFT}/libdeflate_1.6 
ENV LIBDEFLATE ${SOFT}/libdeflate_1.6/bin

# htslib release 1.10.2 2019-12-19  
WORKDIR ${SOFT}/tar-htslib
RUN wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2 \
	&& mkdir ${SOFT}/htslib_1.10.2 \
	&& tar -xvjf ${SOFT}/tar-htslib/htslib-1.10.2.tar.bz2 \
	&& cd ${SOFT}/tar-htslib/htslib-1.10.2 \
	&& autoreconf \
	&& ./configure LDFLAGS=-L${SOFT}/libdeflate_1.6/lib CPPFLAGS=-I${SOFT}/libdeflate_1.6/include --with-libdeflate --prefix=${SOFT}/htslib_1.10.2 \
	&& make \
	&& make install  
ENV HTSLIB ${SOFT}/htslib_1.10.2/bin

# Samtools release 1.10 2019-12-06  
WORKDIR ${SOFT}/tar-samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 \
	&& mkdir ${SOFT}/samtools_1.10 \
	&& tar -xvjf ${SOFT}/tar-samtools/samtools-1.10.tar.bz2 \
	&& cd ${SOFT}/tar-samtools/samtools-1.10 \
	&& ./configure --without-curses --prefix=${SOFT}/samtools_1.10 \
	&& make all all-htslib \
	&& make install install-htslib 
ENV SAMTOOLS ${SOFT}/samtools_1.10/bin

# libmaus2 release 2.0.750 2020-09-02 (install for biobambam2)
WORKDIR ${SOFT}/tar-libmaus2
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.750-release-20200903115526/libmaus2-2.0.750-release-20200903115526.tar.bz2 \
	&& mkdir ${SOFT}/libmaus2_2.0.750 \
	&& tar -xvjf ${SOFT}/tar-libmaus2/libmaus2-2.0.750-release-20200903115526.tar.bz2 \
	&& cd ${SOFT}/tar-libmaus2/libmaus2-2.0.750-release-20200903115526 \
	&& ./configure --prefix=${SOFT}/libmaus2_2.0.750 \
	&& make \
	&& make install 

# biobambam2 2.0.175 2020-08-29  
WORKDIR ${SOFT}/git-biobambam2
RUN git init \
	&& git remote add origin https://gitlab.com/german.tischler/biobambam2.git \
	&& git pull https://gitlab.com/german.tischler/biobambam2.git 45e4c6db8c9d7763c4e51875ee98048ee2f41223 \
	&& autoreconf -i -f \
	&& ./configure --with-libmaus2=${SOFT}/libmaus2_2.0.750 --prefix=${SOFT}/biobambam2_2.0.175 \
	&& make install 
ENV BIOBAMBAM2 ${SOFT}/biobambam2_2.0.175/bin

WORKDIR ${SOFT}
RUN rm -fr ${SOFT}/tar-samtools ${SOFT}/tar-libmaus2 ${SOFT}/git-biobambam2 ${SOFT}/git-libdeflate ${SOFT}/tar-htslib
ENV PATH="/soft/samtools_1.10/bin:${PATH}" 
ENV PATH="/soft/biobambam2_2.0.175/bin:${PATH}"
ENV PATH="/soft/libdeflate_1.6/bin:${PATH}"
ENV PATH="/soft/htslib_1.10.2/bin:${PATH}"

CMD ["bash"]
