BASE_FIELD_TYPES = [
  :string, :text, :number, :email, :date_and_time, 
  :date, :time, :file, :image, :video, :editor
]

CHOICE_FIELD_TYPES = [
  :dropdown, :checkboxes, :truefalse
]

COMPLEX_FIELD_TYPES = [
  :gallery, :repeater, :tab, :flexible_content
]

appearance = BpCustomFields::Appearance.new(resource: "Post")
group_template = BpCustomFields::GroupTemplate.create(name: "My Custom Field Group", appearances: [appearance])

BASE_FIELD_TYPES.each do |field_type|
  group_template.field_templates.create(field_type: field_type.to_s, name: "#{field_type.to_s} field", label: "#{field_type.to_s.underscore}_label")
end