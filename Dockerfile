FROM centos
MAINTAINER zou sheng <zouyu12344444@126.com>

RUN yum install -y gcc gcc-c++ patch pcre  pcre-devel openssl openssl-devel  unzip

RUN curl -SL "http://tengine.taobao.org/download/tengine-2.1.1.tar.gz" -o tengine.tar.gz \
    &&  mkdir -p /usr/src/nginx \
    &&  tar zxvf tengine.tar.gz -C /usr/src \
    && mv /usr/src/tengine-2.1.1 /usr/src/nginx \
    && curl -LOk https://github.com/yaoweibin/nginx_tcp_proxy_module/archive/master.zip \
    && unzip master.zip -d /usr/src/nginx \
    && rm master.zip

RUN cd /usr/src/nginx/tengine-2.1.1 && ls \
    && patch -p1 < /usr/src/nginx/nginx_tcp_proxy_module-master/tcp.patch \
    &&  ./configure --add-module=/usr/src/nginx/nginx_tcp_proxy_module-master \
    &&  make  && make install 

ADD nginx.conf /usr/local/nginx/conf/
ADD conf.d    /usr/local/nginx/conf/

ENV PATH /usr/local/nginx/sbin:$PATH
WORKDIR /usr/local/nginx/html

EXPOSE 80 443
CMD ["nginx","-g","daemon off;"] 
