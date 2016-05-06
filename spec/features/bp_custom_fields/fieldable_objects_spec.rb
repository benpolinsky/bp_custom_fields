require 'rails_helper'

RSpec.describe "Fieldable Objects", type: :feature do
  before do
    class ::Post < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end
    @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
    @name_field = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0, group_template: @group_template)
    @bio_text_area = BpCustomFields::FieldTemplate.create(name: "Biography", label: "Biography", field_type: 1, group_template: @group_template)
    @email_field = BpCustomFields::FieldTemplate.create(name: "Email", label: "Email", field_type: 3, group_template: @group_template)
  end
  
  context "can be created" do
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
    
      expect(page).to have_content "Post was successfully created"
    end
  end
  
  context "can be edited" do
    before do
      @post = Post.new(title: "A Post", slug: "Post-slug", content: "Slow lorem")
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
      @post.save

      visit edit_post_path(@post)
      

      @custom_field_inputs = all('.custom-field input')
      @custom_field_text_areas = all('.custom-field textarea')
      @text_area = find('.custom-field.biography textarea')
      @name_input = find('.custom-field.name input')
      @email_input = find('.custom-field.email input')
    end
    
    it "with proper fields present" do
      expect(@custom_field_inputs.size).to eq 2
      expect(@custom_field_text_areas.size).to eq 1
      
      @post.groups.first.fields.each_with_index do |custom_field, index|
        expect(page).to have_field("post_groups_attributes_0_fields_attributes_#{index}_value")
      end
    end
    
    it "and updated to change field values" do 
      
      old_values = {
        name: @name_input.value, 
        email: @email_input.value, 
        biography: @text_area.value
      }
      
      @text_area.set "Lorem textish lorem"
      @name_input.set "Squish Ntosh Suede"
      @email_input.set "squish@stash.dev"
      
      find('form input[type="submit"]').click

      click_link "Edit"
      
      # refind fields to get new values
      @text_area = find('.custom-field.biography textarea')
      @name_input = find('.custom-field.name input')
      @email_input = find('.custom-field.email input')
      
      expect(@text_area.value).to eq "Lorem textish lorem"
      expect(@name_input.value).to eq "Squish Ntosh Suede"
      expect(@email_input.value).to eq "squish@stash.dev"
    end    
  end
  
end