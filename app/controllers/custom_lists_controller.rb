class CustomListsController < ApplicationController
  before_action :authenticate_user! #, only: [:show, :update, :destroy, :edit]

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
    list = List.includes(:films, :user).where(id: params[:id]).first
    all = []
    all = List.where(user_id: list.user_id) if params[:include_all]
    output = list.serializable_hash
    render json: {:list => Enrich.new(current_user, output).enrich, :all => all}
  end

  def update
  end

  def destroy
  end

end