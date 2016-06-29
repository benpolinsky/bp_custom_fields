module BpCustomFields
  class Configuration
    attr_accessor :controller_layout, :carrierwave_upload_method
    def initialize
      @controller_layout = "application"
      @carrierwave_upload_method = :file
    end
  end
end