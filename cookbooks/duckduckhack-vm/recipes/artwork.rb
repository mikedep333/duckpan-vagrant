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

# Set start menu appearance
execute "set start menu icon" do
  command "xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -s /opt/duckduckhack-vm/dax.png"
  action :run
end 

execute "hide start menu title" do
  command "xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-button-title -s false"
  action :run
end 

# Set background image
execute "set background image 1" do
  command "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /opt/duckduckhack-vm/dont-track-us.png"
  action :run
end
execute "set background image 2" do
  command "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/last-image -s /opt/duckduckhack-vm/dont-track-us.png"
  action :run
end
execute "set background image 3" do
  command "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/last-single-image -s /opt/duckduckhack-vm/dont-track-us.png"
  action :run
end

# center the background image
execute "set background style" do
  command "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/style -s 1"
  action :run
end

# Put grey around the (transparent) background image
execute "set background color" do
  command "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/color1 -s 44454 -s 46389 -s 48919 -s 65535"
  action :run
end

# icons
execute "set desktop icons size" do
  command "xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -s 60"
  action :run
end
execute "hide home" do
  command "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -s false"
  action :run
end
execute "hide filesystem" do
  command "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s false"
  action :run
end
execute "hide trash" do
  command "xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s false"
  action :run
end

#customize login screen (lightdm-gtk-greeter)
execute "lightdm-gtk-greeter background color" do
  command "sudo sed -i 's/background=.*/background=ADB5BE/' /etc/lightdm/lightdm-gtk-greeter.conf"
  action :run
end
execute "disable guest" do
  command "sudo /usr/lib/lightdm/lightdm-set-defaults --allow-guest false"
  action :run
end
