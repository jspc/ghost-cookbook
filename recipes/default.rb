case node["platform"]
when "ubuntu", "debian"
  apt_repository "nginx" do
    uri "http://ppa.launchpad.net/nginx/stable/ubuntu"
    distribution node['lsb']['codename']
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "C300EE8C"
  end
when "centos", "rhel"
  yum_repository 'nginx' do
    description 'Official Nginx packages'
    baseurl 'http://nginx.org/packages/centos/$releasever/$basearch/'
    gpgcheck false
  end
else
  raise "No idea how to add nginx repo for #{node['platform']} platform"
end


include_recipe 'nginx'
include_recipe 'nodejs'
