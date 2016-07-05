require 'rails_helper'
RSpec.describe BpCustomFields do
  context "Query Methods" do
    before do
      class ::Post < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end
      
      @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
      @name_field_template = BpCustomFields::FieldTemplate.create(name: "Name", field_type: 'string', group_template: @group_template)
      @post = Post.create
      @post.add_custom_field_groups
      @name_field = @post.custom_fields.first
      @name_field.update(value: "Ben Polinsky")
    end
    
    it "finds a field with a specific name and resource" do
      expect(BpCustomFields.find_field('Name', @post)).to eq @name_field
    end
    
    it "finds a group with a specific name and resource" do
      expect(BpCustomFields.find_group('Worker Profile', @post)).to eq @name_field.group
    end

  end

end