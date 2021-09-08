FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONPATH="/usr/local/lib/python3/dist-packages/"

ENV GSM_FREQUENCY="950.4M"
ENV GSM_GAIN="30.0"
ENV GSM_PPM="0.0"
ENV GSM_SAMP_RATE="2.0M"
#
#ENV GSM_COLLECTOR="localhost"
#ENV GSM_COLLECTORPORT="4729"
#ENV GSM_SERVERPORT="4729"
#ENV GSM_SHIFTOFF="400.0k"

RUN apt-get update; \
    apt-get install -y \
	git \
    cmake \
    autoconf \
    libtool \
    pkg-config \
    build-essential \
    python-docutils \
    libcppunit-dev \
    swig \
    doxygen \
    liblog4cpp5-dev \
#   python-scipy \
    python3-scipy \
#   python-gtk2 \
    python-wxgtk3.0 \
    gnuradio-dev \
    gr-osmosdr \
    libosmocore-dev \
    liborc-0.4-0 \
    liborc-0.4-dev \
    librtlsdr-dev
	
#Install GR-GSM
RUN cd /opt && git clone https://git.osmocom.org/gr-gsm; \
    cd gr-gsm/ && mkdir build && cd build && cmake .. && mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/ && make && make install && ldconfig

CMD grgsm_livemon -f $GSM_FREQUENCY -g $GSM_GAIN -p $GSM_PPM -s $GSM_SAMP_RATE

EXPOSE 4729