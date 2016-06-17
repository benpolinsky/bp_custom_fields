module BpCustomFields
  class Configuration
    attr_accessor :controller_layout
    def initialize
      @controller_layout = "application"
    end
  end
end