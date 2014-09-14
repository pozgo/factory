# -*- mode: ruby -*-
# # vi: set ft=ruby :
require 'fileutils'
Vagrant.require_version ">= 1.6.0"

CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), 'user-data.yaml')
CONFIG            = File.join(File.dirname(__FILE__), 'vagrant-config.rb')

# Defaults for config options defined in CONFIG
$num_instances = 1
$vb_memory = 512
$vb_cpus = 1

# Load/override config
require CONFIG if File.exist?(CONFIG)

#
# Vagrant config
#
Vagrant.configure("2") do |config|
  config.vm.box = 'yungsang/coreos-beta'
  config.vm.box_version = ">= 1.1.3"
  
  config.ssh.private_key_path = [
    '~/.ssh/id_rsa',
    '~/.vagrant.d/insecure_private_key'
  ]

  (1..$num_instances).each do |i|
    config.vm.define vm_name = "factory-%02d" % i do |config|
      config.vm.hostname = vm_name

      if $expose_docker_tcp
        config.vm.network "forwarded_port", guest: 2375, host: ($expose_docker_tcp + i - 1), auto_correct: true
      end
      
      config.vm.provider :parallels do |v, override|
        v.customize ['set', :id, '--memsize', $vb_memory]
        v.customize ['set', :id, '--cpus', $vb_cpus]
        v.customize ['set', :id, '--adaptive-hypervisor', 'on']
      end

      ip = "172.17.37.#{i+100}"
      config.vm.network :private_network, ip: ip

      # Uncomment below to enable NFS for sharing the host machine into the coreos-vagrant VM.
      # config.vm.synced_folder ".", "/home/core/vagrant", type: 'rsync', rsync__auto: true, rsync__exclude: ['.git/']

      if File.exist?(CLOUD_CONFIG_PATH)
        config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => '/tmp/vagrantfile-user-data'
        config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/"
      end
    end
  end
end
