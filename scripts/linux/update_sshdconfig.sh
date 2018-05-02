# set root password to "vagrant"
echo vagrant> pw
echo vagrant>> pw
sudo passwd root < pw
rm pw

#allow root to login to SSH without using cert auth
sed 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config
sudo service ssh restart
