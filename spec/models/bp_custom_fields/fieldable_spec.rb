# For defining fieldable functionality for an application's models
module BpCustomFields
  RSpec.describe "Fieldable Model" do
    
    # should probably move this to a support folder/method
    
    describe "Fieldable Model" do
      before :each do
        
        class ::Post < ActiveRecord::Base
          include BpCustomFields::Fieldable
        end
      end

      it "can receive custom field groups" do
        post = Post.create
        expect(post.groups).to match []
      end
      
      it "starts with custom field groups if they've been defined for the model by a group template" do
        
        template = BpCustomFields::GroupTemplate.create(name: "Badge", appears_on: "Post")
        post = Post.create
        expect(post.groups.first.group_template).to eq template

        # # here's the problem of adding fields to instances that have already been created....
   #      template_two = BpCustomFields::GroupTemplate.create(name: "Gallery", appears_on: "Post")
   #      expect(post.groups.map(&:group_template)).to match [template, template_two]
      end
    end
  end
end