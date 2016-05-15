# let's create some base seeds

# First a group_template
appearance = BpCustomFields::Appearance.new(resource: "Post")
group_template = BpCustomFields::GroupTemplate.create(name: "My Custom Field Group", appearances: [appearance])

[:string, :text, :number, :email, :editor, :date_and_time, :date, :time, :file, :image, :video, :audio, :dropdown, :checkboxes, :truefalse, :gallery, :repeater].each do |field_type|
  group_template.field_templates.create(field_type: field_type.to_s, name: "#{field_type.to_s} field", label: "#{field_type.to_s.underscore}_label")
end