#
# Cookbook Name:: duckduckhack-vm
# Recipe:: duckduckhack-gui
#

include_recipe "sublime-text-editor::default"

package "xfce4"

# xterm & uxterm will also be installed by default
package "xfce4-terminal"

# Enables the Thunar file manager to have icons for files and folders.
package "xubuntu-icon-theme"

package "firefox"

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

# Disable the screensaver. This is common VM advice to avoid wasted CPU.
# (especially because the 2 default screensavers, "Fiberlamp" and "FuzzyFlakes"
# are very CPU intensive.)
cookbook_file "/home/vagrant/.xscreensaver" do
  source ".xscreensaver"
  owner "vagrant"
  group "vagrant"
end
cookbook_file "/etc/skel/.xscreensaver" do
  source ".xscreensaver"
end

# Copy these .desktop files (app shortcuts) to the desktop
# Copying is appropriate because if you drag and drop an app from the start
# menu to the desktop, it copies the .desktop file.
#
# exo-terminal-emulator is the "preferred" XFCE terminal emulator
# On this VM, it will default to the easy-to-use xfterm4,
# but the user can change their preference.
execute "cp --preserve=time /usr/share/applications/exo-terminal-emulator.desktop /etc/skel/Desktop/"
execute "cp --preserve=time /usr/share/applications/exo-terminal-emulator.desktop /home/vagrant/Desktop/"
execute "chown vagrant:vagrant /home/vagrant/Desktop/exo-terminal-emulator.desktop"
#
execute "cp --preserve=time /usr/share/applications/firefox.desktop /etc/skel/Desktop/"
execute "cp --preserve=time /usr/share/applications/firefox.desktop /home/vagrant/Desktop/"
execute "chown vagrant:vagrant /home/vagrant/Desktop/"

service "lightdm" do
  action :start
end
