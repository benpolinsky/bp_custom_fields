require 'rails_helper'
RSpec.describe BpCustomFields do
  context "::configure" do
    before do
      BpCustomFields.configure do |config|
        config.controller_layout = "application"
      end
    end
    
    # TODO: Not sure how to test the default layout is set.
    # Or if it's even a good idea.
    pending "sets the layout for all controllers" do
      expect(BpCustomFields::ApplicationController.new.active_layout.name).to eq "admin"
    end
  end

end