class Identity < ApplicationRecord
  belongs_to :user
  belongs_to :provider
  validates_presence_of :uid
  validates_uniqueness_of :uid

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, oauth_token: auth.credentials.token, oauth_secret: auth.credentials.secret)
  end
end
