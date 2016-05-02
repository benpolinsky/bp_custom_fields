require 'rails_helper'

RSpec.describe BpCustomFields::GroupTemplate, type: :model do
  it "exists" do
    expect(BpCustomFields::GroupTemplate.new).to be_a BpCustomFields::GroupTemplate
  end
end