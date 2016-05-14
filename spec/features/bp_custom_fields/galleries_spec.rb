require 'rails_helper'

RSpec.describe 'Galleries', type: :feature do
  before do
    class ::Post < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end
    @group_template = BpCustomFields::GroupTemplate.create(name: "Vacation Photos", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
    @gallery_field_template = BpCustomFields::FieldTemplate.create(name: "At the Beach", label: "Beach", field_type: 'gallery', group_template: @group_template)
    @image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg")
    @second_image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image_2.jpg")  
    @image = Rack::Test::UploadedFile.new(@image_path, 'image/jpeg')
    
    visit new_post_path
  end
  
  it "can have multiple images added to it", js: true do
    expect(page).to_not have_content "Upload Image"
    within('.gallery') do
      click_link "Add Image"
    end
    expect(page).to have_content "Upload Image"
    within('.gallery') do
      page.attach_file('Upload Image', @image_path)
    end
    find('form input[type="submit"]').click
    click_link "Edit"
    within('.gallery') do
      expect(page).to have_content "image.jpg"
    end
    
    gallery_images = all('.gallery-image')
    expect(gallery_images.size).to eq 1
        
    last_add_image = all('a', text: "Add Image").last
    last_upload_field = all('input[type="file"]').last
    
    within('.gallery') do
      last_add_image.click
      page.attach_file(last_upload_field[:name], @second_image_path)
    end
    
    find('form input[type="submit"]').click
    click_link "Edit"
    gallery_images = all('.gallery-image')
    expect(gallery_images.size).to eq 2
  end

  

end