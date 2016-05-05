# The FieldManager is responsible for building and creating 
# Groups and Fields from GroupTemplates and FieldTemplates.

require 'rails_helper'
RSpec.describe "FieldManager" do

  before do    
    @field_manager = BpCustomFields::FieldManager.new
    @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
    @name_field_template = BpCustomFields::FieldTemplate.create(name: "Name", field_type: 0, group_template: @group_template)
    @bio_text_area_template = BpCustomFields::FieldTemplate.create(name: "Biography", field_type: 1, group_template: @group_template)
    @email_field_template = BpCustomFields::FieldTemplate.create(name: "Email", field_type: 3, group_template: @group_template)
  end
  
  it "can intiialize Fields for a Group based on templates" do
    group = @field_manager.initialize_group_with_fields(@group_template)
    expect(group.fields.size).to eq 3
    expect(group.fields.all?(&:persisted?)).to eq false
    expect(group.persisted?).to eq false
  end
  
  it "copies fields' attributes" do
    group = @field_manager.initialize_group_with_fields(@group_template)
    expect(group.fields.map(&:name)).to match ["Name", "Biography", "Email"]
    expect(group.fields.map(&:field_type)).to match ["string", "text", "email"]
  end
end
# it "is automatically generated when its group is created" do
#   expect(@post_group).to eq @group_template.groups.first
#   expect(@post_group.fields.size).to eq 3
# end
#
# it "implements its fields structure from its template" do
#   expect(@post_group.fields.map(&:name)).to match ["Name", "Biography", "Email"]
#   expect(@post_group.fields.map(&:field_type)).to match ["string", "text", "email"]
# end