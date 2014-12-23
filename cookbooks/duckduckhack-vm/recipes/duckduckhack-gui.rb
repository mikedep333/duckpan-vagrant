#
# Cookbook Name:: duckduckhack-vm
# Recipe:: duckduckhack-gui
#

# Note: sublime-text-editor::default is included below

package "xfce4"

# Remove this package because:
# 1. It takes up 8.5 MB installed. It contains artwork.
# 2. It would set the bootloader to a debian background, is likely to confuse
# users into thinking they are using Debian rather than Ubuntu.
# (#2 is fixed in Ubuntu 14.04)
package "desktop-base" do
  action :purge
end

# In order for the XFCE start menu and Thunar file browser to have icons,
# the Tango icon theme is selected in this cookbook's xsettings.xml
#
# tango-icon-theme is preferable to xubuntu-icon-theme because it is
# 10.8 MB rather than 26.8 MB.
#
# tango-icon-theme is installed automatically because xfce4 recommends it.
# However, as a precaution, we will explicitly install it anyway.
package "tango-icon-theme"

# xterm & uxterm will also be installed by default
package "xfce4-terminal"

# An archive manager is necessary because many (novice) developers exchange
# code via archives rather than VCSs
#
# I would specify squeeze (the XFCE archiver), but it is unable to handle .7z
# files and was removed in ubuntu 13.10
#
# Similarly, xarchiver in Ubuntu 12.04 has buggy handling of .7z files.
#
# Ubuntu Desktop, Xubuntu and Lubuntu 12.04 all use file-roller, so let's use
# that, even though it is not as lightweight.
#
package "file-roller" do
  # Do not install the entire humanity-icon-theme, gnome-icon-theme and
  # some other smaller packages
  options "--no-install-recommends"
end
# Integrate file-roller with Thunar
package "thunar-archive-plugin"
# RARR!
package "unrar"

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

# Simple script to update Ubuntu
# Desktop shortcut is created below
cookbook_file "/usr/local/bin/update-ubuntu.sh" do
  source "usr/local/bin/update-ubuntu.sh"
  mode "755"
end

# Copy these .desktop files (app shortcuts) to the desktop
# Copying is appropriate because if you drag and drop an app from the start
# menu to the desktop, it copies the .desktop file.
#
# exo-terminal-emulator is the "preferred" XFCE terminal emulator
# On this VM, it will default to the easy-to-use xfterm4,
# but the user can change their preference.
#
directory "/etc/skel/Desktop/"
directory "/home/vagrant/Desktop/" do
  owner "vagrant"
  group "vagrant"
end
execute "cp --preserve=time /usr/share/applications/exo-terminal-emulator.desktop /etc/skel/Desktop/"
execute "cp --preserve=time /usr/share/applications/exo-terminal-emulator.desktop /home/vagrant/Desktop/"
execute "chown vagrant:vagrant /home/vagrant/Desktop/exo-terminal-emulator.desktop"
#
execute "cp --preserve=time /usr/share/applications/firefox.desktop /etc/skel/Desktop/"
execute "cp --preserve=time /usr/share/applications/firefox.desktop /home/vagrant/Desktop/"
execute "chown vagrant:vagrant /home/vagrant/Desktop/"

cookbook_file "/etc/skel/Desktop/Update Ubuntu.desktop" do
  source "etc/skel/Desktop/Update Ubuntu.desktop"
end
cookbook_file "/home/vagrant/Desktop/Update Ubuntu.desktop" do
  source "etc/skel/Desktop/Update Ubuntu.desktop"
  owner "vagrant"
  group "vagrant"
end

# URL to https://github.com/duckduckgo/p5-app-duckpan
cookbook_file "/etc/skel/Desktop/Get Started.desktop" do
  source "etc/skel/Desktop/Get Started.desktop"
end
cookbook_file "/home/vagrant/Desktop/Get Started.desktop" do
  source "etc/skel/Desktop/Get Started.desktop"
  owner "vagrant"
  group "vagrant"
end

include_recipe "sublime-text-editor::default"

# XFCE will automatically use this autostart .desktop file
cookbook_file "/etc/xdg/autostart/update-duckpan.desktop" do
  source "etc/xdg/autostart/update-duckpan.desktop"
end

link "/home/vagrant/Desktop/update-duckpan.log" do
  to "/tmp/update-duckpan.log"
  owner "vagrant"
  group "vagrant"
end
link "/etc/skel/Desktop/update-duckpan.log" do
  to "/tmp/update-duckpan.log"
end

# Configure FireFox by copying over the profile.
remote_directory "/etc/skel/.mozilla" do
  source ".mozilla"
end
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
# There appears to be a bug in Chef.
# Chef fails to change the ownership (from root:root)
# and permissions (from 755) on:
# .mozilla/firefox/7z1z212a.default/jetpack/jid1-ZAdIEUB7XOzOJw@jetpack/
# .mozilla/firefox/7z1z212a.default/jetpack/
# .mozilla/firefox/7z1z212a.default/
# None of the other directories or files are affected.
# Even the following subdir is not affected:
# .mozilla/firefox/7z1z212a.default/jetpack/jid1-ZAdIEUB7XOzOJw@jetpack/simple-storage/
#
# If not corrected, this breaks Firefox's ability to open up its main menu.
execute "find /home/vagrant/.mozilla -type d -print0 | xargs -0 sudo chown vagrant:vagrant"
execute "find /home/vagrant/.mozilla -type d -print0 | xargs -0 sudo chmod 700"

# Launcher Icons
#
# TODO: Improve this code by copying and modifying the .desktop files from
# /usr/share/applications/ and /usr/local/share/applications/ rather than
# storing the .desktop files in the git repo.
remote_directory "/etc/skel/.config/" do
  source ".config"
end
remote_directory "/home/vagrant/.config/" do
  source ".config"
  owner "vagrant"
  group "vagrant"
  mode "700"
  files_owner "vagrant"
  files_group "vagrant"
  files_mode "600"
end
# Workaround the same bug as before.
# A different set of directories need their permissions fixed.
# If not corrected, XFCE fails to start.
execute "find /home/vagrant/.config -type d -print0 | xargs -0 sudo chown vagrant:vagrant"
execute "find /home/vagrant/.config -type d -print0 | xargs -0 sudo chmod 700"

# Set Thunar as the default XFCE file manager
cookbook_file "/etc/skel/.config/xfce4/helpers.rc" do
  source ".config/xfce4/helpers.rc"
end
cookbook_file "/home/vagrant/.config/xfce4/helpers.rc" do
  source ".config/xfce4/helpers.rc"
  owner "vagrant"
  group "vagrant"
  mode "700"
end

# Disable mouse wheel scrolling workspaces. The reason for this is that it is
# very easy to switch workspaces by accident. I am confident that this is very
# non-intuitive. Especially when you have a window minimized.
cookbook_file "/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" do
  source "etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
  action :create
end

# Enable auto-login
# These lines assume that the last section in lightdm.conf is [SeatDefaults].
# That is the only section in Ubuntu 12.04's lightdm.conf.
execute "echo autologin-user=vagrant   >> /etc/lightdm/lightdm.conf"
execute "echo autologin-user-timeout=0 >> /etc/lightdm/lightdm.conf"

service "lightdm" do
  action :start
end
