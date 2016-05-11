require 'bp_custom_fields/version'
require "bp_custom_fields/engine"
require 'bp_custom_fields/railtie' if defined?(Rails)
require 'bp_custom_fields/fieldable'
require 'bp_custom_fields/field_manager'
require 'bp_custom_fields/query_methods'
require 'bp_custom_fields/video'

module BpCustomFields
  EXCLUDED_MODELS = [
    "ActiveRecord::SchemaMigration", 
    'BpCustomFields::GroupTemplate', 
    'BpCustomFields::Group', 
    'BpCustomFields::Appearance',
    'BpCustomFields::Field',
    'BpCustomFields::FieldTemplate'
  ]
  
  PROTECTED_ATTRIBUTES = {groups_attributes: [:id, :group_template_id, fields_attributes: [:id, :value, :file, :field_template_id]]}

  FIELD_TEMPLATE_OPTION_DEFINITIONS = {
    string: [],
    text: [:rows],
    number: [],
    email: [],
    editor: [:rows, :toolbar],
    date_and_time: [:datetime_format],
    date: [:date_format],
    time: [:time_format],
    file: [:accepted_file_types],
    image: [:accepted_image_types],
    video: [],
    audio: []
  }
end
