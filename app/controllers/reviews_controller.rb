class ReviewsController < ApplicationController
  def index

    user = if params[:username]
      User.find_by_username(params[:username])
    else
      current_user
    end
    num = params.fetch('num', 24).to_i
    page = params.fetch('page', 1).to_i
    offset = num * (page - 1)
    sort_by = params.fetch('sort_by', 'id')
    sort_direction = params.fetch('sort_direction', 'asc')
    results = user.reviews
                     .offset(offset)
                     .order({sort_by => sort_direction})

    render json: {:results => results.take(num), :total => user.reviews.count}
  end

  def create
  end

  def edit
  end

  def show
    review = Review.includes(:user).find(params[:id])
    output = review.serializable_hash.tap do |h|
      h[:user] = review.user
    end
    render json: Enrich.new(current_user, output, true).enrich
  end

  def update
  end

  def destroy
  end

end