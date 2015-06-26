class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :followers
  has_many :reviews

  before_create :ensure_username_uniqueness

  def self.from_omniauth(auth)
    user = where("#{auth.provider}_id = ? OR email = ?", auth.uid, auth.info.email).first
    return user.update_from_omniauth(auth) if user

    self.create( "#{auth.provider}_id" => auth.uid, email: auth.info.email, name: auth.info.name, avatar: auth.info.image, password: Devise.friendly_token[0,20], confirmed_at: Time.now() )
  end

  def update_from_omniauth(auth)
    new_info = {"#{auth.provider}_id" => auth.uid}
    new_info[:avatar] = auth.info.image if avatar.blank?
    update(new_info)
    self
  end

  def ensure_username_uniqueness
    if self.username.blank? || User.where(username: self.username).count > 0
      username_part = self.name.blank? ? self.email.split("@").first : self.name.split(" ").first
      new_username = username_part.dup 
      num = 2
      while(User.where(username: new_username).count > 0)
        new_username = "#{username_part}#{num}"
        num += 1
      end
      self.username = new_username
    end
  end

end
