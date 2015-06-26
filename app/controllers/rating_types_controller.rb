class RatingTypesController < ApplicationController
  def index
    render json: {:results => RatingType.where("user_id = ? or user_id = ?", current_user.id, 0) }
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

end