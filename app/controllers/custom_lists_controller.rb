class CustomListsController < ApplicationController
  before_action :authenticate_user! #, only: [:show, :update, :destroy, :edit]

  def index
    user_id = params.fetch('user_id', current_user.id)
    list = List.includes(:films).where(user_id: user_id).order(name: :asc)
    results = params[:with_films] ? list.as_json(include: :films) : list
    render json: results
  end

  def create
    add_remove if params.has_key? :film_id

    list = List.create({user_id: current_user.id}.merge(custom_list_params))
    render json: list.to_h
  end

  def add_remove
    film = params.has_key?(:tmdb_id) ? Film.digest(params[:tmdb_id]).first : Film.find(params[:film_id]) 
    list = List.includes(:films).where(id: params[:list_id], user_id: current_user.id).first
    list.send(params[:list_action], film, params[:sort_order])
    render json: Enrich.new(current_user, list.films_to_h).enrich
  end

  def sort_order
    list = List.where(id: params[:list_id], user_id: current_user.id).first
    ordered_ids = params[:ordered_ids].split(',')
    list.set_sort_order(ordered_ids)
    render json: Enrich.new(current_user, list.films_to_h).enrich
  end

  def show
    list = List.includes(:films, :user).where(id: params[:id]).first
    all = params[:include_all] ? List.where(user_id: list.user_id) : []
    render json: {:list => Enrich.new(current_user, list.to_h).enrich, :all => all}
  end

  def update
    list = List.includes(:films, :user).where(id: params[:id]).first
    list.update(custom_list_params)
    render json: Enrich.new(current_user, list.to_h).enrich
  end

  def destroy
    List.find(params[:id]).destroy
  end

  private

  def custom_list_params
    params.permit(:name, :description)
  end

end