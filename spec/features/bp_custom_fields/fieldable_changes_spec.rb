require 'rails_helper'

RSpec.describe 'Fieldable Changes:', type: :feature do
  
  before do
    class ::Post < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end
    @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
    @name_field = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0, group_template: @group_template)
    
    @post = Post.new(title: "A Post", slug: "Post-slug", content: "Slow lorem")
    BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
    @post.save

    visit edit_post_path(@post)
    

    @custom_field_inputs = all('.custom-field input')
    @custom_field_text_areas = all('.custom-field textarea')
    @name_input = find('.custom-field.name input')
  end
  
  context "new groups, fields. and appearance changes", js: true do
    it "adds new fields when they are added to one of its group's template" do
      nav_bar_custom_fields_link = find(".admin-navbar a.custom_fields")
      nav_bar_posts_link = find('.admin-navbar a.posts')

      expect(all('.custom-field').size).to eq 1
      expect(all('.custom-field input').size).to eq 1
      nav_bar_custom_fields_link.click
      click_link "Edit"

      within('form.edit_group_template') do
        
        click_link "Add Field"
        expect(page).to have_content "Field Type: "
        last_field_type_select = all('.field-template-select-field-type').last
        last_text_input = all('.field_template-name').last  
        select "Text", from: last_field_type_select[:name]
        fill_in last_text_input[:name], with: "about"
        click_button "Submit"
      end
      nav_bar_posts_link.click
      click_link "Edit"
      
      expect(all('.custom-group').size).to eq 1
      expect(all('.custom-field').size).to eq 2
      expect(all('.custom-field input').size).to eq 1
      expect(all('.custom-field textarea').size).to eq 1
    end

    it "adds new groups when they are created matching the fieldable's conditions" do
      nav_bar_custom_fields_link = find(".admin-navbar a.custom_fields")
      nav_bar_posts_link = find('.admin-navbar a.posts')

      expect(@custom_field_inputs.size).to eq 1
      nav_bar_custom_fields_link.click
      click_link "New Group"

      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        expect(page).to have_content "Choose a Resource/Model"
        
        select 'Post', from: 'group_template_appearances_attributes_0_resource'
        
        select 'String', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "new_field"
        fill_in "group_template_field_templates_attributes_0_label", with: "new_field"
        
        click_button "Submit"
      end
      nav_bar_posts_link.click
      click_link "Edit"
      
      expect(all('.custom-group').size).to eq 2
      expect(all('.custom-field').size).to eq 2
      expect(all('.custom-field.name input').size).to eq 1
      expect(all('.custom-field.new_field input').size).to eq 1
    end
    
    it "adds new groups when those groups' appearance conditions match" do
      class ::Widget < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end
      
      nav_bar_custom_fields_link = find(".admin-navbar a.custom_fields")
      nav_bar_posts_link = find('.admin-navbar a.posts')

      expect(@custom_field_inputs.size).to eq 1
      nav_bar_custom_fields_link.click
      click_link "New Group"

      within('form.new_group_template') do
        fill_in 'group_template_name', with: "Main Content"
        expect(page).to have_content "Choose a Resource/Model"
        
        select 'Widget', from: 'group_template_appearances_attributes_0_resource'
        
        select 'String', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "new_field"
        fill_in "group_template_field_templates_attributes_0_label", with: "new_field"
        
        click_button "Submit"
      end
      nav_bar_posts_link.click
      click_link "Edit"
      
      expect(all('.custom-group').size).to eq 1
      expect(all('.custom-field').size).to eq 1
      expect(all('.custom-field.name input').size).to eq 1
      
      nav_bar_custom_fields_link.click
      
      all("a", text: "Edit").last.click

      within('form.edit_group_template') do
        field = find('select#group_template_appearances_attributes_0_resource')
        expect(field.value).to eq "Widget"
        select "Post", from: field[:name]
        click_button "Submit"
      end
      
      nav_bar_posts_link.click
      click_link "Edit"
      expect(all('.custom-group').size).to eq 2
      expect(all('.custom-field').size).to eq 2
      expect(all('.custom-field.name input').size).to eq 1
      expect(all('.custom-field.new_field input').size).to eq 1
    end
    
    it "removes fields when removed from its group's template", focus: true do
      
      nav_bar_custom_fields_link = find(".admin-navbar a.custom_fields")
      nav_bar_posts_link = find('.admin-navbar a.posts')

      expect(@custom_field_inputs.size).to eq 1
      nav_bar_custom_fields_link.click
      
      click_link "Edit"
      click_link "remove field"
      click_button "Submit" 
      nav_bar_posts_link.click
      click_link "Edit"
      expect(all('.custom-field input').size).to eq 0
    end
    
    it "removes groups when those groups' tempalates are deleted" do
      nav_bar_custom_fields_link = find(".admin-navbar a.custom_fields")
      nav_bar_posts_link = find('.admin-navbar a.posts')

      expect(@custom_field_inputs.size).to eq 1
      nav_bar_custom_fields_link.click
      
      click_link "Destroy"
      page.driver.browser.switch_to.alert.accept
      
      nav_bar_posts_link.click
      
      click_link "Edit"
      expect(all('.custom-group').size).to eq 0
      expect(all('.custom-field input').size).to eq 0
    end
    
    it "removes groups when those groups appearances change and no longer match" do
      
      class ::Widget < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end
      
      nav_bar_custom_fields_link = find(".admin-navbar a.custom_fields")
      nav_bar_posts_link = find('.admin-navbar a.posts')

      expect(@custom_field_inputs.size).to eq 1
      nav_bar_custom_fields_link.click
      
      click_link "Edit"

      within("form.edit_group_template") do
        field = find('select#group_template_appearances_attributes_0_resource')
        expect(field.value).to eq "Post"
        select "Widget", from: field[:name]
        click_button "Submit"
      end
      
      nav_bar_posts_link.click
      
      click_link "Edit"
      expect(all('.custom-group').size).to eq 0
      expect(all('.custom-field input').size).to eq 0
    end
    
  end
end