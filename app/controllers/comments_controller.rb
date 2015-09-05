class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :destroy, :update]

  def index
    object = klass(params[:type], params[:type_id])
    results = object.comments || []
    render json: results
  end

  def create
    object = klass(params[:type], params[:type_id])
    results = object.comments.create(user_id: current_user.id, comment: params[:description], spoiler: params.has_key?(:spoiler), film_id: params[:film_id])
    render json: results
  end

  def show
    render json: Comment.find(params[:id])
  end

  def destroy
    render json: Comment.where(id: params[:id], user_id: current_user.id).first.destroy
  end

  private
  def klass(type, id)
    case type
    when 'review' then Review.find(id)
    when 'watchlist' then Watchlist.find(id)
    end
  end

end