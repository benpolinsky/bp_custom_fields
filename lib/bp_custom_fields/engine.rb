module BpCustomFields
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    require 'cocoon'
    require 'carrierwave'
    require 'ranked-model'
    isolate_namespace BpCustomFields
  end
end
