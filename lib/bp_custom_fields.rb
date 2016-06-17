require 'bp_custom_fields/version'
require "bp_custom_fields/engine"
require 'bp_custom_fields/railtie' if defined?(Rails)
require 'bp_custom_fields/fieldable'
require 'bp_custom_fields/field_manager'
require 'bp_custom_fields/query_methods'
require 'bp_custom_fields/configuration'
require 'bp_custom_fields/video'

module BpCustomFields
  class << self
    attr_writer :configuration
  end
  
  EXCLUDED_MODELS = [
    "ActiveRecord::SchemaMigration", 
    'BpCustomFields::GroupTemplate', 
    'BpCustomFields::Group', 
    'BpCustomFields::Appearance',
    'BpCustomFields::Field',
    'BpCustomFields::FieldTemplate'
  ]
  
  def self.configuration
    @configuration ||= Configuration.new
  end
  
  def self.configure
    yield(configuration)
  end
end