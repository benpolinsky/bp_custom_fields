require 'rails_helper'

RSpec.describe 'Repeaters', type: :feature do
  before do
    class ::Post < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end
    
    @group_template = BpCustomFields::GroupTemplate.create(
      name: "Buckets", 
      appearances: [BpCustomFields::Appearance.new(resource: "Post")]
    )
    
    @repeater_field_template = BpCustomFields::FieldTemplate.create(name: "Image repeater", label: "Beach", field_type: 'repeater', group_template: @group_template)

    @name_field = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0)
    @bio_text_area = BpCustomFields::FieldTemplate.create(name: "Biography", label: "Biography", field_type: 1)
    @email_field = BpCustomFields::FieldTemplate.create(name: "Email", label: "Email", field_type: 3)
    @repeater_field_template.children << [@name_field, @bio_text_area, @email_field]
    @repeater_field_template.save
    
  end
  
  it "can have multiple fields added to it", js: true do
    visit new_post_path
  
    expect(all('.custom-field.biography textarea').size).to eq 1
    expect(all('.custom-field.name input').size).to eq 1
    expect(all('.custom-field.email input').size).to eq 1
    
    fill_in find('.custom-field.email input')[:name], with: "hello@everybody.com"
    fill_in find('.custom-field.name input')[:name], with: "hello"
    fill_in find('.custom-field.biography textarea')[:name], with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    click_link "Add Row"
    
    expect(all('.custom-field.biography textarea').size).to eq 2
    expect(all('.custom-field.name input').size).to eq 2
    expect(all('.custom-field.email input').size).to eq 2
    
    fill_in all('.custom-field.email input').last()[:name], with: "goodbye@noone.com"
    fill_in all('.custom-field.name input').last()[:name], with: "goodbye"
    fill_in all('.custom-field.biography textarea').last()[:name], with: "Squish ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    click_button "Create Post"
    click_link "Edit"

    expect(page).to have_field(all('.custom-field.email input').first()[:name], with: "hello@everybody.com")
    expect(page).to have_field(all('.custom-field.name input').first()[:name], with: "hello")
    expect(page).to have_field(all('.custom-field.biography textarea').first()[:name], with: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    
    expect(page).to have_field(all('.custom-field.email input').last()[:name], with: "goodbye@noone.com")
    expect(page).to have_field(all('.custom-field.name input').last()[:name], with: "goodbye")
    expect(page).to have_field(all('.custom-field.biography textarea').last()[:name], with: "Squish ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
   
  end

  

end