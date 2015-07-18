class MeController < ApplicationController
  before_action :authenticate_user!
  def me
    user = User.includes('followers').where(id: current_user.id).first
  end

  def index
    hash = me.serializable_hash.tap do |h|
      h[:new] = user.reviews.count < 1
      h[:followers] = user.followers
    end
    # user[:new] = user.reviews.count < 1
    render json: {me: hash, response: 'success', announcements: []}
  end


end