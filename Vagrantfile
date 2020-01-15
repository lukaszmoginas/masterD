# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
$user="project"
$password="project"

$vm_name="masterD"
$vm_ip="10.24.0.2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.ssh.username = $user
	config.ssh.forward_x11 = true
	config.ssh.shell = "bash"

	config.vm.box = "nfqlt/docker"
	config.vm.network "private_network", ip: $vm_ip, netmask: "255.255.0.0"
	config.vm.provider "virtualbox" do |vbox|
        vbox.name = $vm_name
        vbox.customize ["modifyvm", :id, "--cpus", 4]
        vbox.customize ["modifyvm", :id, "--memory", "6144"]
        vbox.customize ["modifyvm", :id, "--name", $vm_name]
        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

        vbox.customize ["modifyvm", :id, "--nic1", "nat"]
        vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]

        vbox.customize ["modifyvm", :id, "--nic2", "hostonly"]
        vbox.customize ["modifyvm", :id, "--nictype2", "virtio"]
        vbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]

        vbox.customize ["setextradata", :id, "--VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
        vbox.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 500]
    end

    config.vm.provision "shell", inline: "/vagrant/bootstrap.sh '"+$vm_name+"' '"+$vm_ip+"'"
    config.vm.provision "shell", inline: "/root/scripts/networking.sh", run: "always"
end
