module TaskHelper
  # TODO: Don't let this truncate roles!
  def self.reload_roles
    puts "=== Reloading System Roles"
    roles_file       = Rails.root.join("config", "users", "roles.yml")
    roles = YAML::load(File.open(roles_file))
    TaskHelper::update_roles(roles)
    puts "Done!"
  end
  
  def self.update_roles(hash, parent = nil)
    allowed_keys = ["description", "assignable", "name", "permissions"]
    hash.each do |key,content|
      next unless content.is_a? Hash
      
      asg = content["assignable"].nil? ? true : content["assignable"]
      
      
      if Role.where(:system_name => key).count > 0
        r = Role.where(:system_name => key).first
        puts "Role '#{r.system_name}' already exists; ignoring"
      else
        puts "Role '#{key}' does not exist; creating"
        r = Role.new
        r.description = content["description"]
        r.assignable = asg
        r.name = content["name"] ||= key.titleize
        r.system_name = key
        r.save!
        unless parent.nil?
          r.move_to_child_of parent
        end
      end
      
      content.each do |k,v|
        next if allowed_keys.include? k
        update_roles({k => v}, r)
      end 
    end
  end
  
  
end
