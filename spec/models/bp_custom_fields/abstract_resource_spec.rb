require 'rails_helper'
RSpec.describe BpCustomFields::AbstractResource, type: :model do
  before do
    @abstract_resource = BpCustomFields::AbstractResource.new
  end
  
  it "is fieldable" do
    expect(@abstract_resource.groups).to eq []
  end
  
  it "can be created from current abstract appearances" do
    ['about', 'contact', 'navigation', 'footer'].each do |resource_id|
      BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: resource_id)        
    end
    
    BpCustomFields::AbstractResource.find_or_create_from_appearances(BpCustomFields::Appearance.abstract)
    resources = BpCustomFields::AbstractResource.all.map do |res|
      BpCustomFields::FieldManager.update_groups_for_fieldable(res)      
    end

    expect(BpCustomFields::AbstractResource.all.count).to eq 4
    # expect(BpCustomFields::AbstractResource.all.map(&:groups).flatten.size).to eq 4
  end
  
  it 'must have a unique name' do
    expect{
      BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: 'About')
      BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: 'About')          
      BpCustomFields::AbstractResource.find_or_create_from_appearances(BpCustomFields::Appearance.abstract)
    }.to change { BpCustomFields::AbstractResource.all.count }.from(0).to(1)
  end
  
end