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

  end
end