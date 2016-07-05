require 'rails_helper'
module BpCustomFields
  RSpec.describe BpCustomFields::FieldTemplate, type: :model do
    
    context "validations" do
      it "requires a name" do
        choice_template = BpCustomFields::FieldTemplate.new(label: "theme-color", choices: "Red, Blue, Yellow", field_type: 'dropdown')        
        expect{choice_template.update(name: 'Theme Color')}.to change {choice_template.valid?}.from(false).to(true)
      end
      it "must have a unique name" do
        choice_template = BpCustomFields::FieldTemplate.create(name: "Theme Color", label: "theme-color", choices: "Red, Blue, Yellow", field_type: 'dropdown')        
        expect(BpCustomFields::FieldTemplate.create(name: "Theme Color", label: "theme-color-two", choices: "Green, Purple, Silver", field_type: 'dropdown').valid?).to eq false
      end
    end
    
    context "choices" do
      it "stores choices as comma delineated list" do
        choice_template = BpCustomFields::FieldTemplate.create(name: "Theme Color", label: "theme-color", choices: "Red, Blue, Yellow", field_type: 'dropdown')
        expect(choice_template.all_choices).to eq ['Red', 'Blue', 'Yellow']
      end
      
      it "stores choices with values as colon-separated pairs of label:values in a comma delineated list" do
        choice_template = BpCustomFields::FieldTemplate.create({
          name: "Theme Color", 
          label: "theme-color", 
          choices: "Red:#ff0000, Blue:#0033cc, Yellow:#ffff00",
          field_type: "checkboxes"
        })
        
        expect(choice_template.all_choices).to eq({'Red' => '#ff0000', 'Blue' => '#0033cc', 'Yellow' => '#ffff00'})
      end
      
    end
    
    context "hierarchical templates", focus: true do
      context "galleries" do
        before do
          @gallery_field_template = BpCustomFields::FieldTemplate.create(
            name: "My First Gallery", 
            label: "my-first-gallery", 
            field_type: "gallery", 
            group_template: @group_template
            )
        end
        
        it 'has many children field templates' do
          expect(@gallery_field_template.has_children?).to be false
          @gallery_field_template.children.create({
            name: "First picture",
            label: "First picture",
            field_type: "image"
          })
          
          @gallery_field_template.children.create({
            name: "First picture",
            label: "First picture",
            field_type: "image"
          })
          
          expect(@gallery_field_template.has_children?).to be true
        end
        
        it "can only have image_field field_templates as children" do
          expect(@gallery_field_template.has_children?).to be false
          
          child_one = @gallery_field_template.children.create({
            name: "First picture",
            label: "First picture",
            field_type: "string"
          })
          
          expect(child_one.errors[:field_type].size).to eq 1
          expect(@gallery_field_template.has_children?).to be false
          
          child_one.update(field_type: 'image')
          
          expect(child_one.errors[:field_type].size).to eq 0
          expect(@gallery_field_template.has_children?).to be true
        end
        
      end
      
      context "flexible content" do
        before do
          @flex_content_template = BpCustomFields::FieldTemplate.create(name: "Flex", field_type: 'flexible_content', group_template: @group_template)
        end
        
        it "can only have children of type 'layout'" do
          @flex_content_template.children.build(name: "valid layout", field_type: 'text')
          expect(@flex_content_template.valid?).to eq false
          @flex_content_template.children.first.field_type = 'layout'
          expect(@flex_content_template.valid?).to eq true
        end
      end
    end
  end
end