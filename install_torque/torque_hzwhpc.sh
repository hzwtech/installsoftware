#!/bin/bash
#name_space
TORQUE_HOME=/var/spool/torque
hpchostname=hzwhpc
#
systemctl stop firewalld
systemctl disable firewalld
iptables -L
yum install  -y libxml2-devel openssl-devel gcc gcc-c++ boost-devel libtool -y
#
tar -zxvf torque.tar.gz
cd torque
./configure --prefix=/opt/torque \
    --with-scp--with-default-server=$hpchostname && make && make packages&& make install
cp contrib/init.d/{pbs_{server,mom},trqauthd} /etc/init.d/
#
for i in pbs_server pbs_mom trqauthd
do
chkconfig --add $i
chkconfig $i on
done
echo "127.0.0.1  hzwhpc">>/etc/hosts
echo -e "\$pbsserver hzwhpc\n\$logevent 255">/var/spool/torque/mom_priv/config
#
echo $hpchostname>$TORQUE_HOME/server_name
qterm
./torque.setup root
for i in pbs_server pbs_mom trqauthd
do service $i start
done
#
touch /var/spool/torque/server_priv/nodes
echo "hzwhpc np=12" >> /var/spool/torque/server_priv/nodes

service pbs_server restart



tar -zxvf /opt/software/maui-3.3.tar.gz
cd maui-3.3
./configure --prefix=/opt/maui/3.3 --with-spooldir=/opt/maui/3.3_spool LDFLAGS="-L/opt/torque/lib"
make
make install
cd ..
chmod +x maui
cp maui /etc/init.d

/etc/init.d/maui start
chkconfig maui on


