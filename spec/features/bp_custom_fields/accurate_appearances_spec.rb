require 'rails_helper'

RSpec.describe "Accurate Appearances", type: :feature do
  before do
    # Setup Posts
    Post.delete_all
    BpCustomFields::Appearance.delete_all    
    class ::Post < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end
  
    # Setup Fake People
    unless ActiveRecord::Base.connection.table_exists?(:people)
      ActiveRecord::Base.connection.create_table :people do |t|
        t.string :first_name
        t.text :last_name
      end
    end
    
    class ::Person < ActiveRecord::Base
      include BpCustomFields::Fieldable
    end      

    Person.delete_all
    @three_people = Person.where(nil)
    @five_posts = Post.where(nil)
    
    # this seems to be neccessary b/c of the dynamic creation of the table/model?
    # really not sure... I've used the where(nil) other places without these results
    
    @three_people.reload 
    @five_posts.reload
    
    3.times {|i| @three_people << Person.create(first_name: "Person #{i}")}
    5.times {|i| @five_posts << Post.create(title: "Post #{i}")}

  end
  
  after(:all) do
    ActiveRecord::Base.connection.drop_table(:people) if ActiveRecord::Base.connection.table_exists?(:people)
  end
  context "Single Appearance" do
    before do
      @post = @five_posts.last
      @other_post = @five_posts[2]
      @appearance = BpCustomFields::Appearance.create(resource: "Post", resource_id: @post.id)
      @group_template = BpCustomFields::GroupTemplate.create(name: "Bio Area", appearances: [@appearance])
      name_field = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0, group_template: @group_template)
    end
    
    it "does not appear on new resource forms" do
      visit new_post_path
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 0
    end
    
    it "does appear on edit resource forms" do
      visit edit_post_path(@post.id)
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 1
    end
    
    it "does not appear on edit resource forms for different records" do
      visit edit_post_path(@other_post.id)
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 0
    end
    
    it "won't show on edit resource if matches and is excluded (appears: false) even if siblings are included" do
      @appearance.update(appears: false)
      inclusive_appearance = BpCustomFields::Appearance.create(resource: "Post", resource_id: @other_post.id, appears: true)
      @group_template.appearances << inclusive_appearance
      @group_template.save
      visit edit_post_path(@post.id)
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 0
    end
    
    it "will show on edit resource if matches and is included but siblings are excluded" do
      @appearance.update(appears: false)
      inclusive_appearance = BpCustomFields::Appearance.create(resource: "Post", resource_id: @other_post.id, appears: true)
      @group_template.appearances << inclusive_appearance
      @group_template.save
      visit edit_post_path(@other_post.id)
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 1
    end
  end
  
  context "Class-wide appearance" do
    before do
      appearance = BpCustomFields::Appearance.create(resource: "Post")
      group_template = BpCustomFields::GroupTemplate.create(name: "Bio Area", appearances: [appearance])
      name_field = BpCustomFields::FieldTemplate.create(name: "Name", label: "Name", field_type: 0, group_template: group_template)      
    end
    
    it "does appear on new resource forms" do
      visit new_post_path
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 1
    end
    
    it "does appear on edit resource forms" do
      visit edit_post_path(Post.first)
      custom_fields_container = all('.custom-field-container')
      expect(custom_fields_container.size).to eq 1
    end
  end
  

  
end