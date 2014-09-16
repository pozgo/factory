
# To automatically replace the discovery token on 'vagrant up'

$cloud_config_file = CLOUD_CONFIG_PATH
if File.exists?($cloud_config_file) && ARGV[0].eql?('up')
  require 'open-uri'

  token = open('https://discovery.etcd.io/new').read
  puts "Etcd new token: #{token}"
  
  cc_content = File.read($cloud_config_file);
  open($cloud_config_file, 'r+') do |f|
    f.puts(cc_content.gsub(/https:\/\/discovery.etcd.io\/.+/, token))
  end
end

#
#
# coreos-vagrant is configured through a series of configuration
# options (global ruby variables) which are detailed below. To modify
# these options, first copy this file to "config.rb". Then simply
# uncomment the necessary lines, leaving the $, and replace everything
# after the equals sign..

# Size of the CoreOS cluster created by Vagrant
$num_instances = 3

# Official CoreOS channel from which updates should be downloaded
#$update_channel='alpha'

# Enable port forwarding of Docker TCP socket
# Set to the TCP port you want exposed on the *host* machine, default is 2375
# If 2375 is used, Vagrant will auto-increment (e.g. in the case of $num_instances > 1)
# You can then use the docker tool locally by setting the following env var:
#   export DOCKER_HOST='tcp://127.0.0.1:2375'
#$expose_docker_tcp=2375

# Setting for VirtualBox VMs
$vb_memory = 2048
$vb_cpus = 2
