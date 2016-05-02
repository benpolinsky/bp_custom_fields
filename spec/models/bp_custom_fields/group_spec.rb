require 'rails_helper'

RSpec.describe BpCustomFields::Group, type: :model do
  it "exists" do
    expect(BpCustomFields::Group.new).to be_a BpCustomFields::Group
  end
end