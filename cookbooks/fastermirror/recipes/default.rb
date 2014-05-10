#
# Cookbook Name:: fastermirror
# Recipe:: default
#

execute "replace" do
  command	"sudo sed -i 's/us.archive.ubuntu.com\|security.ubuntu.com/mirrors.mit.edu/' /etc/apt/sources.list"
end
