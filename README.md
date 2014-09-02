
## Attributes

default['ssh_banner']['sshd_config_file']  = "/etc/ssh/sshd_config"
default['ssh_banner']['sshd_init_service'] = "/etc/init.d/sshd"
default['ssh_banner']['sshd']['service'] = "sshd"
default['ssh_banner']['sshd_banner_file'] = "chef_ssh_banner"
default['ssh_banner']['paranoic_mode_time'] = 20
default['ssh_banner']['sshd_banner_dir'] = "/etc/ssh"


## Usage

### Customize your banner
copy and paste the banner here => /files/default/chef_ssh_banner

### ssh-banner::default

#### Add banner in paranoid mode.

using paranoid mode, chef will replace sshd_config with your new banner and will do a 
rollback of configuration after node[‘ssh_banner']['paranoic_mode_time'] seconds.

ssh_banner_banner  "banner" do
  banner_file _banner_file
  sshd_config_file  node['ssh_banner']['sshd_config_file']
  paranoic_mode false
  action :create
  notifies :restart, "service[sshd]"
end


#### Add new banner:

ssh_banner_banner  "banner" do
  banner_file _banner_file
  sshd_config_file  node['ssh_banner']['sshd_config_file']
  paranoic_mode false
  action :create
  notifies :restart, "service[sshd]"
end

#### Delete banner:

ssh_banner_banner  "banner" do
  banner_file _banner_file
  sshd_config_file  node['ssh_banner']['sshd_config_file']
  paranoic_mode false
  action :delete
  notifies :restart, "service[sshd]"
end


## Author

Author:: Eugenio Marzo (eugenio.marzo@yahoo.it)
