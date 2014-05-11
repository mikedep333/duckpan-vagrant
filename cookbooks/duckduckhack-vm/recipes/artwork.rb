#
# Cookbook Name:: duckduckhack-vm
# Recipe:: artwork
#

directory "/opt/duckduckhack-vm" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

cookbook_file "/opt/duckduckhack-vm/dont-track-us.png" do
  source "dont-track-us.png"
  action :create
end

cookbook_file "/opt/duckduckhack-vm/dax.png" do
  source "dax.png"
  action :create
end

cookbook_file "/opt/duckduckhack-vm/bg.jpg" do
  source "bg.jpg"
  action :create
end

# Originally I intended to make calls to xfconf-query instead of manaully saving
# config files. However, xfconf-query refuses to launch without an X session.
#
# Set start menu appearance
# Set background image
# center the background image
# Put grey around the (transparent) background image
# customize icons
#
# These dirs will already exist once the packages are installed.
cookbook_file "/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" do
  source "etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
  action :create
end
cookbook_file "/etc/xdg/xfce4/panel/default.xml" do
  source "etc/xdg/xfce4/panel/default.xml"
  action :create
end

# customize login screen (lightdm-gtk-greeter)
execute "lightdm-gtk-greeter background color" do
  command "sudo sed -i 's/background=.*/background=#ADB5BE/' /etc/lightdm/lightdm-gtk-greeter.conf"
  action :run
end
execute "disable guest" do
  command "sudo /usr/lib/lightdm/lightdm-set-defaults --allow-guest false"
  action :run
end
