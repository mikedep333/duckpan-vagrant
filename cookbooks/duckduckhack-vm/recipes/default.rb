#
# Cookbook Name:: duckduckhack-vm
# Recipe:: default
#

# Enable multiverse because many users will want to install packages from it.
execute "cp -a /etc/apt/sources.list /etc/apt/sources.list.before-multiverse"
execute 'awk \'{if ($1 == "#" && $5 == "multiverse") { print $2,$3,$4,$5} else {print $0}}\' /etc/apt/sources.list.before-multiverse > /etc/apt/sources.list'

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
