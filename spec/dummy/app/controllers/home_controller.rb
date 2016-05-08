class HomeController < ApplicationController
  def index
    @custom_fields = BpCustomFields.all
  end
  
  def single
    # @video = BpCustomFields.find('video')
  end
end