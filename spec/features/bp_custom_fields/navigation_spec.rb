require 'rails_helper'

RSpec.describe 'Navigation', type: :feature do
  before do
  end

  context "abstract_resource_admin_nav" do
    it "displays nothing if no abstract resources exist" do
      visit root_path
      expect(page).to_not have_selector('.abstract-resource-link')
      expect(page).to_not have_selector('.abstract-resource-navigation')
    end
    
    it "does not display a link if it has no fields", focus: true do
      BpCustomFields::AbstractResource.create({
        name: "Recipes"
      })      
      
      visit root_path
      
      expect(page).to_not have_selector('.abstract-resource-navigation')
      expect(page).to_not have_selector('.abstract-resource-link')
      expect(page).to_not have_content('Recipes')
    end
    
    it "displays one link if one abstract resource exists with groups" do
      recipe = BpCustomFields::AbstractResource.create({
        name: "Recipes"
      })

      appearance = BpCustomFields::Appearance.create(resource: "BpCustomFields::AbstractResource", resource_id: 'Recipes')
      
      group_template = BpCustomFields::GroupTemplate.create(name: "Recipe Group", appearances: [appearance])
      group = recipe.groups.create(group_template_id: group_template.id)
      visit root_path
      expect(page).to have_selector('.abstract-resource-navigation')
      expect(page).to have_selector('.abstract-resource-link')
      expect(page).to have_content('Recipes')
    end
    
    it "displays a few links if a few abstract resources exists" do

      ['Recipes', 'Stories', 'Content Blocks'].each do |name|
        appearance = BpCustomFields::Appearance.create({
          resource: "BpCustomFields::AbstractResource", 
          resource_id: name
        })
        
        group_template = BpCustomFields::GroupTemplate.create({
          name: "#{name} Group", appearances: [appearance]
        })
      
        abstract_resource =  BpCustomFields::AbstractResource.create({
          name: name
        })
      
        group = abstract_resource.groups.create(group_template_id: group_template.id)
      end
      
      visit root_path
      expect(page).to have_selector('.abstract-resource-navigation')
      expect(page).to have_selector('.abstract-resource-link', count: 3)
      expect(page).to have_link('Recipes')
      expect(page).to have_link('Stories')
      expect(page).to have_link('Content Blocks')
    end
  
    

  end
end