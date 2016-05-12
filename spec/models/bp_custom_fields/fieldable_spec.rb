require 'rails_helper'

module BpCustomFields
  RSpec.describe "Fieldable Model" do
    
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

      context "querying custom fields", focus: true do
        before do
          @post = Post.create
          @group_template = BpCustomFields::GroupTemplate.create(name: "Gallery", appearances: [Appearance.new(resource: "Post")])
          @picture_one_template = @group_template.field_templates.create(name: "picture one", field_type: "string")
          @picture_two_template = @group_template.field_templates.create(name: "picture two", field_type: "string")
          @picture_three_template = @group_template.field_templates.create(name: "picture three", field_type: "string")
          
          @group_template_two = BpCustomFields::GroupTemplate.create(name: "Badge", appearances: [Appearance.new(resource: "Post")])
          @badge_template_one = @group_template_two.field_templates.create(name: 'picture one', field_type: 'string')
          BpCustomFields::FieldManager.update_groups_for_fieldable(@post)
          
        end
        
        
        it 'can ::find_fields(string) with the same name' do
          expect(Post.find_fields('picture one')).to match [@picture_one_template.fields.first, @badge_template_one.fields.first]
          expect(Post.find_fields('picture two')).to match [@picture_two_template.fields.first]
        end
        
        #it 'can #find_fields(keyable) within a specific group'
        
        it '::find_group will find a group with specified name' do
          expect(Post.find_group('Badge')).to eq [@group_template_two.groups.first]
          expect(Post.find_group('Gallery')).to eq [@group_template.groups.first]
        end
        
        
        it "can return #groups_and_fields for a record" do
          expect(@post.groups_and_fields).to eq [{
            "Gallery" => [
              @picture_one_template.fields.first,
              @picture_two_template.fields.first,
              @picture_three_template.fields.first
              ]},{
            "Badge" => [
              @badge_template_one.fields.first
            ]}
          ]
          
          
          @person = Person.create
          @group_template_three = BpCustomFields::GroupTemplate.create(name: "Bio", appearances: [Appearance.new(resource: "Person", resource_id: @person.id)])
          @bio_field_template_one = @group_template_three.field_templates.create(name: 'biography title', field_type: 'string')
          BpCustomFields::FieldManager.update_groups_for_fieldable(@person)
          expect(@person.groups_and_fields).to match [{"Bio" => [@bio_field_template_one.fields.first]}]
        end
        
        
        it "can return #custom_fields for a record" do
          expect(@post.custom_fields).to eq [@picture_one_template.fields.first, @picture_two_template.fields.first, @picture_three_template.fields.first, @badge_template_one.fields.first]  
        end


        #TODO: find by type
      end
  end
end