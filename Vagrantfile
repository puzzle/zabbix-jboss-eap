# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 4096
    libvirt.cpus = 4
    libvirt.storage_pool_name = config.user.libvirt.storage_pool_name if config.user.has_key?('libvirt') and config.user['libvirt'].has_key?('storage_pool_name')
    libvirt.suspend_mode = 'managedsave'    
  end

  if config.user.has_key?('config') and config.user['config'].has_key?('synced_folder_type')
    @synced_folder_type = config.user.config.synced_folder_type
  end
  if config.user.has_key?('provision') and config.user['provision'].has_key?('shell')
    @user_shell_provision = config.user.provision.shell
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    #yum -y install epel-release
    #yum -y install ansible
#    cd /vagrant
#    ansible-galaxy install -r requirements.yml

    #{@user_shell_provision}
  SHELL

  config.vm.define "zabbix" do |vmconfig|
    vmconfig.vm.hostname = "zabbix.lan"

    vmconfig.vm.network :private_network,
            :ip => "192.168.122.11",
            :libvirt__network_name => "default"

    vmconfig.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "zabbix.yml"
    end
  end

 config.vm.define "eap" do |vmconfig|
    vmconfig.vm.hostname = "eap.lan"

    vmconfig.vm.network :private_network,
            :ip => "192.168.122.12",
            :libvirt__network_name => "default"

    vmconfig.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "eap.yml"
    end
  end

  if @synced_folder_type.nil?
    config.vm.synced_folder ".", "/vagrant"
  else
    config.vm.synced_folder ".", "/vagrant", type: @synced_folder_type
  end

end
