require 'rails_helper'

module BpCustomFields
  RSpec.describe BpCustomFields::GroupTemplate, type: :model do
    
    before :each do
      class ::Post < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end
    end
    
    it "exists" do
      expect(BpCustomFields::GroupTemplate.new).to be_a BpCustomFields::GroupTemplate
    end
    
    # it "checks for any existing #appears_on resource instances and updates them with groups", focus: true do
    #   BpCustomFields::GroupTemplate.delete_all
    #   post = Post.create
    #   expect(post.groups.size).to eq 0
    #
    #   p post.id
    #   BpCustomFields::GroupTemplate.create(name: "Badge", appears_on: "Post")
    #   expect(post.groups.size).to eq 1
    # end
    
    #it "deletes groups attached to any #appears_on resource instances when deleted"
    
    context "associations" do
      it "has many appears_ons (models it'll attach itself to" do
      end
    end
  end
end