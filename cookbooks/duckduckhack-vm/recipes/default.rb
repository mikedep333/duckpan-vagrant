#
# Cookbook Name:: duckduckhack-vm
# Recipe:: default
#

package "xfce4" do
  action :install
end

package "xfce4-terminal" do
  action :install
end

# Enables the Thunar file manager to have icons for files and folders.
package "xubuntu-icon-theme" do
  action :install
end

package "firefox" do
  action :install
end

# vim-tiny has very few features compared to regular vim
package "vim" do
  action :install
end

package "emacs" do
  action :install
end

package "screen" do
  action :install
end
package "byobu" do
  action :install
end

# xubuntu uses this, even though it has "gnome" in the gname
package "language-selector-gnome" do
  action :install
end

# part of xubuntu-desktop, needed for various parts of the OS to work
package "libpam-ck-connector" do
  action :install
end

# The xubuntu display manager and greeter
package "lightdm-gtk-greeter" do
  action :install
end
# Without this, lightdm-gtk-greeter will have missing icons
package "xubuntu-artwork" do
  action :install
end

