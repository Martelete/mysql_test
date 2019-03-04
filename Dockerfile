FROM ubuntu
RUN mkdir /git/mysql_test1
ADD update_db /git/mysql_test
ADD mysql-updatetables1_2.sh /git/
RUN apt-get install -y mysql-server
ADD run.sh /root/ 
RUN /root/run.sh
ENTRYPOINT systemctl mysqld start && bash
