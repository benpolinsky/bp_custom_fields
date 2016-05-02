module BpCustomFields
  class ApplicationController < ::ApplicationController
    layout 'application'
    before_filter :thi
    
    def thi
      puts 'sdad'
    end
  end
end
