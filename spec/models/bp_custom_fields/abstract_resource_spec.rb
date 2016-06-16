require 'rails_helper'
RSpec.describe BpCustomFields::AbstractResource, type: :model do
  before do
    @abstract_resource = BpCustomFields::AbstractResource.new
  end
  
  it "is fieldable" do
    expect(@abstract_resource.groups).to eq []
  end
end