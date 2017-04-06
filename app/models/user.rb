class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'.freeze
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter linkedin google_oauth2]

  has_many :posts, dependent: :delete_all
  has_many :identities, dependent: :delete_all
  has_many :providers, through: :identities

  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    provider = Provider.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    return user if user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save!
      end
      if identity.user != user
        identity.user = user
        identity.provider = provider
        provider.save!
        identity.save!
      end
    end
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end
end
