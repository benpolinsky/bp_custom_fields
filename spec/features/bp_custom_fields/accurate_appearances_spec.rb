require 'rails_helper'

RSpec.describe "Accurate Appearances", type: :feature do
  context 'Resources' do 
    before do
      # Setup Posts
      Post.delete_all
      BpCustomFields::Appearance.delete_all    
      class ::Post < ActiveRecord::Base
        include BpCustomFields::Fieldable
      end
  
      # Setup People
    
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
    
      it "will show on edit resource one matches and is included but a sibling is excluded" do
        @appearance.update(appears: false)
        inclusive_appearance = BpCustomFields::Appearance.create(resource: "Post", resource_id: @other_post.id, appears: true)
        @group_template.appearances << inclusive_appearance
        @group_template.save
        visit edit_post_path(@other_post.id)
        custom_fields_container = all('.custom-field-container')
        expect(custom_fields_container.size).to eq 1
      end
    
      it "including two separate posts, all people except for one" do
        person_one = Person.create(first_name: "Al")
        person_two = Person.create(first_name: "Brady")
        person_three = Person.create(first_name: "Cleveson")
        person_four = Person.create(first_name: "Don")
      
        second_post_appearance = BpCustomFields::Appearance.create(resource: "Post", resource_id: @other_post.id, appears: true)
        people_appearance = BpCustomFields::Appearance.create(resource: "Person")
        first_person_appearance = BpCustomFields::Appearance.create(resource: "Person", resource_id: person_one.id, appears: false)
      
        @group_template.appearances << [second_post_appearance, people_appearance, first_person_appearance]
        @group_template.save
      
        visit edit_post_path(@post)
        custom_fields_container = all('.custom-field-container')
        expect(custom_fields_container.size).to eq 1
      
        visit new_post_path
        custom_fields_container = all('.custom-field-container')
        expect(custom_fields_container.size).to eq 0
      
        visit new_person_path
        custom_fields_container = all('.custom-field-container')
        expect(custom_fields_container.size).to eq 1
      
        visit edit_person_path(person_one)
        custom_fields_container = all('.custom-field-container')
        expect(custom_fields_container.size).to eq 0
      
        visit edit_person_path(person_two)
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
  
  context "Abstract Resources", focus: true do
    before do
      BpCustomFields::Appearance.delete_all
    end
    
    # as of now, abstract resources only appear in the navigation if
    # you've visited them first, because bp_custom_fields triggers the whole shebang.
    # That's something to be worked on once I've got some solid specs.
    it 'can be created from a resource_id and a class of AbstractResource' do
      @appearance = BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: 'page')
      @group_template = BpCustomFields::GroupTemplate.create(name: "page info", appearances: [@appearance])
      name_field = BpCustomFields::FieldTemplate.create(name: "description", label: "Name", field_type: 'text', group_template: @group_template)
      
      visit bp_custom_fields.abstract_resources_path
      within('table'){expect(page).to have_content "Abstract Resource"}

      expect(page).to have_content "page"      
      find('a', text: "Edit").click

      expect(page).to have_content "page info"
      expect(page).to have_content "Name"
    end
    
    it "doesn't matter if the resource_id is upcase or downcase" do
      @appearance = BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: 'Page')
      @group_template = BpCustomFields::GroupTemplate.create(name: "page info", appearances: [@appearance])
      name_field = BpCustomFields::FieldTemplate.create(name: "description", label: "Name", field_type: 'text', group_template: @group_template)
      
      visit bp_custom_fields.abstract_resources_path
      within('table'){expect(page).to have_content "Abstract Resource"}

      expect(page).to have_content "Page"      
      find('a', text: "Edit").click

      expect(page).to have_content "page info"
      expect(page).to have_content "Name"
    end
    
    it "doesn't matter if the resource_id is one or two words" do
      @appearance = BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: 'Home Page')
      @group_template = BpCustomFields::GroupTemplate.create(name: "page info", appearances: [@appearance])
      name_field = BpCustomFields::FieldTemplate.create(name: "description", label: "Name", field_type: 'text', group_template: @group_template)
      
      visit bp_custom_fields.abstract_resources_path
      within('table'){expect(page).to have_content "Abstract Resource"}

      expect(page).to have_content "Home Page"      
      find('a', text: "Edit").click

      expect(page).to have_content "page info"
      expect(page).to have_content "Name"
    end
  end
  
end