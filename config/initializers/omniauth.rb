Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Figaro.env.facebook_key, Figaro.env.facebook_secret
  provider :twitter, Figaro.env.twitter_key, Figaro.env.twitter_secret
  provider :linked_in, Figaro.env.linked_in_key, Figaro.env.linked_in_secret
  provider :google, Figaro.env.google_key, Figaro.env.google_secret
end
