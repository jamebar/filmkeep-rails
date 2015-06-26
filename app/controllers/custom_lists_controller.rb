class CustomListsController < ApplicationController
  def index
    user_id = params.fetch('user_id', current_user.id)
    list = List.includes(:films).where(user_id: user_id).order(name: :asc)
    results = params[:with_films] ? list.as_json(include: :films) : list
    render json: results
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