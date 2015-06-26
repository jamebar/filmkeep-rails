class PagesController < ApplicationController
  layout "application"

  def index
    render layout: "main" 
  end

end