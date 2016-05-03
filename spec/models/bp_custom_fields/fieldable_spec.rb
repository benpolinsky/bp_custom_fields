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
      
      it "is initialized with existing custom field groups" do
        template = BpCustomFields::GroupTemplate.create(name: "Badge", appearances: [Appearance.new(resource: "Post")])
        post = Post.create
        expect(post.groups.first.group_template).to eq template
      end
      
      it "adds custom field groups to existing models on create" do
        # here's the problem of adding fields to instances that have already been created....
        post = Post.create
        expect(post.groups.count).to eq 0
        expect(post.groups.map(&:group_template).size).to eq 0
        template_two = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        post.reload
        expect(post.groups.map(&:group_template).size).to eq 1
        expect(post.groups.map(&:group_template)).to match [template_two]
      end
      
      it "removes the custom field groups from existing models when deleted" do
        post = Post.create
        custom_group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        post.reload
        expect(post.groups.map(&:group_template).size).to eq 1
        custom_group_template.destroy
        post.reload
        expect(post.groups.map(&:group_template).size).to eq 0
      end
    end
  end
end