#
# Cookbook:: main
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.

#
# Cookbook:: main
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.
apt_package "python3" do
        action :install
end

apt_package "python3-pip" do
        action :install
end

apt_package "python3-requests" do
        action :install
end

apt_package "python3-flask" do
        action :install
end

#git '/home/ubuntu/app' do
#        repository 'https://github.com/tmoshe/CloudSchool.git'
#        revision 'main'
#        action :sync
#end

directory '/home/ubuntu/app' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

execute "run-flask-apk"  do
       command 'nohup python3 app.py > /dev/null 2>&1 &'
       cwd '/home/ubuntu/app/'
       user 'root'
       action :run

end

remote_file_s3 '/home/ubuntu/app/my-app-21.tar' do
  bucket 'cloudschoolartifacts'
  remote_path 'my-app-21.tar'
  aws_access_key_id 'AKIASF5WYYCAZFLVH755'
  aws_secret_access_key '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'
  region 'eu-west-1'
  action :create
end

execute 'extract_artifact' do
  command 'tar -xf /home/ubuntu/app/my-app-19.tar -C /home/ubuntu/app'
  action :run
end

cron 'runinng_main' do
  minute '*/1'
  user 'root'
  command 'bash /home/ubuntu/script.sh'
  action :create
end
