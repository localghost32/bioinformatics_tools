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

# libdeflate v1.6 2020-05-13 
WORKDIR ${SOFT}/tar-libdeflate
RUN wget https://github.com/ebiggers/libdeflate/archive/v1.6.tar.gz \
	&& tar -xvzf ${SOFT}/tar-libdeflate/v1.6.tar.gz \
	&& cd ${SOFT}/tar-libdeflate/libdeflate-1.6 \
	&& mkdir ${SOFT}/libdeflate_1.6 \
	&& make --makefile=${SOFT}/tar-libdeflate/libdeflate-1.6/Makefile \
	&& make install PREFIX=${SOFT}/libdeflate_1.6 \
	&& rm -fr ${SOFT}/tar-libdeflate

ENV LIBDEFLATEGUNZIP ${SOFT}/libdeflate_1.6/bin/libdeflate-gunzip \
	LIBDEFLATEGZIP ${SOFT}/libdeflate_1.6/bin/libdeflate-gzip 

ENV PATH="${SOFT}/libdeflate_1.6/bin:${PATH}"

# htslib release 1.10.2 2019-12-19  
WORKDIR ${SOFT}/tar-htslib
RUN wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2 \
	&& mkdir ${SOFT}/htslib_1.10.2 \
	&& tar -xvjf ${SOFT}/tar-htslib/htslib-1.10.2.tar.bz2 \
	&& cd ${SOFT}/tar-htslib/htslib-1.10.2 \
	&& autoreconf \
	&& ./configure LDFLAGS=-L${SOFT}/libdeflate_1.6/lib CPPFLAGS=-I${SOFT}/libdeflate_1.6/include --with-libdeflate --prefix=${SOFT}/htslib_1.10.2 \
	&& make \
	&& make install \
	&& rm -fr ${SOFT}/tar-htslib
	
ENV HTSFILE ${SOFT}/htslib_1.10.2/bin/htsfile \
	BGZIP ${SOFT}/htslib_1.10.2/bin/bgzip \
	TABIX ${SOFT}/htslib_1.10.2/bin/tabix 

ENV PATH="${SOFT}/htslib_1.10.2/bin:${PATH}"

# Samtools release 1.10 2019-12-06  
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

ENV PATH="${SOFT}/samtools_1.10/bin:${PATH}" 

# libmaus2 release 2.0.750 2020-09-02 (install for biobambam2)
WORKDIR ${SOFT}/tar-libmaus2
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.750-release-20200903115526/libmaus2-2.0.750-release-20200903115526.tar.bz2 \
	&& mkdir ${SOFT}/libmaus2_2.0.750 \
	&& tar -xvjf ${SOFT}/tar-libmaus2/libmaus2-2.0.750-release-20200903115526.tar.bz2 \
	&& cd ${SOFT}/tar-libmaus2/libmaus2-2.0.750-release-20200903115526 \
	&& ./configure --prefix=${SOFT}/libmaus2_2.0.750 \
	&& make \
	&& make install \
	&& rm -fr ${SOFT}/tar-libmaus2

# biobambam2 2.0.175 2020-08-29  
WORKDIR ${SOFT}/tar-biobambam2
RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.175-release-20200827101416/biobambam2-2.0.175-release-20200827101416.tar.bz2 \
	&& mkdir ${SOFT}/biobabmbam_2.0.175 \
	&& tar -xvjf ${SOFT}/tar-biobambam2/biobambam2-2.0.175-release-20200827101416.tar.bz2 \
	&& cd ${SOFT}/tar-biobambam2/biobambam2-2.0.175-release-20200827101416 \
	&& autoreconf -i -f \
	&& ./configure --with-libmaus2=${SOFT}/libmaus2_2.0.750 --prefix=${SOFT}/biobambam2_2.0.175 \
	&& make install \
	&& rm -fr ${SOFT}/tar-biobambam2

ENV PATH="${SOFT}/biobambam2_2.0.175/bin:${PATH}"

WORKDIR ${SOFT}

CMD ["bash"]
