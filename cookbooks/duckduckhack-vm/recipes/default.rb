#
# Cookbook Name:: duckduckhack-vm
# Recipe:: default
#

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
