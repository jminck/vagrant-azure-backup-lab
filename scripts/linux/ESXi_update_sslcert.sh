vi /etc/hosts
esxcfg-advcfg -s vmwarehost01 /Misc/hostname
cd /etc/vmware/ssl
wget http://web.mit.edu/crypto/openssl.cnf
set OPENSSL_CONF=/etc/vmware/ssl/openssl.cnf
openssl req -x509 -newkey rsa:4096 -keyout rui.key -out rui.crt -days 7300 -nodes -subj '/CN=vmwarehost01' -config /etc/vmware/ssl/openssl.cnf
/etc/init.d/hostd restart
/etc/init.d/vpxa restart