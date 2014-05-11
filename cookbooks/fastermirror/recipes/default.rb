#
# Cookbook Name:: fastermirror
# Recipe:: default
#

execute "replace" do
  command	"sudo sed -i 's/us.archive.ubuntu.com\|security.ubuntu.com/mirror.symnds.com/' /etc/apt/sources.list"
  action :run
end
