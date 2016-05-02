require 'rails_helper'

RSpec.describe BpCustomFields::Field, type: :model do
  it "exists" do
    expect(BpCustomFields::Field.new).to be_a BpCustomFields::Field
  end
end