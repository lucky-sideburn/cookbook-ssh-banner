actions :create, :delete

default_action :create

attribute :sshd_config_file, :kind_of => String
attribute :banner_file, :kind_of => String
attribute :paranoic_mode
