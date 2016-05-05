require 'rails_helper'

RSpec.describe "Creating Fieldable Objects" do
  before do
    class ::Post < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end
    @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
    @name_field = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0, group_template: @group_template)
    @bio_text_area = BpCustomFields::FieldTemplate.create(name: "Biography", label: "Biography", field_type: 1, group_template: @group_template)
    @email_field = BpCustomFields::FieldTemplate.create(name: "Email", label: "Email", field_type: 3, group_template: @group_template)
  end
  
  it "successfully with a custom group and custom fields" do
    visit new_post_path
    expect(page).to have_content "New Post"

    within('form') do
      fill_in "Title", with: "A Post"
      fill_in "Slug", with: "Post-slug"
      fill_in "Content", with: "Slow lorem"
      
      fill_in "Name", with: "A Custom Field Name"
      fill_in "Biography", with: "A Custom Field Text"
      fill_in "Email", with: "me@me.com"
      click_button "Create Post"
    end
    
    expect(page).to have_content "Post Created"
  end
end