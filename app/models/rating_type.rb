class RatingType < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  belongs_to :user

  def self.default_scope
    order('user_id asc')
  end
end