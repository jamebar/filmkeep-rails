class FollowersController < ApplicationController
  before_action :authenticate_user!
  
  def follow
    current_user_id = current_user.id
    f = Follower.where(user_id: current_user_id, follower_id: params[:follower_id]).first_or_create
    puts "follower: #{f.inspect}"
    puts current_user_id
    #follow the feed
    StreamRails.feed_manager.follow_user(current_user_id, params[:follower_id])
    render json: Follower.select('followers.*, users.name, users.avatar, users.username').joins('join users on follower_id = users.id').where(user_id: current_user_id)
    
  end

   def unfollow
    current_user_id = current_user.id
    Follower.where(user_id: current_user_id, follower_id: params[:follower_id]).destroy_all

    #unfollow the feed
    StreamRails.feed_manager.unfollow_user(current_user_id, params[:follower_id])

    render json: Follower.select('followers.*, users.name, users.avatar, users.username').joins('join users on follower_id = users.id').where(user_id: current_user_id)
    
  end

end