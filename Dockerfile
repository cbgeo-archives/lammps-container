FROM centos:latest
MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Update to latest packages and development tools
RUN yum update -y && \
    yum -y groupinstall "Development Tools" && \
    yum install -y wget && \
    yum clean all

# Download and compile LAMMPS
RUN cd /opt && wget http://lammps.sandia.gov/tars/lammps-stable.tar.gz && \
    mkdir -p /opt/lammps && cd /opt/lammps && \
    tar xf ../lammps-stable.tar.gz --strip-components 1 && \
    cd src && \
    make yes-granular |& tee log.make_yes_granular && \
    make -j serial |& tee log.make_serial

# Change to lammps directory
ENTRYPOINT ["/opt/lammps/src/lmp_serial", "-i"]
CMD ["/opt/lammps/examples/granregion/in.granregion.mixer"]

