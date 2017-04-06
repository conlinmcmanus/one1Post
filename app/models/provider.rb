class Provider < ApplicationRecord
  has_many :identities
  validates_presence_of :name

  def self.find_for_oauth(auth)
    find_or_create_by(name: auth.provider)
  end
end
