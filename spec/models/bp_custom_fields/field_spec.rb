require 'rails_helper'

module BpCustomFields
  RSpec.describe BpCustomFields::Field, type: :model do
    it "exists" do
      expect(BpCustomFields::Field.new).to be_a BpCustomFields::Field
    end
    
    it "delegates many methods to its template" do
      @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [Appearance.new(resource: "Post")])
      @name_field = BpCustomFields::FieldTemplate.create(name: "Name", field_type: 0, group_template: @group_template)
      @name_field.fields.create
      expect(@name_field.fields.first.name).to eq "Name"
      # other attributes/methods
    end

    context "generation" do
      before do
        class ::Post < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end
        
        @post = Post.create
        @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [Appearance.new(resource: "Post")])
        @name_field = BpCustomFields::FieldTemplate.create(name: "Name", field_type: 0, group_template: @group_template)
        @bio_text_area = BpCustomFields::FieldTemplate.create(name: "Biography", field_type: 1, group_template: @group_template)
        @email_field = BpCustomFields::FieldTemplate.create(name: "Email", field_type: 3, group_template: @group_template)
        @post.reload
        @post_group = @post.groups.first
      end
      
      it "is automatically generated when its group is created" do
        expect(@post_group).to eq @group_template.groups.first  
        expect(@post_group.fields.size).to eq 3
      end
      
      it "implements its fields structure from its template" do
        expect(@post_group.fields.map(&:name)).to match ["Name", "Biography", "Email"]
        expect(@post_group.fields.map(&:field_type)).to match ["string", "text", "email"]
      end
    end
  end
end