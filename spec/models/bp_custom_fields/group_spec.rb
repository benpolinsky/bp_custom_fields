require 'rails_helper'
require 'rspec/active_model/mocks'
module BpCustomFields
  RSpec.describe BpCustomFields::Group, type: :model do
    after(:all) do
      ActiveRecord::Base.connection.drop_table(:people) if ActiveRecord::Base.connection.table_exists?(:people)
    end
    
    it "exists" do
      expect(BpCustomFields::Group.new).to be_a BpCustomFields::Group
    end
    
    it "has only one group_template" do
      group = BpCustomFields::Group.create
      expect(group.build_group_template).to be_a BpCustomFields::GroupTemplate
    end
    
    it "isn't valid without a group_template" do
      group = BpCustomFields::Group.create
      group_template = BpCustomFields::GroupTemplate.create(name: "Whatever")

      expect(group).to_not be_valid
      group.group_template = group_template
      expect(group).to be_valid
    end
    
    
    it "is polymorphic and can be attached to any model" do
      group_template = BpCustomFields::GroupTemplate.create(name: "Whatever")
      unless ActiveRecord::Base.connection.table_exists?(:people)
        ActiveRecord::Base.connection.create_table :people do |t|
          t.string :first_name
          t.text :last_name
        end
      end
      
      class ::Post < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end      
      
      class ::Person < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end      
      
      expect(BpCustomFields::Group.all.size).to eq 0
      bill = Person.create(first_name: "Bill")
      expect(bill.groups.size).to eq 0
      bill.groups << BpCustomFields::Group.create(group_template: group_template)
      expect(bill.groups.size).to eq 1
      
      post = Post.create
      expect(post.groups.size).to eq 0
      post.groups << BpCustomFields::Group.create(group_template: group_template)
      expect(post.groups.size).to eq 1
      
      expect(BpCustomFields::Group.all.size).to eq 2
    end
    
    it "has many fields" do
      group_template = BpCustomFields::GroupTemplate.create(name: "Whatever")
      group = BpCustomFields::Group.create(group_template: group_template)
      expect(group.fields.size).to eq 0
      group.fields.create
      expect(group.fields.size).to eq 1
      group.fields.create
      expect(group.fields.size).to eq 2
    end
    
    it "can create its fields from its template" do
      nothing_template = BpCustomFields::GroupTemplate.create(name: "Whatever")
      group = BpCustomFields::Group.create(group_template: nothing_template)
      group.create_fields_from_templates
      expect(group.fields.size).to eq 0
      
      template_with_a_field = BpCustomFields::GroupTemplate.create(name: "Whatever", appearances: [Appearance.new(resource: "Doesntexist")])
      template_with_a_field.field_templates.create(name: "firstname", field_type: 0, label: "firstname")
      group_two = BpCustomFields::Group.create(group_template: template_with_a_field)
      expect(group_two.fields.size).to eq 0
      group_two.create_fields_from_templates
      expect(group_two.fields.size).to eq 1
    end
  end
end