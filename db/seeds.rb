require 'faker'

5.times do 
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: '123456'
    )
end

15.times do
  Post.create!(
    body: Faker::Hipster.paragraph,
    user_id: User.all.sample
    )
end