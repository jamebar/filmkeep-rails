class CallbacksController < Devise::OmniauthCallbacksController
    def facebook
        auth = request.env["omniauth.auth"]
        @user = User.from_omniauth(auth)
        sign_in_and_redirect @user
    end

    def google_oauth2
        auth = request.env["omniauth.auth"]
        @user = User.from_omniauth(auth)
        sign_in_and_redirect @user
    end
end