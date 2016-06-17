require 'rails_helper'
RSpec.describe BpCustomFields do
  context "::configure" do
    before do
      BpCustomFields.configure do |config|
        config.controller_layout = "admin"
      end
    end
    
    it "sets the layout for all controllers" do
      # byebug
      # expect(BpCustomFields::ApplicationController.new.layout).to eq "admin"
    end
  end
end