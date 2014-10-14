#
# Cookbook Name:: duckduckhack-vm
# Recipe:: InitialDiskCleanup

#

# Reduces disk usage (from the VM's perspective) by 176 MB
execute 'bash -l -i -c "perlbrew clean"' do
  environment ({ "HOME" => "/home/vagrant" })
  user "vagrant"
end

# 6.8 MB when installed. This merely got pulled in because of a "recommends"
package "geoip-database" do
  action :purge
end

# combined 1.2 MB when installed. Obviously not needed on the DuckDuckHack VM
package "landscape-client" do
  action :purge
end
package "landscape-common" do
  action :purge
end

# 2.9 MB when installed. Not needed on the DuckDuckHack VM
package "juju" do
  action :purge
end

# 0.7 MB when installed. Not needed on the DuckDucKHack VM.
package "nfs-common" do
  action :purge
end
# 0.1 MB when installed. Not needed on the DuckDucKHack VM.
package "libnfsidmap2" do
  action :purge
end

# 1.0 MB when installed. Not needed on the DuckDucKHack VM.
package "apport" do
  action :purge
end
# 0.5 MB when installed. Not needed on the DuckDucKHack VM.
package "python-apport" do
  action :purge
end
# 0.1 MB when installed. Not needed on the DuckDucKHack VM.
package "apport-symptoms" do
  action :purge
end

# 5.3 MB when installed (including dependencies.) Chef, Inc. send their regards
package "puppet" do
  action :purge
end

# Remove 11.5 MB (installed size) worth of landscape and juju dependencies
execute 'sudo apt-get -y autoremove'

# 5.7 MB when installed. Pulled in for juju/landscape, but kept because of a
# recommends rule
package "python-twisted-core" do
  action :purge
end
