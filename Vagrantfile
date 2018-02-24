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
  config.hostmanager.enabled = true

  config.vm.box = "ubuntu/trusty64"

  config.vm.define "control", primary: true do |h|
    h.vm.hostname =  "control"
    h.vm.network "public_network", bridge: "en1"
    h.vm.provision :shell, inline: 'echo demo > /home/vagrant/.vault_pass.txt'
    h.vm.provision "shell" do |provision|
      provision.path = "scripts/linux/provision_ansible.sh"
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
  end

  config.vm.define "dc01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "dc01"
    h.vm.network "public_network", ip: "192.168.1.150", bridge: "en1", use_dhcp_assigned_default_route: true
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

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "backup01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "backup01"
    h.vm.network "public_network", bridge: "en1"
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
    h.vm.provision "shell", path: "scripts/windows/ConfigBackupServer.cmd"

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 4096
    end
  end

  
  config.vm.define "backup02" do |h|
    h.vm.box = "opentable/win-2012-standard-amd64-nocm"
    h.vm.hostname = "backup02"
    h.vm.network "public_network", bridge: "en1"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.provider "virtualbox" do |vb|
      file_to_disk = 'large_disk.vdi'
      unless File.exist?(file_to_disk)
        vb.customize ['createhd', '--filename', file_to_disk, '--size', 500 * 1024]
      end
      vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'hdd', '--medium', file_to_disk]
   end

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    h.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true 
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-general.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 
    #h.vm.provision "shell", path: "scripts/windows/ConfigBackupServer.cmd"

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 4096
    end
  end

  config.vm.define "app01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "app01"
    h.vm.network "public_network", bridge: "en1"
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

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "config01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "config01"
    h.vm.network "public_network", bridge: "en1"
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

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "db01" do |h|
    h.vm.box = "mwrock/Windows2012R2"
    h.vm.hostname = "db01"
    h.vm.network "public_network", bridge: "en1"
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
    
    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 2048
    end
  end
end

