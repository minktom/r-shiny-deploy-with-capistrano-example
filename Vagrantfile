# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-7.0-64-puppet"

  config.vm.network "forwarded_port", guest: 5858, host: 3838
  config.vm.network "private_network", ip: "192.168.55.11"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "shiny"
    vb.memory = "2048"
  end

  config.ssh.forward_agent = true

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum -y install epel-release
    sudo yum -y update
    sudo yum -y install R
    sudo su - -c "R -e \\\"install.packages('shiny', repos='http://cran.rstudio.com/')\\\""
    wget http://download3.rstudio.org/centos-5.9/x86_64/shiny-server-1.3.0.403-rh5-x86_64.rpm
    sudo yum -y install --nogpgcheck shiny-server-1.3.0.403-rh5-x86_64.rpm

    sudo yum -y install git
    sudo mkdir -m777 /var/www

    sudo useradd -d /home/deploy -m deploy

    sudo iptables -F
  SHELL
end
