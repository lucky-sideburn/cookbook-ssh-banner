def whyrun_supported?
	  true
end



def check_banner_file banner_file
          Chef::Log.debug("Checking for SSH  banner file..")
  if not  ::File.exists?(banner_file)
	  Chef::Application.fatal!("SSH banner file is not present.")
          new_resource.updated_by_last_action(false)
  else
	  Chef::Log.debug("#{banner_file} present..")
  end	  
end


def paranoic_mode

    if new_resource.paranoic_mode
	 Chef::Log.info("SSH-BANNER IS IN PARANOIC MODE: it will perform a rollback of ssh configuration in #{node['ssh_banner']['paranoic_mode_time']} seconds" )
	 execute "/bin/cp -f  #{new_resource.sshd_config_file} #{new_resource.sshd_config_file}_bck"
	 execute " sleep #{node['ssh_banner']['paranoic_mode_time']} && /bin/cp -f  #{new_resource.sshd_config_file}_bck #{new_resource.sshd_config_file} && /sbin/service #{node['ssh_banner']['sshd']['service']}  restart &> /dev/null &"
    end   

end





action :create do
  check_banner_file  new_resource.banner_file 
 

  banners =  ::File.open(new_resource.sshd_config_file).grep(/^Banner\ .*/).size

  paranoic_mode

   if banners > 1

       Chef::Log.info("Found more then one SSH banner, I am deleting them and create a new one")
        execute "sed -i s/Banner\\\ .*//g #{new_resource.sshd_config_file}"
        execute "echo 'Banner  #{new_resource.banner_file}' >> #{new_resource.sshd_config_file} " 	 
        new_resource.updated_by_last_action(true)
      
  elsif  banners  == 1

 	Chef::Log.info("SSH Banner present..doing nothing..")
        new_resource.updated_by_last_action(false)

  elsif banners  == 0
        Chef::Log.info("SSH Banner not present..I am creating it..")
        execute "echo 'Banner  #{new_resource.banner_file}' >> #{new_resource.sshd_config_file}" 
        new_resource.updated_by_last_action(true)
   end

end 


action :delete do 
 
       	check_banner_file  new_resource.banner_file
        
	paranoic_mode

	if ::File.open(new_resource.sshd_config_file).grep(/Banner\ .*/).size >= 1
	      Chef::Log.info("Deleting SSH Banner..")
              execute " sed -i s/Banner\\\ .*//g  #{new_resource.sshd_config_file}"	      
              new_resource.updated_by_last_action(true)
        else
	      Chef::Log.info("SSH Banner not found ... doing nothing..")
              new_resource.updated_by_last_action(false)

	end

end
