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

# Configure FireFox by copying over the profile.
remote_directory "/home/vagrant/.mozilla" do
  source ".mozilla"
  owner "vagrant"
  group "vagrant"
  mode "700"
  files_owner "vagrant"
  files_group "vagrant"
  # In the profile that was generated, many files are 644, while others are 600.
  # For simplicity of this recipe, just make them all 600.
  files_mode "600"
end
# Workaround a bug in Chef.
# Chef fails to change the ownership (from root:root)
# and permissions (from 755) on 
# .mozilla/firefox/7z1z212a.default/jetpack/jid1-ZAdIEUB7XOzOJw@jetpack/
# and its parent dirs. It does update the ownership and permissions on its
# contents, even the "simple-storage" dir directly underneath it.
#
# If not corrected, this breaks Firefox's ability to open up its main menu.
execute "find /home/vagrant/.mozilla -type d -print0 | xargs -0 sudo chown vagrant:vagrant"
execute "find /home/vagrant/.mozilla -type d -print0 | xargs -0 sudo chmod 700"

service "lightdm" do
  action :start
end
