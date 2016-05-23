# The FieldManager is responsible for building and creating 
# Groups and Fields from GroupTemplates and FieldTemplates.

require 'rails_helper'
RSpec.describe "FieldManager" do

  before do    
    @field_manager = BpCustomFields::FieldManager
    @group_template = BpCustomFields::GroupTemplate.create(name: "Worker Profile", appearances: [BpCustomFields::Appearance.new(resource: "Post")])
  end
  
  context "basic fields" do 
    before do
      @name_field_template = BpCustomFields::FieldTemplate.create(name: "Name", field_type: 'string', group_template: @group_template)
      @bio_text_area_template = BpCustomFields::FieldTemplate.create(name: "Biography", field_type: 'text', group_template: @group_template)
      @email_field_template = BpCustomFields::FieldTemplate.create(name: "Email", field_type: 'email', group_template: @group_template)
    end
    it "initializes Fields for a Group based on templates" do
      group = @field_manager.initialize_group_with_fields(@group_template)
      expect(group.fields.size).to eq 3
      expect(group.fields.all?(&:persisted?)).to eq false
      expect(group.persisted?).to eq false
    end
  
    it "copies fields' attributes" do
      group = @field_manager.initialize_group_with_fields(@group_template)
      expect(group.fields.map(&:name)).to match ["Name", "Biography", "Email"]
      expect(group.fields.map(&:field_type)).to match ["string", "text", "email"]
    end
  end
  
  context "gallery fields" do
    before do
      @gallery_field_template = BpCustomFields::FieldTemplate.create(name: "Vacation Photos", field_type: 'gallery', group_template: @group_template)
    end
    
    it "initializes a gallery field as well as one child image field_template" do
      expect(@group_template.field_templates.first.children.size).to eq 0
      group = @field_manager.initialize_group_with_fields(@group_template)
      expect(@group_template.field_templates.first.children.size).to eq 1
      expect(@group_template.field_templates.first.children.first.field_type).to eq 'image'
      expect(group.fields.size).to eq 1
      expect(group.fields.first.field_template.field_type).to eq 'gallery'
    end
  end
  
  context "tab fields" do
    before do
      @tab_field_template = BpCustomFields::FieldTemplate.create(name: "First Tab", field_type: 'tab', group_template: @group_template)
      @tab_child_one = @tab_field_template.children.create(name: "Name", field_type: 'string')
      @tab_child_two = @tab_field_template.children.create(name: "Bio", field_type: 'text')
      @tab_child_three = @tab_field_template.children.create(name: "Location", field_type: 'text')
      
      @tab_field_template_two = BpCustomFields::FieldTemplate.create(name: "Second Tab", field_type: 'tab', group_template: @group_template)
      @second_tab_child_one = @tab_field_template_two.children.create(name: "Activity", field_type: 'string')
      @second_tab_child_two = @tab_field_template_two.children.create(name: "About Activity", field_type: 'text')
      
    end
    
    it "initializes all children fields based on templates" do
      group = @field_manager.initialize_group_with_fields(@group_template)
      expect(group.fields.size).to eq 2
      expect(group.fields.first.children.size).to eq 3
      expect(group.fields.last.children.size).to eq 2
    end
    
    it "initializes a gallery field if one of its children is a gallery template" do
      @second_tab_child_three = @tab_field_template_two.children.create(name: "Gallery in tab", field_type: "gallery", group_template: @group_template)
      group = @field_manager.initialize_group_with_fields(@group_template)
      expect(group.fields.size).to eq 3
      expect(group.fields.last.field_type).to eq 'gallery'
      expect(group.fields.last.field_template.children.first.field_type).to eq 'image'
    end
    
  end
  
  context "repeater fields" do 
    before do
      @repeater_field_template = BpCustomFields::FieldTemplate.create(name: "Todo List", field_type: 'repeater', group_template: @group_template)
      @task_field_template = @repeater_field_template.children.create(name: "Task Field", field_type: 'string')
      @completed_field_template = @repeater_field_template.children.create(name: "Completed", field_type: 'truefalse')
    end
    
    # still using (sub)groups for repeater fields
    it "creates a repeater field and sub group" do
      group = @field_manager.initialize_group_with_fields(@group_template)
      expect(group.fields.size).to eq 1
      expect(group.fields.first.field_type).to eq 'repeater'
      expect(group.fields.first.sub_groups.size).to eq 1
    end
    
    it "creates a field for each type withing each sub group" do
      group = @field_manager.initialize_group_with_fields(@group_template)
      subgroup = group.fields.first.sub_groups.first
      expect(subgroup.fields.size).to eq 2
      expect(subgroup.fields.map(&:name)).to match ['Task Field', 'Completed']
    end
  end
  
  context "basic flexible content fields" do
    before do
      @flex_content_template = BpCustomFields::FieldTemplate.create(name: "Flex", field_type: 'flexible_content', group_template: @group_template)
      @buckets_field_template = @flex_content_template.children.create(name: "Buckets", field_type: 'layout')
      @homebody_field_template = @flex_content_template.children.create(name: "Home Body", field_type: 'layout')

      @title_field = @buckets_field_template.children.create(name: "Title Field Template", field_type: 'string')
      @bucket_body_field = @buckets_field_template.children.create(name: "Bucket Body", field_type: 'text')
      @bucket_links_to = @buckets_field_template.children.create(name: "Bucket Links To", field_type: 'string')

      @homebody_headline = @homebody_field_template.children.create(name: "Homebody Headline", field_type: 'string')
      @homebody_text = @homebody_field_template.children.create(name: "Homebody text", field_type: 'text')
    end

    it "creates a flex_content field and layout fields" do
      group = @field_manager.initialize_group_with_fields(@group_template, true)
      expect(group.fields.size).to eq 1
      expect(group.fields.first.field_type).to eq 'flexible_content'
      expect(group.fields.first.children.size).to eq 2
      expect(group.fields.first.children.map(&:field_type)).to match ['layout', 'layout']
      expect(group.fields.first.children.first.children.map(&:field_type)).to match ['string', 'text', 'string']
    end
    
    it "builds all possible flex_contents' layouts' childrens' fields" do
      group = @field_manager.initialize_group_with_fields(@group_template, true)
      first_layout_field = group.fields.first.children.first
      second_layout_field = group.fields.first.children.last
      expect(first_layout_field.children.size).to eq 3
      expect(second_layout_field.children.size).to eq 2
    end
  end
  
  context "complex flexible content fields" do
    before do
      @flex_content_template = BpCustomFields::FieldTemplate.create(name: "Flex", field_type: 'flexible_content', group_template: @group_template)
      @buckets_field_template = @flex_content_template.children.create(name: "Buckets", field_type: 'layout')
      @homebody_field_template = @flex_content_template.children.create(name: "Buncha Galleries", field_type: 'layout')


      @repeater_field_template = @buckets_field_template.children.create(name: "Bucket Repeater", field_type: "repeater")
      @title_field = @repeater_field_template.children.create(name: "Title Field Template", field_type: 'string')
      @bucket_body_field = @repeater_field_template.children.create(name: "Bucket Body", field_type: 'text')
      @bucket_links_to = @repeater_field_template.children.create(name: "Bucket Links To", field_type: 'string')
      
      @gallery_field_template = @homebody_field_template.children.create(name: "Article Gallery", field_type: "gallery")
    end
    
    it "creates necessary groups on a repeater field" do
      group = @field_manager.initialize_group_with_fields(@group_template, true)
      buckets = group.fields.first.children.first
      bucket_repeater = buckets.children.first
      expect(buckets.field_type).to eq 'layout'
      expect(bucket_repeater.field_type).to eq 'repeater'
      expect(bucket_repeater.sub_groups.size).to eq 1
      expect(bucket_repeater.sub_groups.first.fields.size).to eq 3
    end
    
    it "creates necessary fields and templates on a gallery field" do
      group = @field_manager.initialize_group_with_fields(@group_template, true)

      gallery_layout = group.fields.last.children.last
      gallery_field = gallery_layout.children.first
      expect(gallery_layout.field_type).to eq 'layout'
      expect(gallery_layout.children.size).to eq 1
      expect(gallery_field.field_type).to eq 'gallery'
      expect(gallery_field.field_template.children.first.field_type).to eq 'image'
    end
    
    it "creates necessary fields and templates on a tab field" do
      @person_information_template = @flex_content_template.children.create(name: "Person Information", field_type: "layout")
      @tab_field_template = @person_information_template.children.create(name: "First Tab", field_type: 'tab')
      @tab_child_one = @tab_field_template.children.create(name: "Name", field_type: 'string')
      @tab_child_two = @tab_field_template.children.create(name: "Bio", field_type: 'text')
      @tab_child_three = @tab_field_template.children.create(name: "Location", field_type: 'text')
      
      @tab_field_template_two = @person_information_template.children.create(name: "Second Tab", field_type: 'tab')
      @second_tab_child_one = @tab_field_template_two.children.create(name: "Activity", field_type: 'string')
      @second_tab_child_two = @tab_field_template_two.children.create(name: "About Activity", field_type: 'text')
      group = @field_manager.initialize_group_with_fields(@group_template, true)
      
      person_info_layout = group.fields.last.children.last
      tab_one = person_info_layout.children.first
      tab_two = person_info_layout.children.last
      
      expect(person_info_layout.field_type).to eq 'layout'
      expect(person_info_layout.children.size).to eq 2
      expect(person_info_layout.children.map(&:field_type)).to match ['tab', 'tab']
      expect(tab_one.children.size).to eq 3
      expect(tab_two.children.size).to eq 2
      
    end
    
  end
end
