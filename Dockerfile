FROM centos:7
MAINTAINER Amit Malhotra <amit08@gmail.com>

# Set US locale
RUN localedef --quiet -c -i en_US -f UTF-8 en_US.UTF-8
ENV LANGUAGE en_US
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TERM dumb

RUN yum clean all && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y python-pip \
    python34.x86_64 \
    wget \
    unzip \
    gcc \
    nano \
    libjpeg \
    libpng12 \
    libXrender \
    libXext \
    fontconfig \
    xorg-x11-fonts-Type1 \
    libpng \
    xorg-x11-fonts-75dpi \
    openssh-clients.x86_64 \
    rsync \
    mariadb \
    httpd \
    mod_ssl \
    openssl \
    php \
    php-cli \
    php-pecl-memcached \
    php-memcached \
    php-mcrypt \
    gd \
    gd-devel \
    php-gd \
    php-mbstring \
    php-mysql \
    memcached \
    sox \
    lame \
    nodejs \
    npm \
    git

# Install pip for python3
#RUN ln -s /usr/bin/python3.4 /usr/bin/python3
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 -
RUN pip3 install PyMySQL && \
    pip3 install elasticsearch

# Install supervisor
RUN pip2 install supervisor
COPY templates/etc/supervisord.conf /etc/supervisord.conf

# Install WKHTMLTOPDF (HTML TO PDF)
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm -O /tmp/wkhtmltox-0.12.2.1.rpm && \
    rpm -Uvh /tmp/wkhtmltox-0.12.2.1.rpm

# httpd.conf and php.ini file setup
RUN echo "AddType application/x-httpd-php .php" >> /etc/httpd/conf/httpd.conf
RUN echo "php_value short_open_tag On" >> /etc/httpd/conf.d/php.conf
COPY ./templates/etc/php.ini /etc/php.ini

# Install grunt
RUN npm install -g grunt-cli