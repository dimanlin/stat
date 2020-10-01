FROM lambci/lambda:build-ruby2.5
RUN yum -y install mysql-devel
RUN mkdir /var/task/lib
RUN cp /usr/lib64/mysql/libmysqlclient.so.18 /var/task/lib
COPY ./docker/app/docker-entrypoint.sh /
RUN mkdir /app
WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
