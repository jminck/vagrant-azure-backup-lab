# -*- mode: ruby -*-
# vi: set ft=ruby :

# README
#
# Getting Started:
# 1. vagrant plugin install vagrant-hostmanager
# 2. vagrant up
# 3. vagrant ssh
#
# This should put you at the control host
#  with access, by name, to other vms
Vagrant.configure(2) do |config|

  config.vm.box = "hashicorp/precise64"
  #ths user creds in the next line will need to exist on the host this machine is running inside of, to create a share mapping between /vagrant on the guest to CWD on the host
  config.vm.synced_folder '.', '/vagrant', type: 'smb', smb_username:  "vagrant", smb_password: "vagrant"
  
  
  config.vm.define "control", primary: true do |h|
    h.vm.hostname =  "control"
    h.vm.network "public_network"
    h.vm.provision :shell, inline: 'echo demo > /home/vagrant/.vault_pass.txt'
    h.vm.provision "shell" do |provision|
      provision.path = "scripts/linux/provision_ansible.sh"
	  provision.path = "scripts/linux/update_sshdconfig.sh"
    end 
    h.vm.provision :shell, :inline => <<'EOF'

	if [ ! -f "/home/vagrant/.ssh/id_rsa" ]; then
  ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
fi
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/control.pub

cat << 'SSHEOF' > /home/vagrant/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
SSHEOF

chown -R vagrant:vagrant /home/vagrant/.ssh/
EOF

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "control"
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  

  config.vm.define "control2", primary: true do |h|
    h.vm.box = "centos/7"
    h.vm.hostname =  "control2"
    h.vm.network "public_network"
    h.vm.provision :shell, inline: 'echo demo > /home/vagrant/.vault_pass.txt'
	h.vm.provision "shell" do |provision|
      provision.path = "scripts/linux/provision_ansible.sh"
	  provision.path = "scripts/linux/update_sshdconfig.sh"
    end 
    h.vm.provision :shell, :inline => <<'EOF'

        if [ ! -f "/home/vagrant/.ssh/id_rsa" ]; then
  ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
fi
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/control.pub

cat << 'SSHEOF' > /home/vagrant/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
SSHEOF

chown -R vagrant:vagrant /home/vagrant/.ssh/
EOF

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "control2"
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "dc01" do |h|
    # use the plaintext WinRM transport and force it to use basic authentication.
    # NB this is needed because the default negotiate transport stops working
    #    after the domain controller is installed.
    #    see https://groups.google.com/forum/#!topic/vagrant-up/sZantuCM0q4

    # commented out because base image doesn't have this enabled - it is in install-genera
    # h.winrm.transport = :plaintext
    # h.winrm.basic_auth_only = true

    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "dc01"
    # note this IP address is used in another script by domain members to set DNS: scripts\windows\domain\joindomain.ps1
    h.vm.network "public_network", #ip: "192.168.1.150"
    # h.vm.provision "shell",   run: "always",  inline: "route add 0.0.0.0 MASK 0.0.0.0  192.168.1.254 -p"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

    h.vm.provision "shell", path: "scripts/windows/domain/installAD.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/domain/dcpromo.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload
    h.vm.provision "shell", inline: "slmgr /rearm"    
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "dc01"
        vm.cpus = 2
        vm.memory = 4096
    end
  end

  config.vm.define "mabs01" do |h|
    h.vm.box = "jminck/server2016rtm"
    h.vm.hostname = "backup01"
    h.vm.network "public_network", bridge: "External"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    h.vm.synced_folder '.', '/vagrant', type: 'smb' , smb_username: "vagrant", smb_password: "vagrant"
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", path: "scripts/windows/ConfigBackupServer2016.cmd"

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "mabs01"
        vm.cpus = 2
        vm.memory = 4096
    end
  end

  
  config.vm.define "backup02" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "backup02"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.provider "hyperv" do |vb|
      file_to_disk = '/mnt/vms/large_disk.vdi'
   end

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    h.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true 
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", path: "scripts/windows/ConfigBackupServer2012.cmd"

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "backup02"
        vm.cpus = 2
        vm.memory = 4096
    end
  end

  config.vm.define "app01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "app01"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "app01"
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "config01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "config01"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false
    h.vm.provision :reload 
    h.vm.provision "shell", inline: "slmgr /rearm" 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "config01"
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "db01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "db01"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 
    
    h.vm.provider "hyperv" do |vm|
		vm.vmname = "db01"
        vm.cpus = 2
        vm.memory = 2048
    end
  end
  
  config.vm.define "vmhost01" do |h|
    h.vm.box = "mwrock/Windows2016"
    h.vm.hostname = "vmhost01"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
	h.vm.provision "shell", path: "scripts/windows/installChocolatey.cmd"    
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 

    h.vm.provider "hyperv" do |vm|
		vm.vmname = "vmhost01"
        vm.cpus = 4
        vm.memory = 8192
    end
  end

  
  config.vm.define "vmhost02" do |h|
    h.vm.box = "2016rtm"
    h.vm.hostname = "vmhost02"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600


    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    h.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true 
	h.vm.provision "shell", path: "scripts/windows/installChocolatey.cmd"
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 


    h.vm.provider "hyperv" do |vm|
		vm.vmname = "vmhost02"
        vm.cpus = 4
        vm.memory = 8192
    end
  end
  
    config.vm.define "inmage01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "inmage01"
    h.vm.network "public_network"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600
    h.vm.synced_folder '.', '/vagrant', type: 'smb', smb_username:  "vmhost\vagrant", smb_password: "vagrant"


    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    h.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true 
	h.vm.provision "shell", path: "scripts/windows/installChocolatey.cmd"
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 


    h.vm.provider "hyperv" do |vm|
		vm.vmname = "inmage01"
        vm.cpus = 2
        vm.memory = 4096
    end
  end
  
end

