# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

DISTCC_HOST = "172.64.1.2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "arch"
  config.vm.network "private_network", ip: DISTCC_HOST

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provision "shell" do |s|
    s.path = "provision.sh"
    s.privileged = true
  end
end
