class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %{
      def #{provider}
        @user = User.from_omniauth(env["omniauth.auth"], current_user)

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

  %w[twitter facebook linkedin google_oauth2].each do |provider|
    provides_callback_for provider
  end
end
