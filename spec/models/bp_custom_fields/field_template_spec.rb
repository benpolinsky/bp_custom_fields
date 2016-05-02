require 'rails_helper'

RSpec.describe BpCustomFields::FieldTemplate, type: :model do
  it "exists" do
    expect(BpCustomFields::FieldTemplate.new).to be_a BpCustomFields::FieldTemplate
  end
end