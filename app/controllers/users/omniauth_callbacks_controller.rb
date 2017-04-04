class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "#{provider}".capitalize
          sign_in_and_redirect @user, event: :authentication
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
          redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
      end
    }
  end

  %w[twitter facebook linkedin google].each do |provider|
    provides_callback_for provider
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(name: data['name'], email: data['email'], password: Devise.friendly_token[0, 20])
    end
    user
  end
end
