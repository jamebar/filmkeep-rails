class MeController < ApplicationController

  def index
    render json: ::Bootstrapper.new(current_user).to_h
  end

  def is_authorized
    render json: user_signed_in? ? 1 : 0
  end

end