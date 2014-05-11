#
# Cookbook Name:: duckduckhack-vm
# Recipe:: setpassword
#

execute "set vagrant password" do
  command "echo 'vagrant:duckduckhack' | sudo chpasswd"
  action :run
end
