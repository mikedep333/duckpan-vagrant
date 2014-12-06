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

# Terminal multiplexers
package "screen"
package "byobu"

# The boxes contain this user, but there is no need for it.
# Use "userdel" rather than "deluser" because it is portable betwen distros
execute "userdel --remove ubuntu" do
  # returns 6 is the user DNE.
  returns [0, 6]
end

cookbook_file "/etc/init.d/duckpan-update" do
  source "etc/init.d/duckpan-update"
  mode "755"
end
cookbook_file "/etc/init/lightdm.override" do
  source "etc/init/lightdm.override"
  mode "644"
end

execute "update-rc.d duckpan-update defaults"

# Restore the Ubuntu 12.04 default grub config file.
# Prevents users from being prompted about how to handle the "locally modified"
# grub config file when a grub update is installed.
# cloud-images.ubuntu.com modifies this file in their boxes,
# but VirtualBox and VMware do not need those modifications..
cookbook_file "/etc/default/grub" do
  source "etc/default/grub"
end
