#
# Cookbook Name:: duckduckhack-vm
# Recipe:: default
#

include_recipe "duckduckhack-vm::setpassword"
include_recipe "sublime-text-editor::default"

package "xfce4"

# xterm & uxterm will also be installed by default
package "xfce4-terminal"

# Enables the Thunar file manager to have icons for files and folders.
package "xubuntu-icon-theme"

package "firefox"

# Commonly used text editors
# The default package "vim-tiny" has very few features compared to regular vim
package "vim"
package "emacs"

# Terminal multiplexers
package "screen"
package "byobu"

# xubuntu uses this, even though it has "gnome" in the gname
package "language-selector-gnome"

# part of xubuntu-desktop, needed for various parts of the OS to work
package "libpam-ck-connector"
execute "enable libpam-ck-connector" do
  command "sudo dpkg-reconfigure libpam-ck-connector"
  action :run
end

# The xubuntu display manager and greeter
package "lightdm-gtk-greeter"
# Without this, lightdm-gtk-greeter will have missing icons
package "xubuntu-artwork"

# This must be run after lightdm-gtk-greeter is installed.
include_recipe "duckduckhack-vm::artwork"

service "lightdm" do
  action :start
end
