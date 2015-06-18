class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable, omniauth_providers: [:facebook, :google_oauth2]

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

end
