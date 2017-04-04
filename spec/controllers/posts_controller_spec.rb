require 'rails_helper'
require 'faker'

RSpec.describe PostsController, type: :controller do
  let(:user) { User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: '123456') }

  before { sign_in(user) }

  render_views

  let(:valid_attributes) { { body: Faker::Hipster.paragraph, user_id: user.id } }

  let(:invalid_attributes) { { body: '', user_id: user.id } }

  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns all posts by a specific user as @posts' do
      post = Post.create! valid_attributes
      get :index, params: {}, sessions: valid_session
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe 'GET new' do
    it 'assigns a new post as @post' do
      get :new, params: {}, session: valid_session
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new post' do
        expect { post :create, params: { post: valid_attributes }, session: valid_session }.to change(Post, :count).by(1)
      end
    end
  end

  describe 'GET edit' do
    it 'assigns the requested post as @post' do
      post = Post.create! valid_attributes
      get :edit, params: { id: post.to_param }, session: valid_session
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'POST update' do
    context 'with valid params' do
      let(:new_attributes) { { body: 'a new post' } }
      it 'updates an existing post' do
        post = Post.create! valid_attributes
        put :update, params: { id: post.to_param, post: new_attributes }, session: valid_session
        post.reload
        expect(post.body).to eq('a new post')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the selected post' do
      post = Post.create! valid_attributes
      expect { delete :destroy, params: { id: post.id }, session: valid_session }.to change(Post, :count).by(-1)
    end
  end
end
