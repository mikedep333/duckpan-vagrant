# -*- mode: ruby -*-
# vi: set ft=ruby :

CUSTOM_CONFIG = {
                  "BOX_NAME"  =>  "precise64", 
                  "BOX_URL"   =>  "http://files.vagrantup.com/precise64.box", 
                  "HEADLESS"  =>  false, 
                  "GUI"       =>  true, 
                  "DDG_PATH"  =>  "~/DuckDuckGo/repos"
                }

Vagrant.configure("2") do |config|

  # precise64 ships with chef 10, so we need to upgrade it.
  config.omnibus.chef_version = :latest

  # Change this to the name of your Vagrant base box.
  config.vm.box = CUSTOM_CONFIG['BOX_NAME']

  # Change this to a URL from which the base box can be downloaded, if you like.
  config.vm.box_url = CUSTOM_CONFIG['BOX_URL']

  # enable Berkshelf integration for Chef cookbook management
  config.berkshelf.enabled = true

  # 'duckpan server' runs a development server on port 5000, so this forwards
  # that port to make it accessible.
  config.vm.network :forwarded_port, guest: 5000, host: 5000

  # headless?  change to 'GUI' to have the VM's window available
  config.vm.provider :virtualbox do |vb|
    vb.gui = CUSTOM_CONFIG['GUI']
  end

  # Enable provisioning with chef solo, using the included cookbooks.  The
  # duckpan::default recipe sets up some dependencies and calls the included
  # duckpan.sh shell script.
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = './cookbooks'

    # uncomment this if you find Ubuntu's mirrors to be going very slow.
    chef.add_recipe 'fastermirror'

    chef.add_recipe 'apt'
    chef.add_recipe 'build-essential'
    chef.add_recipe 'duckpan'

    # uncomment to run chef-solo in debug
    chef.arguments = '-l debug'
  end


  # setup synced folder for the DDG code: "local host machine path", "path on guest vm"
  config.vm.synced_folder CUSTOM_CONFIG['DDG_PATH'], "/code"

  config.vm.define "duckpan" do |duckpan|
  end

  config.vm.define "duckduckhack" do |duckduckhack|
    duckduckhack.vm.provision :chef_solo do |chef|
      chef.add_recipe 'duckduckhack-vm'
    end
    duckduckhack.vm.hostname = "duckduckhack"
  end

end
