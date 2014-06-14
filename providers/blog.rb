# provider/blog.rb

action :install do
  converge_by("Install #{ new_resource }") do
    install_application
  end
end

def install_application
  create_directories
  create_user
  build_ghost
  configure_ghost
  configure_nginx
end

def blog_name
  new_resource.blog_name
end

def url
  new_resource.url
end

def root_dir
  File.join new_resource.www_dir, blog_name
end

def ghost_string
  "ghost-#{new_resource.version}"
end

def create_directories
  directory root_dir do
    recursive true
  end

  directory "#{root_dir}/sockets"
  execute 'Give nginx access to sockets' do
    command "setfacl -m nginx:rwX #{root_dir}/sockets"
  end
end

def create_user
  user blog_name
end

def build_ghost
  remote_file "/tmp/#{ghost_string}" do
    source "https://ghost.org/zip/#{ghost_string}"
  end

  execute "Explode #{ghost_string} into #{root_dir}" do
    command "unzip /tmp/#{ghost_string}.zip -d #{root_dir}"
    user blog_name
  end
end

def configure_ghost
  template "#{root_dir}/config.js" do
    source "config.js.erb"
    variables (url:  url)
  end

  execute 'NPM install' do
    command 'npm install --production'
    user blog_name
    cwd root_dir
  end
end

def configure_supervisor
  supervisor_service "ghost-#{blog_name}" do
    command "node #{root_dir}/index.js"
    action :enable
    autostart true
    autorestart true
    environment {'NODE_ENV' => 'production'}
    directory root_dir
    user blog_name
  end
end

def configure_nginx
  directory '/ssl' do
    owner nginx
    mode '00700'
  end

  cookbook_file 'ssl.key' do
    path "/ssl/#{url}/ssl.key"
    owner nginx
    mode '00600'
  end

  cookbook_file 'ssl.crt' do
    path "/ssl/#{url}/ssl.crt"
    owner nginx
    mode '00600'
  end

  template "/etc/nginx/conf.d/#{blog_name}" do
    source "nginx-blog.erb"
    variables (url:  url, root_dir: root_dir)
  end
end
