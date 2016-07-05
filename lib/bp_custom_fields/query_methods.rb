module BpCustomFields
  def self.all
    BpCustomFields::Field.all
  end
  
  def self.find_field(field_template_name, appears_on)
    appears_on.find_field(field_template_name)
  end
  
  def self.find_group(group_template_name, appears_on)
    appears_on.find_group(group_template_name)
  end
  
end