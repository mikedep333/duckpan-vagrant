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
