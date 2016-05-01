module BpCustomFields
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    require 'cocoon'
    isolate_namespace BpCustomFields
  end
end
