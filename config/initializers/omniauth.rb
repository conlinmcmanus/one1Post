Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['facebook_key'], ENV['facebook_secret']
  provider :twitter, ENV['twitter_key'], ENV['twitter_secret']
  provider :linkedin, ENV['linkedin_key'], ENV['linkedin_secret'], scope: 'r_basicprofile r_emailaddress w_share'
  provider :google_oauth2, ENV['google_key'], ENV['google_secret'], name: 'google', scope: 'email, profile, https://plus.google.com/', prompt: 'select_account'
end
