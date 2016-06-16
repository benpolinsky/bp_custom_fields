require 'rails_helper'

RSpec.describe "Creating repeater field-templates", js: true do
  before do
    visit bp_custom_fields.group_templates_path
    click_link "New Group"
  end
    
  
  it "contains subfields" do
    within('form.new_group_template') do
      fill_in 'group_template_name', with: "Main Content"
      select 'Post', from: 'group_template_appearances_attributes_0_resource'
      select 'Repeater', from: "group_template_field_templates_attributes_0_field_type"
      fill_in (all('.field_template-name').first)[:name], with: 'Repeater'
      expect{click_link("Add Subfield")}.to change{all('.nested-fields', visible: true).size}.by(1)
      last_select = all('.field-template-select-field-type').last
      select 'String', from: last_select[:name]
      fill_in (all('.field_template-name').last)[:name], with: 'Repeating String'
      find('input[type="submit"]').click
    end
    last_field = all('.field_template-name').last
    expect(page).to have_field(last_field[:name], with: "Repeating String") 
  end
  
  
  context "nested" do
    it "2 levels" do
      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        select 'Post', from: 'group_template_appearances_attributes_0_resource'
        select 'Repeater', from: "group_template_field_templates_attributes_0_field_type"
        fill_in (all('.field_template-name').first)[:name], with: '1st Level Repeater'
        click_link("Add Subfield")
        last_select = all('.field-template-select-field-type').last
        select 'Repeater', from: last_select[:name]
        fill_in (all('.field_template-name').last)[:name], with: '2nd Level Repeater'
        find('input[type="submit"]').click
      end
      # save_and_open_page
      first_field = all('.field_template-name').first
      last_field = all('.field_template-name').last
      expect(page).to have_field(first_field[:name], with: '1st Level Repeater')
      expect(page).to have_field(last_field[:name], with: '2nd Level Repeater')
    end
    
    it "3 levels" do
      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        select 'Post', from: 'group_template_appearances_attributes_0_resource'
        select 'Repeater', from: "group_template_field_templates_attributes_0_field_type"
        fill_in (all('.field_template-name').first)[:name], with: '1st Level Repeater'
        
        click_link("Add Subfield")
        last_select = all('.field-template-select-field-type').last
        select 'Repeater', from: last_select[:name]
        fill_in (all('.field_template-name').last)[:name], with: '2nd Level Repeater'
        sub_link = all('a', text: "ADD SUBFIELD")[-2]
        sub_link.click
        last_select = all('.field-template-select-field-type').last
        select 'Repeater', from: last_select[:name]
        fill_in (all('.field_template-name').last)[:name], with: '3rd Level Repeater'
        find('input[type="submit"]').click
      end
      first_field = all('.field_template-name')[0]
      middle_field = all('.field_template-name')[1]
      last_field = all('.field_template-name').last
      expect(page).to have_field(first_field[:name], with: '1st Level Repeater')
      expect(page).to have_field(middle_field[:name], with: '2nd Level Repeater')
      expect(page).to have_field(last_field[:name], with: '3rd Level Repeater')
    end
  end
  
  
end