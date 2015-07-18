class RatingTypesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :edit]
  
  def index
    render json: {results: RatingType.where("user_id = ? or user_id = ?", current_user.id, 0) }
  end

  def create
    render json: RatingType.create(user: current_user, label: params[:label])
  end

  def update
    rt = RatingType.where(user: current_user, id: params[:id]).first
    rt.update(label: params[:label])
    render json: true
  end

  def destroy
    RatingType.where(user: current_user, id: params[:id]).first.destroy
    render json: {results: RatingType.where("user_id = ? or user_id = ?", current_user.id, 0) }
  end

end