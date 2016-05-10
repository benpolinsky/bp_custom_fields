module BpCustomFields
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    require 'cocoon'
    require 'carrierwave'
    isolate_namespace BpCustomFields
  end
end
