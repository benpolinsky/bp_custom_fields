require 'rails_helper'

describe 'creating custom fields', type: :feature do
  context "successfully", js: true do
    before do
      @first_post = Post.create
      visit bp_custom_fields.group_templates_path
      expect(page).to have_content "Custom Field Groups"
      click_link "New Group"
      expect(page).to have_content "Create a New Custom Field Group"
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
      end
    end
    
    {'string' => 'Hi', 'email' => 'me@me.com', 'number' => 199}.each do |field_name, field_value|
      it "#{field_name}s" do
        within('form.new_group_template') do
          select field_name.capitalize, from: "group_template_field_templates_attributes_0_field_type"
          fill_in "group_template_field_templates_attributes_0_name", with: "#{field_name} name"
          fill_in "group_template_field_templates_attributes_0_label", with: "#{field_name} label"
        
          click_button "Submit"
        end

        within("form.edit_group_template") do
          expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: field_name)        
          expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "#{field_name} name")
          expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "#{field_name} label")
        end
      
        visit edit_post_path(@first_post)
      
        fill_in('post_groups_attributes_0_fields_attributes_0_value', with: field_value)
        click_button "Update Post"
        expect(page).to have_content field_value
      end
    end
    
    it 'text' do
      within('form.new_group_template') do
        select 'Text', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Your Bio"
        fill_in "group_template_field_templates_attributes_0_label", with: "Your Bio"
        
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Your Bio")
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "text")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Your Bio")
      end
      
      visit edit_post_path(@first_post)
      
      fill_in('post_groups_attributes_0_fields_attributes_0_value', with: "Great text for you!")
      click_button "Update Post"
      expect(page).to have_content "Great text for you!"
    end
    
    it 'editor' do
      within('form.new_group_template') do
        select 'Editor', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Your Bio"
        fill_in "group_template_field_templates_attributes_0_label", with: "Your Bio"
        
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Your Bio")
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "editor")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Your Bio")
      end

      visit edit_post_path(@first_post)
      
      find('.form-control.bpcf-editor').set("I am a good lad.")
      click_button "Update Post"
      expect(page).to have_content "I am a good lad."
    end
    
    it "checkboxes" do
      within('form.new_group_template') do
        select 'Checkboxes', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Color"
        fill_in "group_template_field_templates_attributes_0_label", with: "Color"
        fill_in "group_template_field_templates_attributes_0_choices", with: "Red:red, Green:green, Blue:blue"

        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "checkboxes")        
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Color")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Color")
        expect(page).to have_field("group_template_field_templates_attributes_0_choices", with: "Red:red, Green:green, Blue:blue")
      end
      
      visit edit_post_path(@first_post)
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value_red')
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value_blue')
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value_green')

      choose 'post_groups_attributes_0_fields_attributes_0_value_blue'
      click_button 'Update Post'
      expect(page).to have_content 'Blue'
    end
    
    it "truefalse" do
      within('form.new_group_template') do
        select 'Truefalse', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Admin?"
        fill_in "group_template_field_templates_attributes_0_label", with: "Admin? Label"
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "truefalse")        
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Admin?")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Admin? Label")
      end
      
      visit edit_post_path(@first_post)
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value')
      check 'post_groups_attributes_0_fields_attributes_0_value'
      click_button 'Update Post'
      expect(page).to have_content 'true'
    end
    
    it "date_times" do
      within('form.new_group_template') do

        select 'Date And Time', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Event Start"
        fill_in "group_template_field_templates_attributes_0_label", with: "event start"
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "date_and_time")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Event Start")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "event start")
      end
      
      visit edit_post_path(@first_post)
      

      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value')
      expect(page).to have_selector "span.cur_month", text: "February", visible: false
      find('#post_groups_attributes_0_fields_attributes_0_value').click
      expect(page).to have_selector "span.cur_month", text: "February", visible: true
      expect(page).to have_content "February"
      find('.slot.flatpickr-day', text: '16').click

      find('#post_title').click
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value', with: '2017-02-16 12:00 PM')

      click_button 'Update Post'
      expect(page).to have_content '2017-02-16 12:00 PM'
    end
    
    it "dates" do
      within('form.new_group_template') do

        select 'Date', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Event Start"
        fill_in "group_template_field_templates_attributes_0_label", with: "event start"
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "date")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Event Start")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "event start")
      end
      
      visit edit_post_path(@first_post)
      

      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value')
      expect(page).to have_selector "span.cur_month", text: "February", visible: false
      find('#post_groups_attributes_0_fields_attributes_0_value').click
      expect(page).to have_selector "span.cur_month", text: "February", visible: true
      find('.slot.flatpickr-day', text: '16').click

      find('#post_title').click
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value', with: '2017-02-16')

      click_button 'Update Post'
      expect(page).to have_content '2017-02-16'
    end
    
    it 'times' do
      within('form.new_group_template') do

        select 'Time', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Event Start"
        fill_in "group_template_field_templates_attributes_0_label", with: "event start"
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "time")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Event Start")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "event start")
      end
      
      visit edit_post_path(@first_post)
      
      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value')


      find('#post_groups_attributes_0_fields_attributes_0_value').click

      expect(page).to have_selector "input.flatpickr-hour"
      
      find('.flatpickr-hour').click

      find('#post_title').click

      click_button 'Update Post'
      expect(page).to have_content '12:00 PM'
    end
    
    it 'dropdowns' do
      within('form.new_group_template') do
    
        select 'Dropdown', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Favorite Food"
        fill_in "group_template_field_templates_attributes_0_label", with: "favorite food"
        fill_in "group_template_field_templates_attributes_0_choices", with: "Apples, Bananas, Grapes, Pork"
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "dropdown")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Favorite Food")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "favorite food")
      end
      
      visit edit_post_path(@first_post)
      
      within('.custom-field.form-group.dropdown') do
        select "Bananas", from: 'post_groups_attributes_0_fields_attributes_0_value'
      end
      
      find('#post_title').click
      expect(page).to have_selector "select#post_groups_attributes_0_fields_attributes_0_value", text: 'Bananas'
     
      click_button 'Update Post'
      expect(page).to have_content 'Bananas'
    end
    
    it 'file' do
      within('form.new_group_template') do
        select 'File', from: "group_template_field_templates_attributes_0_field_type"
        
        fill_in "group_template_field_templates_attributes_0_name", with: "Seasonal Menu"
        fill_in "group_template_field_templates_attributes_0_label", with: "Seasonal Menu Label"
      
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: 'file')        
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: 'Seasonal Menu')
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Seasonal Menu Label")
      end
    
      visit edit_post_path(@first_post)
      last_upload_field = all('input[type="file"]').last

      @image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg")
      page.attach_file(last_upload_field[:name], @image_path)
      
      click_button "Update Post"
      expect(page).to have_content '/uploads/bp_custom_fields/field/file/1/image.jpg'
    end
    
    it 'image' do
      within('form.new_group_template') do
        select 'Image', from: "group_template_field_templates_attributes_0_field_type"
        
        fill_in "group_template_field_templates_attributes_0_name", with: "My Dog"
        fill_in "group_template_field_templates_attributes_0_label", with: "My Dog Label"
      
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: 'image')        
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: 'My Dog')
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "My Dog Label")
      end
    
      visit edit_post_path(@first_post)
      last_upload_field = all('input[type="file"]').last

      @image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg")
      page.attach_file(last_upload_field[:name], @image_path)
      
      click_button "Update Post"
      expect(page).to have_selector 'img[src="/uploads/bp_custom_fields/field/file/1/image.jpg"]'
    end

    it 'video', focus: true do
      within('form.new_group_template') do

        select 'Video', from: "group_template_field_templates_attributes_0_field_type"
        fill_in "group_template_field_templates_attributes_0_name", with: "Video Bio"
        fill_in "group_template_field_templates_attributes_0_label", with: "Video Bio"
        click_button "Submit"
      end

      within("form.edit_group_template") do
        expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: "video")
        expect(page).to have_field("group_template_field_templates_attributes_0_name", with: "Video Bio")
        expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Video Bio")
      end
      
      visit edit_post_path(@first_post)

      expect(page).to have_field('post_groups_attributes_0_fields_attributes_0_value')
      
      fill_in('post_groups_attributes_0_fields_attributes_0_value', with: "https://www.youtube.com/watch?v=fpLQ0wtQ0R0")
      click_button 'Update Post'
      expect(page).to have_selector "iframe"
    end
    
    
    # it 'gallery', focus: true do
  #     within('form.new_group_template') do
  #       select 'File', from: "group_template_field_templates_attributes_0_field_type"
  #
  #       fill_in "group_template_field_templates_attributes_0_name", with: "Seasonal Menu"
  #       fill_in "group_template_field_templates_attributes_0_label", with: "Seasonal Menu Label"
  #
  #       click_button "Submit"
  #     end
  #
  #     within("form.edit_group_template") do
  #       expect(page).to have_field("group_template_field_templates_attributes_0_field_type", with: 'file')
  #       expect(page).to have_field("group_template_field_templates_attributes_0_name", with: 'Seasonal Menu')
  #       expect(page).to have_field("group_template_field_templates_attributes_0_label", with: "Seasonal Menu Label")
  #     end
  #
  #     visit edit_post_path(@first_post)
  #     last_upload_field = all('input[type="file"]').last
  #     @image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg")
  #     page.attach_file(last_upload_field[:name], @image_path)
  #
  #     click_button "Update Post"
  #     expect(page).to have_content '/uploads/bp_custom_fields/field/file/1/image.jpg'
  #   end
  end

end
