require 'rails_helper'

module BpCustomFields
  RSpec.describe BpCustomFields::GroupTemplate, type: :model do
    
    before :each do
      class ::Post < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end
      
      @valid_appearances = [
        BpCustomFields::Appearance.new(resource: "Post")
      ]
    end
    
    it "exists" do
      expect(BpCustomFields::GroupTemplate.new).to be_a BpCustomFields::GroupTemplate

    end
    
    it "is invalid without a name" do
      group_template = BpCustomFields::GroupTemplate.new(appearances: @valid_appearances)
      expect(group_template).to_not be_valid
      group_template.name = "portfolio details"
      expect(group_template).to be_valid
    end
    
    it "is invalid without an appearance" do
      group_template = BpCustomFields::GroupTemplate.new(name: "portfolio deets")
      expect(group_template).to_not be_valid
      group_template.appearances = @valid_appearances
      expect(group_template).to be_valid
    end
    
    context "associations" do
      
      it "has_many groups" do
        group_template = BpCustomFields::GroupTemplate.create(name: "Badge", appearances: @valid_appearances)
        expect(group_template.groups.size).to eq 0
        group_template.groups.create
        expect(group_template.groups.size).to eq 1
        group_template.groups.create
        expect(group_template.groups.size).to eq 2
      end
      
      it "has many appearances" do
        group_template = BpCustomFields::GroupTemplate.create(name: "Badge", appearances: @valid_appearances)
        expect(group_template.appearances.size).to eq 1
      end
      
      it "destroys appearances when deleted" do
        group_template = BpCustomFields::GroupTemplate.create(name: "Badge", appearances: @valid_appearances)
        expect{group_template.destroy}.to change{group_template.appearances.size}.from(1).to(0)
      end
    end
  end
end