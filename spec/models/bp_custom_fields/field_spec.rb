require 'rails_helper'

module BpCustomFields
  RSpec.describe BpCustomFields::Field, type: :model do
    
    it "delegates many methods to its template" do
      @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [Appearance.new(resource: "Post")])
      @name_field = BpCustomFields::FieldTemplate.create(name: "Name", field_type: 'string', group_template: @group_template)
      @name_field.fields.create
      expect(@name_field.fields.first.name).to eq "Name"
      # other attributes/methods
    end
    

    
    context "displaying" do
      before do
        class ::Post < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end
  
        @post = Post.create(title: "A Post", slug: "Post-slug", content: "Slow lorem")
        @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post", resource_id: @post.id)])
      end

      context "basic displays" do
        before do
          @string_field_template = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 'string', group_template: @group_template)
          @text_field_template = BpCustomFields::FieldTemplate.create(name: "Biography", label: "Biography", field_type: 'text', group_template: @group_template)
          @number_field_template = BpCustomFields::FieldTemplate.create(name: "Number", label: "Number", field_type: 'number', group_template: @group_template)
          @email_field_template = BpCustomFields::FieldTemplate.create(name: "Email", label: "Email", field_type: 'email', group_template: @group_template)
          
          BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
          @post.save
          
          @name_field = @post.find_fields('Name').first
          @name_field.update(value: "Benedict Arnold")
          @text_field = @post.find_fields('Biography').first
          @text_field.update(value: "Traitor Ipsum")
          @number_field = @post.find_fields('Number').first
          @number_field.update(value: 1)
          @email_field = @post.find_fields('Email').first
          @email_field.update(value: "benedict@gmail.dev")
        end
        
        it "string" do
          expect(@name_field.display).to eq "Benedict Arnold"
        end

        it "text" do
          expect(@text_field.display).to eq "Traitor Ipsum"
        end
  
        it "number" do
          expect(@number_field.display).to eq 1
          @number_field.update(value: 12312.3123)
          expect(@number_field.display).to eq 12312.3123
        end
  
        it "email" do
          expect(@email_field.display).to eq "benedict@gmail.dev" # any reason at all for this field?
        end
  

      end

      context "complex displays" do
        before do
          @image_field_template = BpCustomFields::FieldTemplate.create(name: "Image", label: "Image", field_type: 'image', group_template: @group_template)
          @file_field_template = BpCustomFields::FieldTemplate.create(name: "File", label: "File", field_type: 'file', group_template: @group_template)
          @video_field_template = BpCustomFields::FieldTemplate.create(name: "Video", label: "Video", field_type: 'video', group_template: @group_template)
          @audio_field_template = BpCustomFields::FieldTemplate.create(name: "Audio", label: "Audio", field_type: 'audio', group_template: @group_template)
          
          
          BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
          @post.save
        end


        context "fileables" do
          before do
            @image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg") 
            @image = Rack::Test::UploadedFile.new(@image_path, 'image/jpeg')
            @image_field = @post.find_fields('Image').first
            @image_field.update(file: @image)
          end
          
          it "has a fileable? method" do
            expect(@image_field.fileable?).to eq true
            @string_field_template = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0, group_template: @group_template)
            @name_field = @string_field_template.fields.new
            expect(@name_field.fileable?).to eq false
            @file_field = @file_field_template.fields.new
            expect(@file_field.fileable?).to eq true
            @video_field = @video_field_template.fields.new
            expect(@video_field.fileable?).to eq true
            @audio_field = @audio_field_template.fields.new
            expect(@audio_field.fileable?).to eq true
          end
          
          it "can display the src" do
            expect(@image_field.display).to eq "/uploads/bp_custom_fields/field/file/#{@image_field.id}/image.jpg"
          end
          
          it "can display an absolute src" do
            expect(@image_field.absolute_url).to eq "http://localhost:3000/uploads/bp_custom_fields/field/file/#{@image_field.id}/image.jpg"
          end
        end


        context "dateable" do
          before do
            @date_field_template = BpCustomFields::FieldTemplate.create(name: "Date", label: "Date", field_type: 6, group_template: @group_template)
            @date_field = @date_field_template.fields.create(value: "1-21-21")
            @post.save
          end
          pending "date"
          # it "date_and_time"
          # it "time"
        end
        
        context "chooseables fields" do
          it "stores and displays choiceable fields with a single value as a normal string" do
            @dropdown_field_template = BpCustomFields::FieldTemplate.create(name: "Favorite Color", label: "favorite-color", choices: "red, blue, yellow", field_type: 'dropdown')
            dropdown_field = @dropdown_field_template.fields.create(value: "red")
            expect(dropdown_field.display).to eq "red"
          end
          
      
          it "stores choiceable fields with multiple values as an array and returns as array or string" do
            @dropdown_field_template = BpCustomFields::FieldTemplate.create(name: "Favorite Color", label: "favorite-color", choices: "red, blue, yellow", field_type: 'dropdown', multiple: true)
            dropdown_field = @dropdown_field_template.fields.create(value: ['red', 'yellow'])
            expect(dropdown_field.to_a).to eq ['red', 'yellow']
            expect(dropdown_field.display).to eq "red,yellow"
          end
      
          it "displays truefalse fields as 1/false 0/true" do
            @truefalse_field_template = BpCustomFields::FieldTemplate.create(
              name: "Favorite Color", 
              label: "favorite-color",
              field_type: 14
            )
            true_field = @truefalse_field_template.fields.create(value: '0')
            expect(true_field.display).to eq 'true'
            
            false_field = @truefalse_field_template.fields.create(value: '1')
            expect(false_field.display).to eq 'false'
          end
        end
        
        pending "editor"
      end
      
      context "hierarchical displays", focus: true do
        context "galleries" do
          before do
            @image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image.jpg")
            @second_image_path = BpCustomFields::Engine.root.join('spec', 'support', 'files', "image_2.jpg")  
            @image = Rack::Test::UploadedFile.new(@image_path, 'image/jpeg')
            @second_image = Rack::Test::UploadedFile.new(@second_image_path, 'image/jpeg')
            
            @gallery_field_template = BpCustomFields::FieldTemplate.create(
              name: "My First Gallery", 
              label: "my-first-gallery", 
              field_type: "gallery", 
              group_template: @group_template
              )

          end
          
          it 'has many children fields' do
            gallery_field = @gallery_field_template.fields.create
            image_template = @gallery_field_template.children.create(field_type: 'image', name: "gallery image")
            expect(gallery_field.field_type).to eq 'gallery'
            gallery_field.children.create(field_template: image_template)
            gallery_field.children.create(field_template: image_template)
            expect(gallery_field.children.size).to eq 2
          end
          
          it "can display an array of its children's urls" do
            gallery_field = @gallery_field_template.fields.create
            image_template = @gallery_field_template.children.create(field_type: 'image', name: "gallery image")
            expect(gallery_field.field_type).to eq 'gallery'
            field_1 = gallery_field.children.create(field_template: image_template, file: @image)
            field_2 = gallery_field.children.create(field_template: image_template, file: @second_image)
            expect(gallery_field.to_a).to eq ["http://localhost:3000/uploads/bp_custom_fields/field/file/#{field_1.id}/image.jpg", "http://localhost:3000/uploads/bp_custom_fields/field/file/#{field_2.id}/image_2.jpg"]
          end
        end
      end
      
    end
  end
end