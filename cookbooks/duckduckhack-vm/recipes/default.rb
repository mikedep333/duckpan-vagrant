#
# Cookbook Name:: duckduckhack-vm
# Recipe:: default
#

# Purges or removes unneeded packages at the beginning of the chef run,
# so that (hopefully) new data will overwrite their disk space and not expand
# the disk.
include_recipe "duckduckhack-vm::InitialDiskCleanup"

# Delete the git repos cloned during the duckpan cookbook, because they will be
# out of date by the time a user uses the VM, and because there is no reliable
# way to update them at boot if a user has made changes.
directory "/home/vagrant/zeroclickinfo-goodies/" do
  action :delete
  recursive true
end
directory "/home/vagrant/zeroclickinfo-spice/" do
  action :delete
  recursive true
end

# Enable multiverse because many users will want to install packages from it.
execute "cp -a /etc/apt/sources.list /etc/apt/sources.list.before-multiverse"
execute 'awk \'{if ($1 == "#" && $5 == "multiverse") { print $2,$3,$4,$5} else {print $0}}\' /etc/apt/sources.list.before-multiverse > /etc/apt/sources.list'
execute "apt-get update"

include_recipe "duckduckhack-vm::setpassword"

cookbook_file "/etc/motd.tail" do
  source "etc/motd.tail"
end

# Commonly used text editors
# The default package "vim-tiny" has very few features compared to regular vim
package "vim"
package "emacs"

cookbook_file "/home/vagrant/.vimrc" do
  source "etc/skel/.vimrc"
  owner "vagrant"
  group "vagrant"
end
cookbook_file "/etc/skel/.vimrc" do
  source "etc/skel/.vimrc"
end

# Terminal multiplexers
package "screen"
package "byobu"

# The boxes contain this user, but there is no need for it.
# Use "userdel" rather than "deluser" because it is portable betwen distros
execute "userdel --remove ubuntu" do
  # returns 6 is the user DNE.
  returns [0, 6]
end

cookbook_file "/usr/local/bin/update-duckpan.sh" do
  source "usr/local/bin/update-duckpan.sh"
  mode "755"
end

# Restore the Ubuntu 12.04 default grub config file.
# cloud-images.ubuntu.com modifies this file in their boxes,
# but VirtualBox and VMware do not need those modifications..
#
# Also, one modification has been made: GRUB_RECORDFAIL_TIMEOUT has been set.
# This way, users do not wait endlessly if they hard power off the VM,
# which is annoying for users running headless.
cookbook_file "/etc/default/grub" do
  source "etc/default/grub"
end

# Prevent users from being prompted about how to handle the "locally modified"
# grub config file when a grub update is installed.
execute 'echo "grub grub/update_grub_changeprompt_threeway string keep_current" | debconf-set-selections'
