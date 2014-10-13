#
# Cookbook Name:: sublime-text-editor-vm
# Recipe:: default
#

# TODO: Write code for other operating systems.
if node['kernel']['os'] != "GNU/Linux"
  return
end

# Sorry ARM, power64, and s390x users, Sublime is not available for you.
if    node['kernel']['machine'] == "x86_64"
  URL="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2"
elsif node['kernel']['machine'] == "i686"
  URL="http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2"
else
  return
end

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
# Register the file associations ("MimeType" from /usr/local/share/applications)
# I haven't determined why, but it has precedence over Emacs.
# We (DuckDuckHack VM) want it to have precedence over Emacs because Sublime is
# easier to learn.
execute "update-desktop-database" do
  user "root"
end
