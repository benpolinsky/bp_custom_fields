require 'rails_helper'

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
      
      it "adds custom field groups to existing models" do
        post = Post.create
        expect(post.groups.count).to eq 0
        expect(post.groups.map(&:group_template).size).to eq 0
        template_two = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])

        post.add_custom_field_groups
        expect(post.groups.map(&:group_template).size).to eq 1
        expect(post.groups.map(&:group_template)).to match [template_two]
      end
      
      it "removes the custom field groups from existing models when deleted" do
        post = Post.create
        custom_group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        post.add_custom_field_groups

        expect(post.groups.map(&:group_template).size).to eq 1
        
        custom_group_template.destroy
        post.reload
        expect(post.groups.map(&:group_template).size).to eq 0
      end
      
      
      it "can tell if there is a new group that is needed to be added" do
        post = Post.create
        expect(post.new_groups_available?).to eq false
        group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        expect(post.new_groups_available?).to eq true
      end
      
      it "can add a new group if available" do
        post = Post.create
        BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        expect(post.new_groups_available?).to eq true
        expect{post.add_new_custom_field_groups}.to change{post.groups.size}.from(0).to(1)
      end
      
      it "can add a few new groups if available" do
        post = Post.create
        BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        BpCustomFields::GroupTemplate.create(name: "Gallery_two", appearances: [Appearance.new(resource: "Post", resource_id: post.id)])
        BpCustomFields::GroupTemplate.create(name: "Gallery_three", appearances: [Appearance.new(resource: "Post", resource_id: post.id)])
        expect(post.new_groups_available?).to eq true
        expect{post.add_new_custom_field_groups}.to change{post.groups.size}.from(0).to(3)
      end
      
      it "can add many many new groups if available" do
        post = Post.create
        100.times { |i| BpCustomFields::GroupTemplate.create(name: "Gallery #{i}", appearances: [Appearance.new(resource: "Post")])}
        expect(post.new_groups_available?).to eq true
        expect{post.add_new_custom_field_groups}.to change{post.groups.size}.from(0).to(100)
      end
      
      it "can tell if it has stale groups" do
        group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        post = Post.create
        post.add_custom_field_groups
        expect(post.groups.size).to eq 1
        expect(post.new_groups_available?).to eq false
        expect(post.stale_groups?).to eq false
        group_template.appearances.first.update(resource: 'Gribble')
        expect(post.new_groups_available?).to eq false
        expect(post.stale_groups?).to eq true
      end
      
      it "can delete a stale group" do
        group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        post = Post.create
        post.add_custom_field_groups
        expect(post.groups.size).to eq 1
        group_template.appearances.first.update(resource: 'Gribble')
        post.delete_stale_groups
        expect(post.groups.size).to eq 0
      end
      
      it "can delete a few stale groups" do
        group_templates = []
        3.times { |i| group_templates << BpCustomFields::GroupTemplate.create(name: "Gallery #{i}", appearances: [Appearance.new(resource: "Post")])}
        post = Post.create
        post.add_custom_field_groups
        expect(post.groups.size).to eq 3
        group_templates.each {|template| template.appearances.first.update(resource: 'Gribble')}
        post.delete_stale_groups
        expect(post.groups.size).to eq 0
      end
      
      it "doesn't delete any groups if there are no stale groups" do
        group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
        post = Post.create
        post.add_custom_field_groups
        expect(post.groups.size).to eq 1
        expect(post.stale_groups?).to eq false
        expect{post.delete_stale_groups}.to_not change{post.groups.size}
      end
      
    end
  end
end