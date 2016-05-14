require 'rails_helper'

RSpec.describe "Creating repeater field-templates" do
  before do
    visit bp_custom_fields.group_templates_path
    click_link "New Group"
    within('form.new_group_template') do
      fill_in 'group_template_name', with: "Main Content"
      select 'Post', from: 'group_template_appearances_attributes_0_resource'
      
      select 'Repeater', from: "group_template_field_templates_attributes_0_field_type"
      
      click_link "Add Subfield"
      
      
      
      # click_button "Submit"
    end
    
  end
  
  it "contains subfields" do
    
  end
  
  
end