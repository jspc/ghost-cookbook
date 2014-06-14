# resources/blog.rb

actions :install
default_action :install

attribute :blog_name, kind_of: String, name_attribute: true

attribute :www_dir, kind_of: String,  default: '/www/sites'
attribute :version, kind_of: String, default: 'latest'
attribute :url, kind_of: String, required: true
