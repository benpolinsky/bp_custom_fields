require 'rails_helper'

describe 'creating a group_template', type: :feature do
  context "successfully" do
    before do
      @first_post = Post.create
      visit bp_custom_fields.group_templates_path
      expect(page).to have_content "Custom Field Groups"
      click_link "New Group"
      expect(page).to have_content "Create a New Custom Field Group"
    end
    
    it "without fields" do
      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        expect(page).to have_content "Choose a Resource/Model"
        select 'Post', from: 'group_template_appearances_attributes_0_resource'
        click_button "Create Group"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_appearances_attributes_0_resource", with: "Post")
      end
    end
  
    it "with multiple Appearances but without fields", js: true do 
      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        expect(page).to have_content "Choose a Resource/Model"
        
        select 'Post', from: 'group_template_appearances_attributes_0_resource'
        click_link "Add Appearance"
        expect(page).to have_content "Choose a Resource/Model"
        last_select = all('.appearance-fields .resource-select select').last
        select "Post", from: last_select[:name]
        last_text_input = all('.appearance-fields input[type="text"]').last
        fill_in last_text_input[:name], with: @first_post.id
        click_button "Create Group"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_appearances_attributes_0_resource", with: "Post")
        expect(page).to have_field("group_template_appearances_attributes_1_resource", with: "Post")
        expect(page).to have_field("group_template_appearances_attributes_1_resource_id", with: "1")
      end
    end

    it "with Appearances and custom fields", js: true do
      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        expect(page).to have_content "Choose a Resource/Model"
        

        select 'Post', from: 'group_template_appearances_attributes_0_resource'
        click_link "Add Appearance"
        expect(page).to have_content "Choose a Resource/Model"
        last_select = all('.appearance-fields .resource-select select').last
        select "Post", from: last_select[:name]
        last_text_input = all('.appearance-fields input[type="text"]').last
        fill_in last_text_input[:name], with: @first_post.id
        
        select 'String', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Title"
        fill_in "group_template_field_templates_attributes_0_label", with: "Title"
        
        click_link "Add Field"
        
        expect(page).to have_content "Field Type: "
        last_field_type_select = all('.field-template-select-field-type').last
        last_text_input = all('.field_template-fields .field_template-name').last  
        select "Text", from: last_field_type_select[:name]
        fill_in last_text_input[:name], with: "Your Bio"
        
        click_button "Create Group"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_appearances_attributes_0_resource", with: "Post")
        expect(page).to have_field("group_template_appearances_attributes_1_resource", with: "Post")
        expect(page).to have_field("group_template_appearances_attributes_1_resource_id", with: "1")

        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "string")        
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Title")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Title")
        expect(page).to have_field("group_template_field_templates_attributes_1_field_type", with: "text")
        expect(page).to have_field("group_template_field_templates_attributes_1_name", with: "Your Bio")
      end
    end
    
    it "with non-visible checked" do
      
    end
    
 
  end
  
#  it "can clone a group_template from an exisiting one"
  context "unsuccessfully" do
  end
  

end
