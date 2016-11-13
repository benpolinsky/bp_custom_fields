require 'rails_helper'

RSpec.describe "Displaying Custom Fields" do
  
  before do
    @post = Post.create(title: "A Post", slug: "Post-slug", content: "Slow lorem")
    @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
  end
  
  context "basic fields" do    
    it "displays a string field" do
      string_field_template = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 'string', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
     
      string_field = @post.find_field('Name')
      string_field.update(value: "Hello Everybody")
     
      visit main_app.home_path
      expect(page).to have_content "Hello Everybody"
    end
    
    it "displays a text field" do
      text_field_template = BpCustomFields::FieldTemplate.create(name: "Biography", label: "Biography", field_type: 'text', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)

      bp_text_field = @post.find_field('Biography')
      bp_text_field.update(value: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
      Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
      voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
      
      visit main_app.home_path
      expect(page).to have_content "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
      Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
      voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    end
    
    it "displays a number field" do
      number_field_template = BpCustomFields::FieldTemplate.create(name: "Number", label: "Number", field_type: 'number', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)

      number_field = @post.find_field("Number")
      number_field.update(value: 10946293248243)

      visit main_app.home_path
      expect(page).to have_content "10946293248243"
    end
    
    it "displays an email field" do
      email_field_template = BpCustomFields::FieldTemplate.create(name: "Email", label: "Email", field_type: 'email', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
      
      email_field = @post.find_field("Email")
      email_field.update(value: "ben@ben.com")
      
      visit main_app.home_path
      expect(page).to have_content "ben@ben.com"
    end
    
    it "displays a date field" do
      date_field_template = BpCustomFields::FieldTemplate.create(name: "Date", label: "date", field_type: 'date', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
      
      date_field = @post.find_field("Date")
      date_field.update(value: "1-21-1")
      
      visit main_app.home_path
      expect(page).to have_content "1-21-1"
    end
  end
  
  context "fileable fields" do
    
    it "displays an image field" do
      image_field = BpCustomFields::FieldTemplate.create(name: "Selfie", label: "selfie", field_type: 'image', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)

      image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg") 
      image = Rack::Test::UploadedFile.new(image_path, 'image/jpeg')

      image_field = @post.find_field("Selfie")
      image_field.update(file: image)
      
      visit main_app.home_path
      
      expect(page.find('.bpcf-image-selfie')['src']).to eq '/uploads/bp_custom_fields/field/file/1/image.jpg'
      expect(page.find('.bpcf-image-selfie')['alt']).to eq 'selfie'
    end
    
    it "displays a file's src" do
      file_field = BpCustomFields::FieldTemplate.create(name: "Resume", label: "resume", field_type: 'file', group_template: @group_template)
      BpCustomFields::FieldManager.update_groups_for_fieldable(@post)

      file_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "resume.rtf") 
      file = Rack::Test::UploadedFile.new(file_path, 'application/rtf')

      file_field = @post.find_field("Resume")
      file_field.update(file: file)
      
      visit main_app.home_path
      expect(page).to have_content '/uploads/bp_custom_fields/field/file/1/resume.rtf'
    end
  end
  
  context "flex content fields" do
    it "displays only the selected flexible content" do
      # flex_content_field = 
    end
  end
  
  context "gallery fields" do
  end
  
  context "repeatable fields" do
  end
end