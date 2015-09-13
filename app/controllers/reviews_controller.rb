class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :edit]
  before_action :digest_film, only: [:create]

  def index

    user = if params[:username]
      User.find_by_username(params[:username])
    else
      current_user
    end
    raise ApiError, "No user found" if user.blank?

    num = params.fetch(:num, 24).to_i
    page = params.fetch(:page, 1).to_i
    offset = num * (page - 1)
    sort_by = params.fetch(:sort_by, 'id')
    sort_direction = params.fetch(:sort_direction, 'desc')
    results = user.reviews
                     .offset(offset)
                     .order("#{sort_by} #{sort_direction}")

    render json: {:results => results.take(num), :total => user.reviews.count}
  end

  def create
    review = false
    ActiveRecord::Base.transaction do
      user_id = current_user.id
      review = Review.where(film_id: @film.id, user_id: user_id).first_or_initialize(review_params)
      
      if review.id.blank?
        review.save!
        params[:ratings].each do |rating|
          Rating.create!(review_id: review.id, rating_type_id: rating["rating_type_id"], value: rating["value"])
        end
      end
    end
    render json: review
  end

  def compares
    film_id = params[:film_id]
    user_id = current_user.id
    ids = followers = Follower.where(user_id: user_id).pluck(:follower_id)
    ids << user_id

    if followers
      reviews = Review.where(film_id: film_id, user_id: ids).take(30)
    end

    render json: reviews
  end

  def show
    review = Review.includes(:user).find(params[:id])
    reviews = Review.where(user: review.user_id).limit(50).order('created_at desc')
    output = review.serializable_hash.tap do |h|
      h[:user] = review.user
      h[:reviews] = reviews.map do |r|
        r.serializable_hash.tap do |h|
          h[:ratings] = r.ratings.index_by(&:rating_type_id)
        end
      end
    end
    render json: Enrich.new(current_user, output, true).enrich
  end

  def update
    review = Review.find(params[:id])
    review.update(review_params)
    params[:ratings].each do |rating|
      r = Rating.where(review_id: review.id, rating_type_id: rating["rating_type_id"]).first_or_initialize
      r.value = rating["value"]
      r.save!
    end

    render json: review
  end

  def destroy
  end

  private
  def review_params
    params.permit(:notes)
  end

  def digest_film
    raise ApiError, "A tmdb_id is required to add a review" unless params.has_key? :film
    @film = Film.digest(params[:film][:tmdb_id]).first
  end

end