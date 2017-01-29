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
    expect{ BpCustomFields::AbstractResource.find_or_create_from_appearances(BpCustomFields::Appearance.abstract) }.
    to change{ BpCustomFields::AbstractResource.all.count }.from(0).to(4)
  end
  
  it "is case insensitive" do
    ['about', 'contact', 'navigation', 'footer', 'About', 'Contact', 'Navigation', 'Footer'].each do |resource_id|
      BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: resource_id)        
    end
    expect{ BpCustomFields::AbstractResource.find_or_create_from_appearances(BpCustomFields::Appearance.abstract) }.
    to change{ BpCustomFields::AbstractResource.all.count }.from(0).to(4)
  end
  
end