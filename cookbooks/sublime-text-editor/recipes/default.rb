#
# Cookbook Name:: sublime-text-editor-vm
# Recipe:: default
#

URL="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2"
TARBALLPATH="/tmp/sublime-text-editor.tar.bz2"
DESKTOPFILE="Sublime Text.desktop"

#Note: These paths are currently hardcoded in DESKTOPFILE
INSTALLPARENTDIR = "/usr/local/"
TARREDDIR= "Sublime Text 2"

remote_file TARBALLPATH do
  source URL
  owner "root"
  group "root"
  mode "0644"
  action :create
end
execute "extract" do
  command "sudo tar -xf " + TARBALLPATH + " --directory " + INSTALLPARENTDIR
end
file TARBALLPATH do
  action :delete
end

link "/usr/local/bin/sublime_text" do
  to INSTALLPARENTDIR + TARREDDIR + "/sublime_text"
end

#cookbook_file "/home/dax/Desktop/" + DESKTOPFILE do
#  source DESKTOPFILE
#end
directory "/home/vagrant/Desktop/" do
  owner "vagrant"
  group "vagrant"
end
cookbook_file "/home/vagrant/Desktop/" + DESKTOPFILE do
  source DESKTOPFILE
  owner "vagrant"
  group "vagrant"
end
directory "/etc/skel/Desktop/"
cookbook_file "/etc/skel/Desktop/" + DESKTOPFILE do
  source DESKTOPFILE
end
directory "/usr/local/share/applications/"
cookbook_file "/usr/local/share/applications/" + DESKTOPFILE do
  source DESKTOPFILE
end
