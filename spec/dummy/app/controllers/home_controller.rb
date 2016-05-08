class HomeController < ApplicationController
  def index
    @custom_fields = BpCustomFields.all
  end
end