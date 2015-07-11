class PagesController < ApplicationController
  layout "application"

  def index
    @image_path_config = ExternalFilmService.image_config
    render layout: "main" 
  end

end