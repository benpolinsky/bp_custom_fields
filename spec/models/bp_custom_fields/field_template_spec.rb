require 'rails_helper'
module BpCustomFields
  RSpec.describe BpCustomFields::FieldTemplate, type: :model do
    context "choices" do
      it "stores choices as comma delineated list" do
        choice_template = BpCustomFields::FieldTemplate.create(name: "Theme Color", label: "theme-color", choices: "Red, Blue, Yellow")
        expect(choice_template.all_choices).to eq ['Red', 'Blue', 'Yellow']
      end
      
      it "stores choices with values as colon-separated pairs of label:values in a comma delineated list" do
        choice_template = BpCustomFields::FieldTemplate.create({
          name: "Theme Color", 
          label: "theme-color", 
          choices: "Red:#ff0000, Blue:#0033cc, Yellow:#ffff00"
        })
        
        expect(choice_template.all_choices).to eq({'Red' => '#ff0000', 'Blue' => '#0033cc', 'Yellow' => '#ffff00'})
      end
    end
  end
end