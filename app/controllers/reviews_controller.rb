class ReviewsController < ApplicationController
  def index

    user = if params[:username]
      User.find_by_username(params[:username])
    else
      current_user
    end
    num = params.fetch('num', 24)
    page = params.fetch('page', 1)
    offset = num * (page - 1)
    sort_by = params.fetch('sort_by', 'id')
    sort_direction = params.fetch('sort_direction', 'asc')
    results = user.reviews
                     .offset(offset)
                     .order({sort_by => sort_direction})

    render json: {:results => results.take(num), :total => results.count}
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