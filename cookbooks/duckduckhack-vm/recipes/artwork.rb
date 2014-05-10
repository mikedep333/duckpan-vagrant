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

cookbook_file "dont-track-us.png" do
  path : "/opt/duckduckhack-vm/dont-track-us.png"
  action :create
end

cookbook_file "dax.png" do
  path : "/opt/duckduckhack-vm/dax.png"
  action :create
end

cookbook_file "bg.jpg" do
  path : "/opt/duckduckhack-vm/bg.jpg"
  action :create
end
