FROM sirvestnik/cxx-conan-base:latest

RUN echo "deb http://mirror.yandex.ru/debian sid main" > /etc/apt/sources.list.d/10-sid-backports.list && \
    echo "APT::Default-Release "stable";" > /etc/apt/apt.conf.d/10-default-release && \
    apt-get update && \
    apt-get -y --no-install-recommends install gcc-5 g++-5 libstdc++-5-dev && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists
